drop table if exists mystops;
create table mystops (
_id int not null primary key,
stop_id int not null
);
drop index if exists idx_mystops_stopid;
create index idx_mystops_stopid on mystops(stop_id);
