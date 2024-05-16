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


-- 11. Write a SQL query to find the referee who assisted the referee in the final match. Return associated referee name, country name.

select ass_ref_name,country_name from match_details md join asst_referee_mast ar
on md.ass_ref = ar.ass_ref_id join soccer_country sc
using(country_id)
where play_stage = 'F';

select ass_ref_name,country_name from match_details md join asst_referee_mast ar
on md.ass_ref = ar.ass_ref_id join soccer_country sc
using(country_id)
where match_no = (select max(match_no) from match_details);




-- 12.	Write a SQL query to find the city where the opening match of EURO cup 2016 took place. Return venue name, city.

select venue_name,city from 
(select * from soccer_venue join match_mast using (venue_id)) soccer_venue join 
soccer_city using(city_id)
where match_no = (select min(match_no) from soccer_venue join match_mast using (venue_id));



-- 13. Write a SQL query to find out which stadium hosted the final match of the 2016 Euro Cup. Return venue_name, city, aud_capacity, audience.

select venue_name,city,aud_capacity,audience from 
(select * from soccer_venue join match_mast using (venue_id)) soccer_venre
join soccer_city using(city_id)
where play_stage = 'F';



/* 14.	Write a SQL query to count the number of matches played at each venue. Sort the result-set on venue name. 
Return Venue name, city, and number of matches. */

select venue_name,city,count(venue_id) no_of_match from 
(select * from soccer_venue join match_mast using(venue_id)) soccer_venue join 
soccer_city using (city_id)
group by venue_name,city
order by venue_name;



/* 15.Write a SQL query to find the player who was the first player to be sent off at the tournament EURO cup 2016.
Return match Number, country name and player name. */

select * from player_booked;

select match_no,country_name,player_name,player_id,booking_time "Sent_od_time",jersey_no,play_schedule from 
(select * from player_mast pm join soccer_country sc on pm.team_id = sc.country_id) player_mast 
join player_booked using(player_id)
where sent_off = 'Y'and match_no = (select min(match_no) from player_booked);

 

select player_id, max(goalscored) maxgoal from 
(select player_id,count(player_id) goalscored from goal_details group by player_id)goal_details
group by player_id;


# 16. Write a SQL query to find the teams that have scored one goal in the tournament. Return country_name as "Team", team in the group, goal_for.

select * from soccer_team;

select country_name 'Team',team_group,goal_for from soccer_team st join soccer_country sc
on st.team_id = sc.country_id
where goal_for = 1;


use soccer_db;

# 17.	Write a SQL query to count the number of yellow cards each country has received. Return country name and number of yellow cards.

select * from player_booked;

SELECT country_name, COUNT(*)
FROM soccer_country 
JOIN player_booked
ON soccer_country.country_id=player_booked.team_id
GROUP BY country_name
ORDER BY COUNT(*) DESC;


#18.Write a SQL query to count the number of goals that have been seen. Return venue name and number of goals.

select venue_name,count(venue_name) no_of_goal from goal_details gd join soccer_country sc
on gd.team_id = sc.country_id join match_mast md using (match_no)
join soccer_venue using(venue_id)
group by venue_name
order by no_of_goal desc;


# 19. Write a SQL query to find the match where there was no stoppage time in the first half. Return match number, country name.

select * from player_in_out;

select match_no,country_name from match_mast mm join match_details md
using(match_no) join soccer_country sc on
md.team_id = sc.country_id
where stop1_sec = 0;


#20. Write a SQL query to find the team(s) who conceded the most goals in EURO cup 2016. Return country name, team group and match played.

select country_name,team_group,match_played from  soccer_team st join 
soccer_country sc on st.team_id = sc.country_id
where goal_agnst = (select max(goal_agnst) from soccer_team);


/* 21.Write a SQL query to find those matches where the highest stoppage time was added in 2nd half of play. 
Return match number, country name, stoppage time(sec.). */

select mm.match_no,country_name,mm.stop2_sec as `stoppage time` from match_mast mm
join match_details md using(match_no)
join soccer_country sc on md.team_id = sc.country_id
where mm.stop2_sec in (select max(stop2_sec) from match_mast mm);


#22. Write a SQL query to find the matches that ended in a goalless draw at the group stage. Return match number, country name.

select mm.match_no,country_name from match_mast mm join match_details md
using (match_no) join soccer_country sc on 
md.team_id = sc.country_id
where mm.play_stage = 'G' and md.goal_score =0 and results = 'Draw';

select match_no,country_name from match_details md join soccer_country sc
on md.team_id = sc.country_id
where goal_score = 0 and play_stage ='G' and win_lose = 'D';


/* 23.	Write a SQL query to find those match(s) where the second highest amount of stoppage time was 
added in the second half of the match. Return match number, country name and stoppage time. */

select * from match_mast 
order by stop2_sec desc;





/* 24.	Write a SQL query to find the number of matches played by a player as a goalkeeper for his team.
 Return country name, player name, number of matches played as a goalkeeper */
 
select * from playing_position;

select sc.country_name,pm.player_name,count(md.player_gk) number_of_match from player_mast pm
join soccer_country sc on pm.team_id = sc.country_id 
join match_details md on pm.player_id = md.player_gk
group by sc.country_name,pm.player_name
order by number_of_match desc;

 
# 25.	Write a SQL query to find the venue where the most goals have been scored. Return venue name, number of goals.


select venue_name,count(goal_id) no_of_goal from soccer_venue sv join match_mast mm
using(venue_id) join goal_details gd using (match_no)
group by venue_name
order by no_of_goal desc
limit 1;

select venue_name,max(no_of_goal) most_goal from 
(select venue_name, count(goal_id) no_of_goal from soccer_venue join match_mast mm
using (venue_id) join goal_details using(match_no)
group by venue_name) soccer_venue
group by venue_name
order by most_goal desc
limit 1;


select venue_name,count(goal_id) most_goal from goal_details gd 
join match_mast mm using (match_no)
join soccer_venue sv using(venue_id)
group by venue_name
having count(goal_id) = 
(select max(goal_count) from 
(select venue_name,count(goal_id) goal_count from goal_details gd
join match_mast mm using (match_no)
join soccer_venue sv using(venue_id)
group by venue_name) gg);





