CREATE TABLE IF NOT EXISTS garbages (
  id int primary key, 
  type varchar(32),
  area varchar(32),
  area_id int,
  wday varchar(32),
  nweek int
)