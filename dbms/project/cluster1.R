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
  
  sqlExecute(db,"create table firstcluster (clusterId int not null,inc_avgMax number(20,3), constraints pk_cluster primary key (clusterId) )")
  sqlExecute(db,"CREATE TABLE stock ( symbol varchar2(20) not null,constraint pk_stock primary key (symbol) )")
  
  sqlExecute(db,"create table firstcluster_map (stockFk varchar2(20),stockId int not null,firstFk int,constraint pk_firstcluster_map primary key(stockfk,stockId),constraint fk1_firstcluster_map foreign key (stockFk) references stock (symbol) on delete cascade, constraint fk2_firstcluster_map foreign key (firstFk) references firstcluster (clusterId) on delete cascade)")
  
 
  sqlExecute(db,"CREATE TABLE stock_contents (symbol varchar2(20) not null, dates int not null,highdiff number(20,3),lowdiff number(20,3),closediff number(20,3), sequence int,constraint pk_stock_contents primary key (symbol,dates), constraint fk_stock_contents foreign key (symbol) references stock (symbol) on delete cascade)")
  
  
  
}

# table drop
tableDrop <- function() {
  sqlExecute(db,"drop table stock_contents")
  sqlExecute(db,"drop table firstcluster_map")
  sqlExecute(db,"drop table firstcluster")
  sqlExecute(db,"drop table stock")
  

  sqlExecute(db,"purge recyclebin")
}

# stock_contents_insert
stock_contents_insert <- function() {
  query <- paste0("select distinct dates from realstock where dates <=20160523 order by dates asc")
  temp <- sqlQuery(db,query)
  sqlExecute(db,"create sequence seq start with 1")
  sqlExecute(db,"select seq.nextval from dual")
  for(i in 1:(nrow(temp)-1))
  {
   
    query <- paste0("insert into stock_contents (symbol,dates,highdiff,lowdiff,closediff,sequence) select a.symbol,a.dates,(b.high-a.high)/a.high,(b.low-a.low)/a.low,(b.close-a.close)/a.close,seq.currval from (select symbol,high,low,close,dates from realstock where dates='",temp[i,1],"') a, (select symbol,high,low,close from realstock where dates='",temp[i+1,1],"') b where a.symbol=b.symbol")
   
    sqlExecute(db,query)
    sqlExecute(db,"select seq.nextval from dual")
    
  }
  sqlExecute(db,"drop sequence seq")
  
}



#firstcluster_insert
firstcluster_insert <- function() {
  
  # firstcluster reduce problem space
  # we use diff to group the stock 
  symbols <- sqlQuery(db,"select distinct symbol from stock order by symbol")
  
  query <- paste0("select highdiff,lowdiff,closediff from stock_contents where symbol = '",symbols[1,1],"' order by dates asc")
  temp = sqlQuery(db,query)
  result = unlist(temp[1:24,1])
  result = append(result,unlist(temp[1:24,2]))
  result = append(result,unlist(temp[1:24,3]))
  clusterMatrix = matrix(result,ncol=72)
 
  
  savedid=1;
  index=2
  for(i in 2:189)
  {
    query <- paste0("select highdiff,lowdiff,closediff from stock_contents where symbol = '",symbols[1,1],"' order by dates asc")
    temp = sqlQuery(db,query)
    result = unlist(temp[i:(i+23),1])
    result = append(result,unlist(temp[i:(i+23),2]))
    result = append(result,unlist(temp[i:(i+23),3]))
    clusterMatrix = rbind(clusterMatrix,result)
    savedid[index]=i;
    index=index+1;
  }

  for(i in 2:nrow(symbols))
  {
    print(i)
    for(j in 1:189)
    {
      query <- paste0("select highdiff,lowdiff,closediff from stock_contents where symbol = '",symbols[i,1],"' order by dates asc")
      temp = sqlQuery(db,query)
      result = unlist(temp[j:(j+23),1])
      result = append(result,unlist(temp[j:(j+23),2]))
      result = append(result,unlist(temp[j:(j+23),3]))
      clusterMatrix = rbind(clusterMatrix,result)
      savedid[index]=i;
      index=index+1;
    }
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
  
  #  k = 260 is the best number of clusters  
  kcluster <- kmeans(clusterMatrix,260)
  
 
  for(i in 1:260)
  {
    query <- paste0("insert into firstcluster values (",i,",0)");
    sqlExecute(db,query)
  }
  
  
 
  # table update
  for(i in 1:(nrow(symbols)))
  {
    
    
    query <- paste0("select high from realstock where symbol='",symbols[i,1],"' order by dates asc")
    highresult = sqlQuery(db,query)
    
    print(i)
    for(j in 1:189)
    {
      query <- paste0("insert into firstcluster_map values ('",symbols[i,1],"',",j,",",kcluster$cluster[((i-1)*189)+j],")")
      sqlExecute(db,query)
      max=0  
      for(k in 1:23)
      {
        temp = (highresult[j+24+k,1]-highresult[j+24,1])/highresult[j+24,1]
        if(temp>max)
          max = temp
      }
      
   
      query <- paste0("update firstcluster set inc_avgMax=inc_avgMax+",max," where clusterId=",kcluster$cluster[((i-1)*189)+j])
      sqlExecute(db,query)
    
    }
    
  }
  
  for(i in 1:260)
  {
    query <- paste0("select count(*) from firstcluster_map where firstfk =",i)
    num = sqlQuery(db,query)
    print(num)
    query <- paste0("update firstcluster set inc_avgMax=inc_avgMax/",num," where clusterId=",i)
    sqlExecute(db,query)
  }
  
  
  # knn deter
  # make training set 
  query <- paste0("select diff from stock_contents where symbol='",symbols[1,1],"' order by dates asc")
  result = sqlQuery(db,query)
  result = t(result[1:24,1])
  train = rbind(result)
  query <- paste0("select inc_avgMax from firstcluster a,(select firstfk from firstcluster_map where stockfk='",symbols[1,1],"' and stockid=1) b where b.firstfk=a.clusterid")
  cl = sqlQuery(db,query)
  
  for(i in 2:189)
  {
    query <- paste0("select diff from stock_contents where symbol='",symbols[1,1],"' order by dates asc")
    result = sqlQuery(db,query)
    result = t(result[i:(23+i),1])
    train = rbind(train,result)
    query <- paste0("select inc_avgMax from firstcluster a,(select firstfk from firstcluster_map where stockfk='",symbols[1,1],"' and stockid=",i,") b where b.firstfk=a.clusterid")
    result = sqlQuery(db,query)
    cl = rbind(cl,result)
  }
  
  for(i in 2:nrow(symbols))
  {
    query <- paste0("select diff from stock_contents where symbol='",symbols[i,1],"' order by dates asc")
    result = sqlQuery(db,query)
    result = t(result[1:24,1])
    train = rbind(train,result)
    query <- paste0("select inc_avgMax from firstcluster a,(select firstfk from firstcluster_map where stockfk='",symbols[i,1],"' and stockid=1) b where b.firstfk=a.clusterid")
    result = sqlQuery(db,query)
    cl = rbind(cl,result)
    
    for(j in 2:189)
    {
      query <- paste0("select diff from stock_contents where symbol='",symbols[i,1],"' order by dates asc")
      result = sqlQuery(db,query)
      result = t(result[j:(23+j),1])
      train = rbind(train,result)
      query <- paste0("select inc_avgMax from firstcluster a,(select firstfk from firstcluster_map where stockfk='",symbols[i,1],"' and stockid=",j,") b where b.firstfk=a.clusterid")
      result = sqlQuery(db,query)
      cl = rbind(cl,result)
    }
  }
  
  # make test set 
  query <- paste0("select diff from stock_contents where symbol='",symbols[1,1],"' order by dates asc")
  result = sqlQuery(db,query)
  result = t(result[213:236,1])
  test = rbind(result)
 
  for(i in 2:nrow(symbols))
  {
    query <- paste0("select diff from stock_contents where symbol='",symbols[i,1],"' order by dates asc")
    result = sqlQuery(db,query)
    result = t(result[213:236,1])
    test = rbind(test,result)
  }
  
  # the real contains result of real world that we interest in 
  query <- paste0("select distinct a.symbol from (select high,symbol from realstock where dates>20160523) a,(select close,symbol from realstock where dates=20160523) b where a.high>=(b.close*1.1) and a.symbol=b.symbol")
  real = sqlQuery(db,query)
  
  cl
  cl2 = factor(as.numeric(unlist(cl)))  
  knnret = knn1(train, test, cl2)
  knnret =as.vector(knnret)
  knnret = as.double(knnret)
  
  knnret
  # we compare out predict with real to calculate the our accuracy
  misscount=0;
  hitcount=0;
  total=0;
  save=0;
  index=1;
  for(i in 1:nrow(symbols))
  {
    query <- paste0("select high-close,close from realstock where symbol='",symbols[i,1],"' and dates=20160523")
    result = sqlQuery(db,query)
    temp = as.numeric(result[1]+knnret[i])
    temp2 = as.numeric(result[2]*0.1) 

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
          
          print(paste0("hit : ",as.vector(symbols[i,1])," ",temp-temp2," ",knnret[i]))
          hitcount=hitcount+1;
        }
      }
      
      if(check==0)
      {
        print(paste0("miss : ",as.vector(symbols[i,1])," ",temp-temp2," ",knnret[i]))
        misscount=misscount+1;
      }
      
      total = total+1;
    }
    
  }
  write(save,"rate",sep="\n")

  write(symbols,"symbol")
  print(paste0("hit count :",hitcount," miss count :",misscount," total count :",total))
  
}

# insert Data
insertData <- function() {
  
  # stock insert
  sqlExecute(db,"insert into stock (symbol) select distinct (symbol) from realstock")
  
 
  # firstcluster insert 
  firstcluster_insert()
  
 
  
  
}

# remove imperfect symbol
removeImperfect <- function(){
  sqlExecute(db,"delete from realstock where symbol in (select symbol from realstock group by symbol having count(*) < (select count(distinct dates) from realstock))")
}

db <<- odbcConnect("jk","jk","powerkk",believeNRows=FALSE)
tableCreate()
removeImperfect()
tableDrop()
odbcCloseAll()



