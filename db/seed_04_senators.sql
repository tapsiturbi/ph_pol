insert into locations(name, denorm_name) values ('nationwide', 'nationwide');

insert into politicians(first_name, last_name, nickname) values ('franklin', 'drilon', null);
insert into politicians(first_name, last_name, nickname) values ('ralph', 'recto', null);
insert into politicians(first_name, last_name, nickname) values ('juan ponce', 'enrile', null);
insert into politicians(first_name, last_name, nickname) values ('alan peter', 'cayetano', 'companero');
insert into politicians(first_name, last_name, nickname) values ('juan edgardo', 'angara', 'sonny');
insert into politicians(first_name, last_name, nickname) values ('paolo benigno', 'aquino IV', 'bam');
insert into politicians(first_name, last_name, nickname) values ('maria lourdes nancy', 'binay', null);
insert into politicians(first_name, last_name, nickname) values ('pia', 'cayetano', null);
insert into politicians(first_name, last_name, nickname) values ('miriam', 'santiago', null);
insert into politicians(first_name, last_name, nickname) values ('joseph victor', 'ejercito', null);
insert into politicians(first_name, last_name, nickname) values ('francis joseph', 'escudero', 'chiz');
insert into politicians(first_name, last_name, nickname) values ('jinggoy', 'estrada', null);
insert into politicians(first_name, last_name, nickname) values ('teofisto', 'guingona III', 'TG');
insert into politicians(first_name, last_name, nickname) values ('gregorio', 'honasan II', null);
insert into politicians(first_name, last_name, nickname) values ('manuel', 'lapid', 'lito');
insert into politicians(first_name, last_name, nickname) values ('loren', 'legarda', null);
insert into politicians(first_name, last_name, nickname) values ('ferdinand', 'marcos JR.', 'bongbong');
insert into politicians(first_name, last_name, nickname) values ('sergio', 'osmena III', null);
insert into politicians(first_name, last_name, nickname) values ('aquilino', 'pimentel III', 'koko');
insert into politicians(first_name, last_name, nickname) values ('grace', 'poe', null);
insert into politicians(first_name, last_name, nickname) values ('ramon', 'revilla JR.', 'bong');
insert into politicians(first_name, last_name, nickname) values ('vicente', 'sotto III', 'tito');
insert into politicians(first_name, last_name, nickname) values ('antonio', 'trillanes IV', 'sonny');
insert into politicians(first_name, last_name, nickname) values ('cynthia', 'villar', null);

insert into careers(start_date, title, politician_id, location_id)
  select str_to_date('05/13/2013', '%m/%d/%Y'), 'senator', id,
    (select id from locations where name = 'nationwide')
  from politicians
  where id >= (
    select id
    from politicians
    where first_name = 'franklin' and last_name = 'drilon'
  );
