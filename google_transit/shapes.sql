drop table if exists shape;
create table shape (
_id integer not null primary key autoincrement,
shape_id int not null,
shape_pt_lat float default 0,
shape_pt_lon float default 0,
shape_pt_seq int default 0
);
create index shape_shapeid_idx on shape('shape_id');
