create table if not exists garbages (
  id int primary key, 
  foreign key (nth_id) references nth(id),
  foreign key (wday_id) references wday(id),
  foreign key (category_id) references category(id)
)