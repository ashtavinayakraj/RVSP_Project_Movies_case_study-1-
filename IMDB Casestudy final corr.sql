USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';

---director_mapping	3867
---genre	14662
----movie	7571
----names	27019
----ratings	7927
----role_mapping	15179


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
   COUNT(*) AS id_null 
FROM
   movie 
WHERE
   id IS NULL;

SELECT
   COUNT(*) AS date_published_null 
FROM
   movie 
WHERE
   date_published IS NULL;
   
SELECT
   COUNT(*) AS year_null 
FROM
   movie 
WHERE
   year IS NULL;

SELECT
   COUNT(*) AS duration_null 
FROM
   movie 
WHERE
   duration IS NULL;

SELECT
   COUNT(*) AS worlwide_gross_income_null 
FROM
   movie 
WHERE
   worlwide_gross_income IS NULL;
   
SELECT
   COUNT(*) AS country_null 
FROM
   movie 
WHERE
   country IS NULL;

SELECT
   COUNT(*) AS worlwide_gross_income_null 
FROM
   movie 
WHERE
   worlwide_gross_income IS NULL;

SELECT
   COUNT(*) AS languages_null 
FROM
   movie 
WHERE
   languages IS NULL;

SELECT
   COUNT(*) AS production_company_null 
FROM
   movie 
WHERE
   production_company IS NULL;

---- production_company-528
---- languages_null- 194
---- world_gross_income_null - 3724
---- Country_null - 20
---- NILL NULLS inthe rest of the columns

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
   year,
   COUNT(*) AS number_of_movies 
FROM
   movie 
GROUP BY
   year 
ORDER BY
   year;
--------movies2017-3052,2018-2944,2019-2001 ---
SELECT
   MONTH(date_published) AS month_of_published,
   COUNT(id) AS no_of_movies 
FROM
   movie 
GROUP BY
   MONTH(date_published) 
ORDER BY
   2;

----DECE-438
----JUL-493
----JUN-580
----NOV-625
----MAY-625
----FEB-640
----OCT-678
----APRIL-680
----OCT-801
----JAN-804
----SEPT-809
----MAR-824

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT
   COUNT(id) AS num_of_movies 
FROM
   movie 
WHERE
   (
      country LIKE '%USA%' 
      OR country LIKE '%India%'
   )
   AND year = 2019;
----1059 movies in 2019







/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
   genre 
FROM
   genre;

----Drama,Fantasy,Thriller,comedy,Horror,Family,Romance,Adventure,Actin,SciFi,Crime,Mystery,Other-13






/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, year, COUNT(movie_id) AS no_of_movies
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
WHERE year = 2019
GROUP BY genre
ORDER BY no_of_movies DESC
LIMIT 1;
---- Drama genre had highest movies in 2019 are 1078



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH one_genre AS 
(
   SELECT
      movie_id,
      COUNT(genre) AS movie_genre 
   FROM
      genre 
   GROUP BY
      movie_id 
   HAVING
      movie_genre = 1
)
SELECT
   COUNT(movie_id) AS only_one_genre 
FROM
   one_genre;
---- 3289 movies belong to only one genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, ROUND(AVG(duration),2) AS avg_time
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
GROUP BY genre
ORDER BY AVG(duration) DESC;
----Action	112.88
	Romance	109.53
	Crime	107.05
	Drama	106.77
	Fantasy	105.14
	Comedy	102.62
	Adventure	101.87
	Mystery	101.80
	Thriller	101.58
	Family	100.97
	Others	100.16
	Sci-Fi	97.94
	Horror	92.72


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
   genre,
   COUNT(*) AS movie_count,
   RANK() OVER (
ORDER BY
   COUNT(*) DESC) AS genre_rank 
FROM
   genre 
GROUP BY
   genre;

---Thriller ranks 3 in the genre. Drama ranks 1. Least no of movies are in others cat with lowest 13th rank.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:



-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT
   MIN(avg_rating) AS min_avg_rating,
   MAX(avg_rating) AS max_avg_rating,
   MIN(total_votes) AS min_total_votes,
   MAX(total_votes) AS max_total_votes,
   MIN(median_rating) AS min_median_rating,
   MAX(median_rating) AS max_median_rating 
FROM
   ratings;
----min_avg_rating 1.0
----max_avg_rating 10.0
----min_total_votes 100
----max_total_votes 725138
----min_median_rating 1
----max_median_raing 10
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title, avg_rating,
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON r.movie_id = m.id
LIMIT 10;

----As average rating is same for some movies, we have used DenseRank.
---- Top 10 movies based on avg_rating are Kirket,LoveInKilnerry,Gini_Helida_Kathe,Runam,Fan,Android_kunjappan_version_5.25, Yeh_Suhagraat_Impossible, Safe, The_Brighton_miracle, Shibu,


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY movie_count DESC; 

-- movies with a median rating of 7 has highest number of movies


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_rank
     AS (SELECT production_company,
                Sum(CASE
                      WHEN avg_rating > 8 THEN 1
                      ELSE 0
                    END)
                AS
                   movie_count,
                RANK()
                  OVER (
                    ORDER BY Sum(CASE WHEN avg_rating>8 THEN 1 ELSE 0 END) DESC)
                AS
                prod_company_rank
         FROM   movie AS a
                INNER JOIN ratings AS b
                        ON a.id = b.movie_id
         WHERE  production_company IS NOT NULL
         GROUP  BY production_company
         ORDER  BY Sum(CASE
                         WHEN avg_rating > 8 THEN 1
                         ELSE 0
                       END) DESC)
SELECT production_company,
       movie_count,
       prod_company_rank
FROM   prod_rank
WHERE  prod_company_rank = 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    g.genre, COUNT(m.id) AS movie_count
FROM
    genre g
        INNER JOIN
    movie m ON m.id = g.movie_id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.year = 2017
        AND MONTH(m.date_published) = 3
        AND m.country LIKE '%USA%'
        AND r.total_votes > 1000
GROUP BY genre
ORDER BY COUNT(m.id) DESC;

-- In drama genre  we have the highest number of movies during March 2017 in the USA had more than 1,000 votes 


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
    title, avg_rating, genre
FROM
    movie AS a
        INNER JOIN
    ratings AS b ON a.id = b.movie_id
        INNER JOIN
    genre AS c ON c.movie_id = b.movie_id
WHERE
    avg_rating > 8 AND title LIKE 'The%'
ORDER BY avg_rating; 

-- There are following movies that starts with 'The' and > 8
/*
'The King and I', '8.2', 'Drama'
'The King and I', '8.2', 'Romance'
'Theeran Adhigaaram Ondru', '8.3', 'Action'
'Theeran Adhigaaram Ondru', '8.3', 'Crime'
'Theeran Adhigaaram Ondru', '8.3', 'Thriller'
'The Gambinos', '8.4', 'Crime'
'The Gambinos', '8.4', 'Drama'
'The Mystery of Godliness: The Sequel', '8.5', 'Drama'
'The Irishman', '8.7', 'Crime'
'The Irishman', '8.7', 'Drama'
'The Blue Elephant 2', '8.8', 'Drama'
'The Blue Elephant 2', '8.8', 'Horror'
'The Blue Elephant 2', '8.8', 'Mystery'
'The Colour of Darkness', '9.1', 'Drama'
'The Brighton Miracle', '9.5', 'Drama'
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(id) AS movie_released, median_rating
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- Between 1 April 2018 and 1 April 2019, 361 movies were released with a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH german_italian_vote_count
     AS (SELECT Sum(CASE
                      WHEN languages LIKE '%German%' THEN total_votes
                    END) AS total_votes_for_German,
                Sum(CASE
                      WHEN languages LIKE '%Italian%' THEN total_votes
                    END) AS total_votes_for_Italian
         FROM   movie AS a
                INNER JOIN ratings AS b
                        ON a.id = b.movie_id)
SELECT CASE
         WHEN total_votes_for_german > total_votes_for_italian THEN 'Yes'
         WHEN total_votes_for_german > total_votes_for_italian THEN 'No'
         ELSE 'No'
       END AS Is_German_GT_Italian_votes
FROM   german_italian_vote_count; 

-- yes German movies votes is greater than the Italian movies


/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names; 
-- As we can see that there are null values in case of height, date_of_birth,known_for_movies columns.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH genre_top3
AS
  (
             SELECT     genre ,
                        sum(
                        CASE
                                   WHEN avg_rating>8 THEN 1
                                   ELSE 0
                        end) AS movie_count,
                        dense_rank() over (ORDER BY sum(
                        CASE
                                   WHEN avg_rating>8 THEN 1
                                   ELSE 0
                        end) DESC ) AS genre_rank
             FROM       genre       AS a
             INNER JOIN ratings     AS b
             ON         a.movie_id=b.movie_id
             GROUP BY   genre
             ORDER BY   dense_rank() over (ORDER BY sum(
                        CASE
                                   WHEN avg_rating>8 THEN 1
                                   ELSE 0
                        end) DESC)
             LIMIT      3)
  SELECT     name              AS director_name,
             count(b.movie_id) AS movie_count
  FROM       genre_top3        AS a
  INNER JOIN genre             AS b
  ON         a.genre=b.genre
  INNER JOIN ratings AS r
  ON         b.movie_id=r.movie_id
  INNER JOIN director_mapping AS c
  ON         b.movie_id=c.movie_id
  INNER JOIN names AS d
  ON         d.id=c.name_id
  WHERE      avg_rating>8
  GROUP BY   director_name
  ORDER BY   count(b.movie_id) DESC
  LIMIT      3;
  -- James Mangold, Anthony Russo, Soubin Shahir are the top 3 directors
/*
'James Mangold', '4'
'Anthony Russo', '3'
'Soubin Shahir', '3'
*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    n.name AS actor_name, COUNT(rm.movie_id) AS movie_count
FROM
    role_mapping rm
        INNER JOIN
    names n ON n.id = rm.name_id
        INNER JOIN
    ratings r ON r.movie_id = rm.movie_id
WHERE
    category = 'actor'
        AND r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;

-- With a median-rating of GT 8, Mammootty and Mohanlal are the top two actors


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           SUM(total_votes)                             AS vote_count,
           RANK() over( ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM       movie                                        AS a
INNER JOIN ratings                                      AS b
ON         a.id=b.movie_id
GROUP BY   production_company
ORDER BY   vote_count DESC
LIMIT      3;

-- According to votes, Marvel Studios, Fox, and Warner Bros are the top three production companies

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT NAME AS actor_name,
       Sum(total_votes) AS total_votes,
       Count(b.movie_id) AS movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating,
       Dense_rank()
         OVER(
           ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes), 2) DESC) AS actor_rank
FROM   names AS a
       INNER JOIN role_mapping AS b
               ON a.id = b.name_id
       INNER JOIN ratings AS c
               ON b.movie_id = c.movie_id
       INNER JOIN movie AS d
               ON d.id = c.movie_id
WHERE  category = 'actor'
       AND country LIKE '%India%'
GROUP  BY actor_name
HAVING movie_count >= 5
ORDER  BY actor_rank;






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


select name actress_name, 
	   sum(total_votes) total_votes,
	   count(rm.movie_id) movie_count, 
	   round(sum(avg_rating*total_votes)/sum(total_votes), 2) actress_avg_rating,
	   dense_rank() over (order by round(sum(avg_rating*total_votes)/sum(total_votes), 2) desc , SUM(total_votes) desc) actress_rank
from  names n
inner join role_mapping rm 
on n.id = rm.name_id
inner join movie m
on m.id = rm.movie_id
inner join ratings r 
on m.id = r.movie_id
where country like 'India' 
and languages like 'Hindi'
and rm.category like 'Actress'
group by n.id, n.name
having movie_count >= 3;    

---- Tapsee Pannu is ranked 1 among Hindi Actresses
---- Divya Dutta is ranked 2
---- Kirti Kharbanda is ranked 3
---- Sonakshi Sinha is ranked 4

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


select title, 
case 
when avg_rating>8.0 then 'Superhit movies'
when avg_rating between 7.0 and 8.0 then 'Hit movies'
when avg_rating between 5.0 and 7.0 then 'One-time-watch movies'
else 'Flop movies' 
end as category
from movie m 
inner join genre g on m.id = g.movie_id
inner join ratings r on m.id = r.movie_id
where g.genre = 'thriller' 



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


with genre_desc as (
select year,genre,avg(duration) avg_duration
from movie m
inner join genre g on g.movie_id = m.id
group by genre,year order by year
)
select genre,avg_duration ,running_total,moving_average from (
select year, genre,avg_duration 
, sum(avg_duration) OVER w as running_total
, AVG(avg_duration) OVER w as moving_average 
from genre_desc
WINDOW w as (partition by genre order by year ROWS unbounded preceding)) t
where year = 2019;



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


with top_2017_genre as
(
select genre from genre inner join movie on id=movie_id where year = 2017 group by genre order by count(*)  desc limit 3
), 
top_2018_genre as
(
select genre from genre inner join movie on id=movie_id where year = 2018 group by genre order by count(*)  desc limit 3
),
top_2019_genre as
(
select genre from genre inner join movie on id=movie_id where year = 2019 group by genre order by count(*)  desc limit 3
)
(select year,genre,title,worlwide_gross_income from movie m 
inner join genre g on m.id = g.movie_id
where genre in (select genre from top_2017_genre) and year = 2017
order by worlwide_gross_income desc limit 5)
union 
(select year,genre,title,worlwide_gross_income from movie m 
inner join genre g on m.id = g.movie_id
where genre in (select genre from top_2018_genre) and year = 2018
order by worlwide_gross_income desc limit 5)
union 
(select year,genre,title,worlwide_gross_income from movie m 
inner join genre g on m.id = g.movie_id
where genre in (select genre from top_2019_genre) and year = 2019
order by worlwide_gross_income desc limit 5);

---- Highest grossing top movie is Shatamanam Bhavati
---- Winner is ranked 2
---- Thank you for your Service is ranked 3
---- Drama is the highest grossing genre with top three belonging to the same genre



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


select production_company,movie_count, row_number() over() prod_comp_rank from
(select production_company,languages,median_rating,count(*) as movie_count 
from movie inner join ratings on id = movie_id 
group by production_company order by count(*) desc) t 
where  POSITION(',' IN languages)>0 = 1 and median_rating>8 order by movie_count desc;



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select *, row_number() over() actress_rank from (
select name as actress_name, sum(total_votes), count(*) as movie_count, avg(avg_rating) as actress_avg_rating
from movie m 
inner join genre g on m.id = g.movie_id
inner join ratings r on m.id = r.movie_id
inner join role_mapping rm on m.id = rm.movie_id
inner join names n on n.id = rm.name_id
where g.genre = 'Drama' and r.avg_rating>8.0 and rm.category = 'actress'
group by name order by count(*) desc limit 3) t;

---- Amanda Lawrence is ranked 1
---- Susuan Brown is ranked 2
---- Parvathy Thiruvothu is ranked 3

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.		 		|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH movie_date_info AS
(
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
	 JOIN names AS n 
     ON d.name_id=n.id 
	 JOIN movie AS m 
     ON d.movie_id=m.id
),

date_difference AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_difference
	 GROUP BY name_id
 ),
 
 final_result AS
 (
	 SELECT d.name_id AS director_id,
		 name AS director_name,
		 COUNT(d.movie_id) AS number_of_movies,
		 ROUND(avg_inter_movie_days) AS inter_movie_days,
		 ROUND(AVG(avg_rating),2) AS avg_rating,
		 SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,
		 MAX(avg_rating) AS max_rating,
		 SUM(duration) AS total_duration,
		 ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	 FROM
		 names AS n 
         JOIN director_mapping AS d 
         ON n.id=d.name_id
		 JOIN ratings AS r 
         ON d.movie_id=r.movie_id
		 JOIN movie AS m 
         ON m.id=r.movie_id
		 JOIN avg_inter_days AS a 
         ON a.name_id=d.name_id
	 GROUP BY director_id
 )
 SELECT *	
 FROM final_result
 LIMIT 9;

---- Top director is Andrew Jones






