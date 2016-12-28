library(DBI)
library(RODBCext)
library(RODBC)

db <- odbcConnect("DB","jk","powerkk")

res <- sqlQuery(db,"select * from tab")

db
res
res <- sqlExecute(db,"insert into stock values('ab')")
res <- sqlExecute(db,"create table test(test int)")
res

# table initialize
tableCreate <- function() {
  sqlExecute(db,"CREATE TABLE stock ( symbol varchar2(20) not null, constraint pk_stock primary key (symbol) )")
  sqlExecute(db,"CREATE TABLE stock_contents (symbol varchar2(20) not null, dates int not null,diff int,constraint pk_stock_contents primary key (symbol,dates), constraint fk_stock_contents foreign key (symbol) references stock (symbol) on delete cascade)")
  sqlExecute(db,"create table groups (groupId int not null,type int , inc_rate int, constraints pk_group primary key (groupId) )")
  sqlExecute(db,"create table stock_group_map (symbol varchar2(20) not null,groupId int not null, constraint pk_stock_group_map primary key(symbol,groupId), constraint fk_stock foreign key (symbol) references stock (symbol) on delete cascade, constraint fk_group foreign key (groupId) references groups (groupId) on delete cascade)")

}