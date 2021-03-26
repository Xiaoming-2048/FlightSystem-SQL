create database FlightSystem
on primary(
name=FlightSystem_data,
filename='D:\DataBase\FlightSystem_data.mdf',
size=30,
maxsize=600,
filegrowth=10%
)
log on(
name=FlightSystem_log,
filename='D:\DataBase\FlightSystem_log.ldf',
size=30MB,
maxsize=600MB,
filegrowth=10%
)
go

use flightsystem
create table airport(
ano			char(3) primary key
			check(ano like '[A-Z][A-Z][A-Z]'),
aname		varchar(20),
city		varchar(10),
atel		varchar(15)
)

create table passenger(
pno			char(18) primary key
			check(pno like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9X]'),
pname		varchar(20),
sex			char(2)
			check(sex in ('男','女')),
ptel		varchar(15)
)

create table flight(
fno			char(10) primary key,
fcompany	varchar(20),
ftype		varchar(30),
dtime		time,
dano		char(3),
dterminal	varchar(5),
atime		time,
aano		char(3),
aterminal	varchar(5)
foreign key(dano) references airport(ano),
foreign key(aano) references airport(ano)
)

create table price(
fno			char(10),
fdate		date,
price		int default null,
sprice		int default null,
primary key(fno,fdate),
foreign key(fno) references flight(fno)
)

create table orders(
ono			char(20) primary key,
fno			char(10),
fdate		date,
sno			char(3),
pno			char(18),
bprice		int,
aboard		char(6) default '未登机'
			check(aboard in ('未登机','已登机')),
foreign key(fno,fdate) references price(fno,fdate),
foreign key(pno) references passenger(pno)
)

create table seat(
fno			char(10),
fdate		date,
sno			char(3),
ono			char(20) default '',
primary key(fno,fdate,sno),
foreign key(fno,fdate) references price(fno,fdate)
)

create table status
(fno char(10),
fdate datetime,
dtime time,
dstatus char(10),
dstatus_time char(10),
dtime_real time,
atime time,
astatus char(10),
astatus_time char(10),
atime_real time,
primary key(fno,fdate))
