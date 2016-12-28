install.packages("DBI")
install.packages("RODBCext")
install.packages("RODBC")
install.packages("class")
install.packages("pracma")

library(DBI)
library(RODBCext)
library(RODBC)
library(class)
library(pracma)

# table initialize
tableCreate <- function() {
  
  sqlExecute(db,"CREATE TABLE firstcluster ( clusterId int not null, constraint pk_firstcluster primary key (clusterId) )")
  sqlExecute(db,"create table secondcluster (clusterId int not null,inc_avgMax int, constraints pk_cluster primary key (clusterId) )")
  sqlExecute(db,"create table firstcluster_map (firstFk int,clusterId int not null,secondFk int,constraint pk_firstcluster_map primary key(clusterId),constraint fk1_firstcluster_map foreign key (firstFk) references firstcluster (clusterId) on delete cascade, constraint fk2_firstcluster_map foreign key (secondFk) references secondcluster (clusterId) on delete cascade)")
  sqlExecute(db,"CREATE TABLE firstcluster_contents (clusterId int not null, dates int not null,diff int, sequence int,constraint pk_firstcluster_contents primary key (clusterId,dates), constraint fk_firstcluster_contents foreign key (clusterId) references firstcluster_map (clusterId) on delete cascade)")
  
  sqlExecute(db,"CREATE TABLE stock ( symbol varchar2(20) not null,firstFk int,constraint pk_stock primary key (symbol),constraint fk_stock foreign key (firstFk) references firstcluster (clusterId))")
  sqlExecute(db,"CREATE TABLE stock_contents (symbol varchar2(20) not null, dates int not null,diff int, sequence int,constraint pk_stock_contents primary key (symbol,dates), constraint fk_stock_contents foreign key (symbol) references stock (symbol) on delete cascade)")
  
  
  
}

# table drop
tableDrop <- function() {
  sqlExecute(db,"drop table firstcluster_contents")
  sqlExecute(db,"drop table stock_contents")
  sqlExecute(db,"drop table first_second_map")
  sqlExecute(db,"drop table stock")
  sqlExecute(db,"drop table firstcluster")
  sqlExecute(db,"drop table secondcluster")
  sqlExecute(db,"purge recyclebin")
}

# stock_contents_insert
stock_contents_insert <- function() {
  query <- paste0("select distinct dates from nasdaq where dates <=20160217 order by dates asc")
  temp <- sqlQuery(db,query)
  sqlExecute(db,"create sequence seq start with 1")
  sqlExecute(db,"select seq.nextval from dual")
  for(i in 1:(nrow(temp)-1))
  {
      query <- paste0("insert into stock_contents (symbol,dates,diff,sequence) select a.symbol,a.dates,b.high-a.high,seq.currval from (select symbol,high,dates from nasdaq where dates='",temp[i,1],"') a, (select symbol,high from nasdaq where dates='",temp[i+1,1],"') b where a.symbol=b.symbol")
      sqlExecute(db,query)
      sqlExecute(db,"select seq.nextval from dual")
    
  }
  sqlExecute(db,"drop sequence seq")
  
}



# secondcluster_insert
secondcluster_insert <- function(){
  
  # secondcluster 
  # we divide firstcluster into small piece that have 22 date range
  # ex) date sequence 1~22 2~23 3~24 ...
  clusterid <- sqlQuery(db,"select distinct clusterId from firstcluster_contents order by clusterId asc")
  firstid <- sqlQuery(db,"select clusterid from firstcluster order by clusterid asc")
  
  query <- paste0("select diff from firstcluster_contents where clusterId = ",clusterid[1,1],"order by dates asc")
  temp = unlist(sqlQuery(db,query))
  clusterMatrix = matrix(temp[1:22],ncol=22)
  
  savedid=1;
  index=2
  for(i in 2:22)
  {
    query <- paste0("select diff from firstcluster_contents where clusterId = ",clusterid[i,1],"order by dates asc")
    temp = unlist(sqlQuery(db,query))
    clusterMatrix = rbind(clusterMatrix,temp)
    savedid[index]=i;
    index=index+1;
  }
  

  for(i in 2:nrow(firstid))
  {
    for(j in 1:22)
    {
      query <- paste0("select diff from firstcluster_contents where clusterId = ",clusterid[(i-1)*44+j,1],"order by dates asc")
     temp = unlist(sqlQuery(db,query))
     clusterMatrix = rbind(clusterMatrix,temp)
     savedid[index]=(i-1)*44+j;
     index=index+1;
     print((i-1)*44+j)
    }
  }
  
  
  
  # kmean clustering 
  kclust <- kmeans(clusterMatrix,1)
  vecwithinss = kclust$withinss[1];
  
  for(i in 2:(nrow(firstid)*22))
  {
    kclust <- kmeans(clusterMatrix,(i))
    temp =0;
    for(j in 1:i)
    {
      temp=temp+kclust$withinss[j];
    }
    
    vecwithinss[i]=temp;
    print(vecwithinss[i])
  }
  
  write(vecwithinss,"secondcluster",sep="\n")
  plot(vecwithinss)
  
  #  k = 269 is the best number of clusters  
  kcluster <- kmeans(clusterMatrix,269)
  kcluster$cluster[1]
 
  for(i in 1:269)
  {
    query <- paste0("insert into secondcluster values (",i,",0)");
    sqlExecute(db,query)
  }
  
 

  # table update
  for(i in 1:(length(savedid)))
  {
    query <- paste0("select diff from firstcluster_contents where clusterId=",savedid[i]+22," order by dates asc")
    result = sqlQuery(db,query)
    max=0;  
    query <- paste0("update firstcluster_map set secondfk=",kcluster$cluster[i]," where clusterid =",savedid[i])
    sqlExecute(db,query)
     
    for(j in 1:22)
    {
      if(result[j,1]>max)
        max = result[j,1]
        
    }
      
    query <- paste0("update secondcluster set inc_avgMax=inc_avgMax+",max," where clusterId=",kcluster$cluster[i])
    sqlExecute(db,query)
  }

  for(i in 1:269)
  {
    query <- paste0("select count(*) from firstcluster_map where secondfk =",i)
    num = sqlQuery(db,query)
    query <- paste0("update secondcluster set inc_avgMax=inc_avgMax/",num," where clusterId=",i)
    sqlExecute(db,query)
  }
 
  
  # knn deter
  # make training set 
  query <- paste0("select diff from firstcluster_contents where clusterId=",savedid[1]," order by dates asc")
  result = sqlQuery(db,query)
  result = t(result)
  train = rbind(result)
  query <- paste0("select inc_avgMax from secondcluster a,(select secondfk from firstcluster_map where clusterid=",savedid[1],") b where b.secondfk=a.clusterid")
  cl = sqlQuery(db,query)
  index = 2;
  
  
  for(i in 2:length(savedid))
  {
    query <- paste0("select diff from firstcluster_contents where clusterId=",savedid[i]," order by dates asc")
    result = sqlQuery(db,query)
    result = t(result)
    train = rbind(train,result)
    query <- paste0("select inc_avgMax from secondcluster a,(select secondfk from firstcluster_map where clusterid=",savedid[i],") b where b.secondfk=a.clusterid")
    cl[index] = sqlQuery(db,query)
    index=index+1;
  }
  
  # make test set 
  symbols <- sqlQuery(db,"select distinct symbol from stock_contents")
  query <- paste0("select diff from stock_contents where symbol='",symbols[1,1],"' and sequence>=44order by dates asc")
  result = sqlQuery(db,query)
  result = t(result)
  test = rbind(result)
  for(i in 2:nrow(symbols))
  {
    query <- paste0("select diff from stock_contents where symbol='",symbols[i,1],"' and sequence>=44order by dates asc")
    result = sqlQuery(db,query)
    result = t(result)
    test = rbind(test,result)
  }
  
  # the real contains result of real world that we interest in 
  query <- paste0("select distinct a.symbol from (select high,symbol from nasdaq where dates>20160217) a,(select close,symbol from nasdaq where dates=20160217) b where a.high>=(b.close*1.1) and a.symbol=b.symbol")
  real = sqlQuery(db,query)
  
  cl = factor(as.numeric(cl))  
  knnret = knn1(train, test, cl)
  knnret = as.numeric(knnret)
  
  # we compare out predict with real to calculate the our accuracy
  misscount=0;
  hitcount=0;
  total=0;
  for(i in 1:nrow(symbols))
  {
    query <- paste0("select high-close,close from nasdaq where symbol='",symbols[i,1],"' and dates=20160217")
    result = sqlQuery(db,query)
    temp = as.numeric(result[1]+knnret[i])
    temp2 = as.numeric(result[2]*1.1)  
    if(temp>=(temp2))
    {
      
        check=0;
        source = as.vector(symbols[i,1])
        for(j in 1:nrow(real))
        {
          dest = as.vector(real[j,1])
          if(strcmp(source,dest))
          {
            check=1;
            print(paste0("hit : ",as.vector(symbols[i,1])))
            hitcount=hitcount+1;
          }
        }
        
        if(check==0)
        {
          print(paste0("miss : ",as.vector(symbols[i,1])))
          misscount=misscount+1;
        }
        
        total = total+1;
    }
    
  }
  
  print(paste0("hit count :",hitcount," miss count :",misscount," total count :",total))
 
}





#firstcluster_insert
firstcluster_insert <- function() {
  
    # firstcluster reduce problem space
    # we use diff to group the stock 
    symbols <- sqlQuery(db,"select distinct symbol from stock_contents")
    query <- paste0("select diff from stock_contents where symbol = '",symbols[1,1],"' order by dates asc")
    temp = unlist(sqlQuery(db,query))
    pointMatrix = matrix(temp,ncol=65)

 
    for(i in 2:nrow(symbols))
    {
      query <- paste0("select diff from stock_contents where symbol = '",symbols[i,1],"' order by dates asc")
      temp = unlist(sqlQuery(db,query))
      pointMatrix = rbind(pointMatrix,temp)
      print(i)
    }
    
    
    # firstcluster clustering
     kclust <- kmeans(pointMatrix,1)
     vecwithinss = kclust$withinss[1];
    
     for(i in 2:(nrow(symbols)))
     {
       kclust <- kmeans(pointMatrix,(i))
       temp =0;
       for(j in 1:i)
       {
         temp=temp+kclust$withinss[j];
       }
       print(i);
       vecwithinss[i]=temp;
     }
     
   
    write(vecwithinss,"firstcluster",sep="\n")
    plot(vecwithinss)
    
    #  k = 211 is the best number of clusters  
    kcluster <- kmeans(pointMatrix,211)
   
    # fircluster table content update
    query <- paste0("select distinct dates from nasdaq where dates <=20160217 order by dates asc")
    temp <- sqlQuery(db,query)
  
   
    
    sqlExecute(db,"create sequence seq start with 1")
    sqlExecute(db,"select seq.nextval from dual")
    for(i in 1:211)
    {
      print(i)
      query <- paste0("insert into firstcluster values (",i,")");
      sqlExecute(db,query)
      
      for(j in 1:44)
      {
        query <- paste0("insert into firstcluster_map values (",i,",seq.currval,NULL)") 
        sqlExecute(db,query)
        
        for(k in 1:22)
        {
          query <- paste0("insert into firstcluster_contents values (seq.currval,",temp[(k+j-1),1],",",kcluster$centers[i,(k+j-1)],",",k,")")
          sqlExecute(db,query)
        }
      
        sqlExecute(db,"select seq.nextval from dual")
      }
     
      
    }
    sqlExecute(db,"drop sequence seq")
  
    
    
    for(i in 1:(nrow(symbols)))
    {
      query <- paste0("update stock set firstFk=",kcluster$cluster[i]," where symbol='",symbols[i,1],"'")
      sqlExecute(db,query)
    }
    
}

# insert Data
insertData <- function() {
   
  # stock insert
  sqlExecute(db,"insert into stock (symbol) select distinct (symbol) from nasdaq")
  
  # stock_contents insert 
  stock_contents_insert()
  
  # firstcluster insert 
  firstcluster_insert()
  
  # cluster insert 
  secondcluster_insert()  
  

  
}
  
# remove imperfect symbol
removeImperfect <- function(){
  sqlExecute(db,"delete from nasdaq where symbol in (select symbol from nasdaq group by symbol having count(*) < (select count(distinct dates) from nasdaq))")
}





db <<- odbcConnect("jk","jk","powerkk",believeNRows=FALSE)
tableCreate()
removeImperfect()
tableDrop()
odbcCloseAll()



