CREATE TABLE PRODUCTS (
ID INTEGER NOT NULL AUTO_INCREMENT,
NAME VARCHAR(255) NOT NULL,
DESCRIPTION VARCHAR(32000) NOT NULL,
PRICE FLOAT,
ID_SHOP INTEGER NOT NULL,
PRIMARY KEY (ID),
FOREIGN KEY (ID_SHOP) REFERENCES SHOPS (ID));


insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('','',,);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('iphone','smartphone',800,1);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('ipad','tablet',450,1);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('mac','pc',1200,1);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('iphone','smartphone',800,2);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('airpods','cuffie bluetooth',159,2);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('apple watch','smartwatch',369,2);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('grand theft auto 5','videogioco bello',60,4);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('battlefield','videogioco di guerra',65,4);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('forza motorsport','videogioco di macchine',35,4);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('batman','videogioco di batman',55,5);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('vr simulator','videogioco in realtà virtuale',75,5);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('samsung smarttv','tv di ultima generazione, 4K, 55pollici',1200,6);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('frigorifero','frigorifero',500,6);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('sony smarttv','tv di ultima generazione, 4K, 45pollici',1050,6);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('samsung smarttv','tv di ultima generazione, 4K, 50pollici',1100,7);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('asus zenfone','smartphone asus',350,7);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('lg g4','smartphone lg',310,7);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('casse','casse bluetooth portatili',150,8);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('cuffie','cuffie bluetooth',150,8);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('runner','scarpe da corsa nike',120,9);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('airmax 95','scarpe da ginnastica nike',125,9);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('airmax shirt','tshirt con logo airmax',35,9);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('lewis 507m','jeans lewis blu uomo',95,10);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('lewis 507d','jeans lewis blu donna',95,10);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('','',,);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('completo uomo','completo in tessuto',750,11);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('vestito donna','abito da sera',800,11);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('iclimb','set di attrezzature per climber',300,12);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('telo','telo da mare',10,12);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('traspirant','magletta traspirante',18,12);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('harry potter 1','hp libro 1',19,13);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('harry potter 2','hp libro 2',15,13);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('harry potter 3','hp libro 3',15,13);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('il signore degli anelli','libro',12,14);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('piccoli brividi','libro per bambini',9.90,14); /*---------*/
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('la ragazza del treno','libro thriller',10.50,14); /*------------*/

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('ftype','sportcar, 550hp',75000,15);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('fpace','suv dalle elevate prestazioni, 400hp',55000,15);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('fiat 500 595','versione performante della 500, nuova',32000,16);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('toyota yaris','city car nuova',15000,16);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('toyota yaris hybrid','city car usata, 20000',10000,16);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('alfaromeo giulia','versione quadrifoglio, 0km',45000,17);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('suzuki','moto',18000,17);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('ktm','moto',10000,17);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('asse da stiro','asse da stiro ripieghevole',33,18); 
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('candele','confezioni di candele profumate 15',5,18);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('tovaglia','tovaglia di plastica per feste',10,18);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('decespugliatore','decespugliatore elettrico',450,19);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('taglia erba','taglia erba a carburante, per grandi giardini',170,19);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('robot tagliaerba','robot automatizzato, con controllo remoto',400,19);

insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('trapano','trapano elettrico',55,20);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('motosega','motosega potenziata per deforestazione',260,20);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('viti e bulloni','set di viti e bulloni, varie dimensioni',12,20);


insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('','',,21);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('','',,21);
insert into product (NAME,DESCRIPTION,PRICE,ID_SHOP) values ('','',,21);












































































