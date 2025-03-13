-- Netlix Project

DROP TABLE IF EXISTS Netflix;
CREATE TABLE Netflix
(
show_id VARCHAR(6),
Movie_type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year 	INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);


SELECT COUNT(*) as Total_Content
FROM Netflix

SELECT DISTINCT movie_type
FROM Netflix

1.--count the number of Movies vs TV shows

SELECT COUNT(movie_type) as Type_count, movie_type
FROM Netflix
GROUP BY movie_type


2.--Find the most common rating for movies and tv shows
SELECT movie_type, rating, COUNT(*) as rating_count
FROM Netflix
GROUP BY rating, movie_type
ORDER BY rating_count DESC


3.--List all movies released in a specific year(e.g., 2020)

SELECT movie_type, release_year, title
FROM Netflix
WHERE movie_type = 'Movie' AND release_year = 2020

4.--Find the top 5 countries with the most content on netflix

SELECT UNNEST(STRING_TO_ARRAY(country, ',')) as new_country, 
COUNT(show_id) as total_content
FROM Netflix
GROUP BY new_country
ORDER BY total_content DESC LIMIT 5


5.--Identify the longest movie or TV show duration

SELECT * FROM Netflix
WHERE movie_type = 'Movie' AND duration IS NOT NULL
ORDER BY duration DESC


6.--Find content added in the last 5 years

SELECT *, TO_DATE(date_added, 'Month DD, YYYY') FROM Netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
SELECT TO_DATE - INTERVAL '5 years'


7.--Find all the movies/TV shows by director 'Rajiv chilaka'!

SELECT * FROM Netflix
WHERE director ILIKE '%Rajiv Chilaka%'


8.--List all TV shows with more than 5 seasons

SELECT * FROM Netflix
WHERE movie_type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::numeric > 5


9.--Count the number of content items in each genre

SELECT movie_type, UNNEST(STRING_TO_ARRAY(listed_in , ',')) as Genre, COUNT(show_id) as total_content
FROM Netflix
GROUP BY Genre, movie_type


10.--Find each year and the avg no. of content release by India on Netflix. Return top 5 years with
--highest avg content released !

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM Netflix WHERE country = 'India')::numeric * 100 
	,2)as avg_content
FROM Netflix
WHERE country = 'India'
GROUP BY 1


11.--List all movies that are documentaries

SELECT * FROM Netflix
WHERE listed_in LIKE '%Documentaries%'


12.--Find all content without a director

SELECT * FROM Netflix
WHERE director IS NULL


13.--Find in how many movies actor 'salman khan' in last 10 years!

SELECT * FROM Netflix
WHERE casts ILIKE '%salman khan%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


14.--Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) as actors, COUNT(show_id) as total_content
FROM Netflix 
WHERE country ILIKE '%India%'
GROUP BY actors
ORDER BY total_content DESC LIMIT 10


15.--Categorize the content based on the keywords 'kill' and 'violence' in the description field.
--Label content containing these keywords as 'bad' and all other content as 'Good'. Count how many times
--items fall into each category.

SELECT *,
		CASE 
			WHEN description ILIKE '%kill%' OR
			description ILIKE 'violence' THEN 'bad'
			ELSE 'Good'
		END Category
FROM Netflix
