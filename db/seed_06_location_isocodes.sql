--locations.region_iso
update locations
set region_iso = 'PH-00'
where denorm_name like '%QUEZON CITY%'
  OR denorm_name like '%NCR - MANILA%'
  OR denorm_name like '%PASIG%'
  OR denorm_name like '%TAGUIG%'
  OR denorm_name like '%VALENZUELA%'
  OR denorm_name like '%PARA%QUE%'
  OR denorm_name like '%LAS PI%AS%'
  OR denorm_name like '%MAKATI%'
  OR denorm_name like '%MUNTINLUPA%'
  OR denorm_name like '%NCR%';

update locations
set region_iso = 'PH-01'
where denorm_name like '%ILOCOS%'
  or denorm_name like '%LA UNION%'
  or denorm_name like '%PANGASINAN%';

update locations
set region_iso = 'PH-02'
where (denorm_name like '%CAGAYAN%' and denorm_name not like '%DE ORO%')
  or denorm_name like '%BATANES%'
  or denorm_name like '%ISABELA%'
  or denorm_name like '%NUEVA VIZCAYA%'
  or denorm_name like '%QUIRINO%';

update locations
set region_iso = 'PH-03'
where denorm_name like '%AURORA%'
  or denorm_name like '%BATAAN%'
  or denorm_name like '%BULACAN%'
  or denorm_name like '%NUEVA ECIJA%'
  or denorm_name like '%PAMPANGA%'
  or denorm_name like '%TARLAC%'
  or denorm_name like '%ZAMBALES%';

update locations
set region_iso = 'PH-05'
where denorm_name like '%ALBAY%'
  or denorm_name like '%CAMARINES NORTE%'
  or denorm_name like '%CAMARINES SUR%'
  or denorm_name like '%CATANDUANES%'
  or denorm_name like '%MASBATE%'
  or denorm_name like '%SORSOGON%';

update locations
set region_iso = 'PH-06'
where denorm_name like '%AKLAN%'
  or denorm_name like '%ANTIQUE%'
  or denorm_name like '%NEGROS OCCIDENTAL%'
  or denorm_name like '%CAPIZ%'
  or denorm_name like '%GUIMARAS%'
  or denorm_name like '%ILOILO%';

update locations
set region_iso = 'PH-07'
where denorm_name like '%BOHOL%'
  or denorm_name like '%CEBU%'
  or denorm_name like '%NEGROS ORIENTAL%'
  or denorm_name like '%SIQUIJOR%';

update locations
set region_iso = 'PH-08'
where denorm_name like '%BILIRAN%'
  or denorm_name like '%SAMAR%'
  or denorm_name like '%LEYTE%';

update locations
set region_iso = 'PH-09'
where denorm_name like '%ZAMBOANGA%'
  or denorm_name like '%ISABELA CITY%';

update locations
set region_iso = 'PH-10'
where denorm_name like '%CAMIGUIN%'
  or denorm_name like '%MISAMIS%'
  or denorm_name like '%LANAO DEL NORTE%'
  or denorm_name like '%CAGAYAN DE ORO%'
  or denorm_name like '%BUKIDNON%';

update locations
set region_iso = 'PH-11'
where denorm_name like '%DAVAO%'
  or denorm_name like '%COMPOSTELA VALLEY%';

update locations
set region_iso = 'PH-12'
where denorm_name like '%COTABATO%'
  or denorm_name like '%SULTAN KUDARAT%'
  or denorm_name like '%SARANGANI%'
  or denorm_name like '%GENERAL SANTOS%';

update locations
set region_iso = 'PH-13'
where denorm_name like '%AGUSAN%'
  or denorm_name like '%SURIGAO%'
  or denorm_name like '%DINAGAT ISLAND%';

update locations
set region_iso = 'PH-14'
where (denorm_name like '%BASILAN%' and denorm_name not like '%ISABELA CITY%')
  or denorm_name like '%LANAO DEL SUR%'
  or denorm_name like '%MAGUINDANAO%'
  or denorm_name like '%TAWI-TAWI%'
  or denorm_name like '%SULU%';

update locations
set region_iso = 'PH-15'
where denorm_name like '%ABRA%'
  or denorm_name like '%APAYAO%'
  or denorm_name like '%BENGUET%'
  or denorm_name like '%IFUGAO%'
  or denorm_name like '%KALINGA%'
  or denorm_name like '%MOUNTAIN PROVINCE%'
  or denorm_name like '%BAGUIO%';

update locations
set region_iso = 'PH-40'
where denorm_name like '%CAVITE%'
  or denorm_name like '%LAGUNA%'
  or denorm_name like '%BATANGAS%'
  or denorm_name like '%RIZAL%'
  or denorm_name like '%QUEZON%';

update locations
set region_iso = 'PH-41'
where denorm_name like '%MINDORO%'
  or denorm_name like '%MARINDUQUE%'
  or denorm_name like '%ROMBLON%'
  or denorm_name like '%PALAWAN%';


delete from regions;
insert into regions(region_iso, region_name) values ('PH-00','National Capital Region');
insert into regions(region_iso, region_name) values ('PH-01','Ilocos (Region I)');
insert into regions(region_iso, region_name) values ('PH-02','Cagayan Valley (Region II)');
insert into regions(region_iso, region_name) values ('PH-03','Central Luzon (Region III)');
insert into regions(region_iso, region_name) values ('PH-05','Bicol (Region V)');
insert into regions(region_iso, region_name) values ('PH-06','Western Visayas (Region VI)');
insert into regions(region_iso, region_name) values ('PH-07','Central Visayas (Region VII)');
insert into regions(region_iso, region_name) values ('PH-08','Eastern Visayas (Region VIII)');
insert into regions(region_iso, region_name) values ('PH-09','Zamboanga Peninsula (Region IX)');
insert into regions(region_iso, region_name) values ('PH-10','Northern Mindanao (Region X)');
insert into regions(region_iso, region_name) values ('PH-11','Davao (Region XI)');
insert into regions(region_iso, region_name) values ('PH-12','Soccsksargen (Region XII)');
insert into regions(region_iso, region_name) values ('PH-13','Caraga (Region XIII)');
insert into regions(region_iso, region_name) values ('PH-14','Autonomous Region in Muslim Mindanao (ARMM)');
insert into regions(region_iso, region_name) values ('PH-15','Cordillera Administrative Region (CAR)');
insert into regions(region_iso, region_name) values ('PH-40','Calabarzon (Region IV-A)');
insert into regions(region_iso, region_name) values ('PH-41','Mimaropa (Region IV-B)');


-- http://en.wikipedia.org/wiki/ISO_3166-2:PH
-- Code    name
-- PH-00   National Capital Region
-- PH-01   Ilocos (Region I)
-- PH-02   Cagayan Valley (Region II)
-- PH-03   Central Luzon (Region III)
-- PH-05   Bicol (Region V)
-- PH-06   Western Visayas (Region VI)
-- PH-07   Central Visayas (Region VII)
-- PH-08   Eastern Visayas (Region VIII)
-- PH-09   Zamboanga Peninsula (Region IX)
-- PH-10   Northern Mindanao (Region X)
-- PH-11   Davao (Region XI)
-- PH-12   Soccsksargen (Region XII)
-- PH-13   Caraga (Region XIII)
-- PH-14   Autonomous Region in Muslim Mindanao (ARMM)
-- PH-15   Cordillera Administrative Region (CAR)
-- PH-40   Calabarzon (Region IV-A)
-- PH-41   Mimaropa (Region IV-B)
