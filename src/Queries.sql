use university;
#1
select name from instructor where dept_name = "Biology";
#2
select * from course;
select title from course where dept_name ="Physics" and credits = 3;
#3
select name from instructor where dept_name = "Physics" and salary >50000;
#4
select * from student;
select name  from student where tot_cred >= 100;
#5
select building from instructor join department using (dept_name) where name ="Mozart";
#6
select title from course join takes using(course_id) where semester = "Summer" and year = 2009;
#7
select day, start_hr,start_min from time_slot join section using(time_slot_id) where year = 2010 and course_id in (select course_id from course where title = "Genetics");
#8
select course_id, title from takes join course using(course_id) where ID = 12345 order by course_id;
#9
select title from course where course_id in (select prereq_id from prereq where course_id in (select course_id from course where title = "Robotics"));
#10
select distinct name from student join takes using (ID) where course_id like "CS-%" order by name;
#11
select name from instructor where dept_name = "Finance" order by name;
#12
select title from course where dept_name = "Biology" and credits >=3 order by title;
#13
select * from student;
select * from student where dept_name = "Comp. Sci.";
select name from student where dept_name = "Comp. Sci." and tot_cred >50 order by name;
#14
select name from instructor join teaches using (ID) where semester = "Summer" and year = 2010 order by name;
#15
select sum(salary) from instructor where dept_name ="Comp. Sci.";
#16
select count(ID) from instructor where dept_name = "Finance";
#17
select name from student order by tot_cred desc limit 1;
#18
select course_id, title, year, semester from takes join course using (course_id) where ID = 45678 order by course_id;
#19
select name from student join advisor on student.ID = advisor.s_id where i_id in (select ID from instructor where name = "Einstein"); 
#20
select title from course join prereq on course.course_id = prereq.prereq_id group by prereq_id order by count(prereq_id) desc limit 1;
#21
select distinct name from student join takes using(ID) where course_id like "CS-%" order by name;
#22
select ID from instructor left outer join teaches using(ID) where course_id is NULL order by ID;
#23
select name, ID from instructor left outer join teaches using(ID) where course_id is NULL order by name;
#24
select * from course;
select count(grade) from takes join course using (course_id) where title = "Intro. to Computer Science";
#25
select title, year, semester, grade from course join takes using(course_id) where ID in (select ID from student where name ="Shankar") order by title;
#26
select title from course where course_id like "CS-1%" order by title desc;
#27
select dept_name from instructor where salary between 60000 and 80000 group by dept_name order by dept_name;
#28
select name, salary from instructor order by salary;
#29
select dept_name, avg(salary) as aval from instructor group by dept_name having aval>40000 order by dept_name;
#30
drop view if exists a;
create view a as select min(salary) as min_salary from instructor where dept_name = "Biology";
select * from a;
select name, salary from instructor,a where salary > a.min_salary order by name;
#31
drop view if exists faculty;
create view faculty as select ID, name, dept_name from instructor ;
select * from faculty; 
#32
drop view if exists faculty;
create view faculty as select ID, name, dept_name from instructor ;
select * from faculty where dept_name = "Biology"; 
#33
drop view if exists department_info;
create view department_info as select dept_name,building from department ;
select * from department_info; 
#34
drop view if exists instructor_loc;
create view instructor_loc as select name, dept_name, building from department_info join faculty using(dept_name);
select * from instructor_loc; 
#35 -- add instructor images
alter table instructor add Image blob;
pragma table_info(instructor);
#36 -- list of courses and it's prereq courses
drop view if exists courses;
create view courses as select course_id, title from course;
drop view if exists prereq_courses;
create view prereq_courses as select prereq.course_id, prereq.prereq_id , course.title from prereq join course where prereq.prereq_id = course.course_id;

select  courses.title , prereq_courses.title from courses join prereq_courses using (course_id) order by prereq_courses.title;
#37 -- list of students and instructors
drop view if exists instructor_view;
create view instructor_view as select ID, name from instructor;
drop view if exists student_view;
create view student_view as select advisor.i_ID, student.name from advisor join student where student.ID = advisor.s_ID;

select  student_view.name, instructor_view.name from student_view join instructor_view where instructor_view.ID = student_view.i_ID order by student_view.name;
#38 -- instructor with num of sections 
select  ID, name, count(sec_id) as sections from instructor left outer join teaches using (ID) group by name;
#39
insert into section values ('CS-101','2','Spring','2010','Packard','101','E');
insert into teaches values ('10101','CS-101','1','Spring','2010');

select section.course_id , section.sec_id, section.semester, section.year, section.building, section.room_number, section.time_slot_id, instructor.name from section 
       left join teaches
	   on section.semester = teaches.semester and section.course_id = teaches.course_id and section.year = teaches.year  and section.sec_id = teaches.sec_id
       left join instructor
       using (ID) where section.year = 2010 and section.semester = "Spring" order by section.course_id,section.sec_id,instructor.name;
#40
insert into department values('Mechanical', 'Watson', 90000);
select dept_name, count(id) from department left outer join instructor using (dept_name) group by dept_name order by dept_name;
#41
select name, i_ID from student join advisor on student.ID = advisor.s_ID where dept_name = "Biology";
#42
select title from course where course_id in (select prereq_id from prereq where course_id in (select course_id from course where title = "Database System Concepts"));
#43 -- course id , prereq id pairs
select course.course_id, prereq.prereq_id from course left outer join prereq using(course_id);
#44
select name from student left outer join takes using(ID) where course_id is NULL;
#45
select distinct takes.ID as pid from takes join section using (course_id) where section.building = "Packard"  and takes.ID in
(select takes.ID from takes join section using (course_id) where section.building = "Watson" ) order by takes.id;
#46 & 47
drop view if exists student_grades;
create view student_grades as select ID, name, course_id,grade from student join takes using(ID);
select name from student_grades where grade = "A" and course_id = "BIO-101";
#48
drop view if exists department_loc;
create view department_loc as select dept_name, building from department;
#49  -- create view using a view
drop view if exists instructor_info;
create view instructor_info as select name, salary, building from department_loc join instructor using(dept_name);
#50  -- update view
update department_loc set building = "SUMANADASA" where dept_name = "Comp. Sci.";
select * from department_loc;
#51  -- False
update instructor_info set salary ='100000' where name = "Gold";
#52 -- creating indices
create index grade_index on takes(grade);
#53
create index building_index on department(building); 
#54 -- create a table
drop table if exists scholarship;
create table scholarship (
  school_id varchar(20), 
  student_id  varchar(20),
  amount numeric(8,2),
  primary key (school_id),
  foreign key (student_id) references student(ID));
#55  -- insert a record to table
insert into scholarship values("00001","00128" ,40000);







