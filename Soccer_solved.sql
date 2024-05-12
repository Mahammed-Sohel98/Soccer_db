use soccer_db;
show tables;

-- 1.	Write a SQL query to find out where the final match of the EURO cup 2016 was played. Return venue name, city.

select * from soccer_venue;
select * from soccer_city;
select * from match_details;

select sv.venue_name,sc.city from soccer_venue sv left join 
soccer_city sc on sv.city_id = sc.city_id
left join match_details md
on sc.country_id = md.team_id
where md.play_stage = 'F';


-- 2.	Write a SQL query to find the number of goals scored by each team in each match during normal play. Return match number, country name and goal score.

select * from soccer_country;

select match_no,country_name,sum(goal_score)  `goals scored` from match_details md left join soccer_country sc
on md.team_id = sc.country_id
where decided_by = 'N'
group by match_no,country_name
order by match_no asc;

select match_no,country_name,goal_score  `goals scored` from match_details md left join soccer_country sc
on md.team_id = sc.country_id
where decided_by = 'N'
order by match_no asc;

/* 3.	Write a SQL query to count the number of goals scored by each player within a normal play schedule. 
Group the result set on player name and country name and sorts the result-set according to the highest to the lowest scorer. 
Return player name, number of goals and country name. */

select * from match_mast;
select * from player_mast;
select * from goal_details;

select player_name,country_name,count(player_name) `goal scored` from player_mast PM left join soccer_country sc
on pm.team_id = sc.country_id 
left join goal_details
using(player_id)
where  goal_schedule = 'NT'
group by player_name,country_name
order by player_name asc;


select * from goal_details order by player_id asc;

-- 4. Write a SQL query to find out who scored the most goals in the 2016 Euro Cup. Return player name, country name and highest individual scorer.

select player_name,country_name,count(player_name) `goal scored` from player_mast PM left join soccer_country sc
on pm.team_id = sc.country_id 
left join goal_details
using(player_id)
group by player_name,country_name
order by `goal scored`desc;

select player_name,country_name,max(goal_score) maxgoal from player_mast left join 
match_details md using(team_id) left join 
soccer_country sc on md.team_id = sc.country_id
group by player_name,country_name
order by maxgoal desc;


-- 5.	Write a SQL query to find out who scored in the final of the 2016 Euro Cup. Return player name, jersey number and country name.

select player_name,jersey_no,country_name from player_mast pm left join goal_details gd
using(player_id) left join soccer_country sc
on pm.team_id = sc.country_id
where play_stage = 'F';


-- 6. Write a SQL query to find out which country hosted the 2016 Football EURO Cup. Return country name.

select country_name from soccer_country left join soccer_city
using (country_id) left join soccer_venue using (city_id)
group by country_name;


/* 7.	Write a SQL query to find out who scored the first goal of the 2016 European Championship. 
Return player_name, jersey_no, country_name, goal_time, play_stage, goal_schedule, goal_half. */


select player_name,jersey_no,country_name,goal_time,play_stage,goal_schedule,goal_half from player_mast pm join goal_details gd
using (player_id) 
join soccer_country sc on gd.team_id = sc.country_id
where goal_id =1;


-- 8. Write a SQL query to find the referee who managed the opening match. Return referee name, country name.

select * from referee_mast;

select referee_name,country_name from referee_mast rm join match_mast mm
using(referee_id) join soccer_country sc on rm.country_id = sc.country_id
where match_no = 1;


select referee_name,country_name from match_mast mm join referee_mast rm
using(referee_id) join soccer_country sc using(country_id)
where match_no = 1;


-- 9.	Write a SQL query to find the referee who managed the final match. Return referee name, country name.

select referee_name,country_name from match_mast mm join referee_mast rm
using(referee_id) join soccer_country sc using(country_id)
where match_no = (select max(match_no) from match_mast);

-- 10.	Write a SQL query to find the referee who assisted the referee in the opening match. Return associated referee name, country name.

select * from asst_referee_mast;

select ass_ref_name,country_name from match_details md join asst_referee_mast ar
on md.ass_ref = ar.ass_ref_id join soccer_country sc
using(country_id)
where match_no = (select min(match_no) from match_details);













select player_id, max(goalscored) maxgoal from 
(select player_id,count(player_id) goalscored from goal_details group by player_id)goal_details
group by player_id;


select player_id,count(player_id) goal from goal_details group by player_id order by goal desc limit 1;

