SELECT DISTINCT)user_guid,)state,)membership_type
FROM)users
WHERE)country="US")AND)state)IS)NOT)NULL)and)membership_type)IS)NOT)NULL
ORDER)BY)membership_type)DESC,)state ASC

SELECT)DISTINCT)user_guid,)state,)created_at)
FROM)users)WHERE)membership_type=2)AND)state="NC")AND)country="US")AND)
created_at>'2014_03_01')ORDER)BY)created_at)DESC

SELECT)test_name,)AVG(rating))AS)AVG_Rating,)MIN(rating))AS)MIN_Rating,)
MAX(rating))AS)MAX_Rating
FROM)reviews
WHERE test_name="Memory versus Pointing"

SELECT)dog_guid,)start_time,)end_time,)TIMESTAMPDIFF(minute,start_time,end_time))
AS) Duration
FROM)exam_answers
LIMIT)2000O

SELECT)MIN(TIMESTAMPDIFF(minute,start_time,end_time)))AS)MinDuration,)
MAX(TIMESTAMPDIFF(minute,start_time,end_time)))AS)MaxDuration
FROM)exam_answers

SELECT gender, breed_group, COUNT(DISTINCT dog_guid) AS Num_Dogs
FROM dogs
WHERE breed_group IS NOT NULL AND breed_group!="None" AND breed_group!=""
GROUP BY 1, 2
HAVING Num_Dogs >= 1000
ORDER BY 3 DESC;

SELECT test_name,
AVG(TIMESTAMPDIFF(HOUR,start_time,end_time)) AS Duration
FROM exam_answers
WHERE timestampdiff(MINUTE,start_time,end_time) < 6000
GROUP BY test_name
HAVING AVG (timestampdiff(MINUTE,start_time,end_time)) > 0 ORDER BY Duration
desc;

SELECT state, zip, COUNT(DISTINCT user_guid) AS NUM_Users
FROM users
WHERE Country="US"
GROUP BY State, zip
HAVING NUM_Users>=5
ORDER BY State ASC, NUM_Users DESC;

SELECT d.user_guid AS UserID, d.dog_guid AS DogID, d.breed, d.breed_type,
d.breed_group
FROM dogs d JOIN complete_tests c
ON d.dog_guid=c.dog_guid
WHERE test_name='Yawn Warm-up';

SELECT r.dog_guid AS rDogID, d.dog_guid AS dDogID, r.user_guid AS rUserID,
d.user_guid AS dUserID, AVG(r.rating) AS AvgRating, COUNT(r.rating) AS
NumRatings, d.breed, d.breed_group, d.breed_type
FROM dogs d RIGHT JOIN reviews r
ON d.dog_guid=r.dog_guid AND d.user_guid=r.user_guid
WHERE r.dog_guid IS NOT NULL
GROUP BY r.dog_guid
HAVING NumRatings >= 10
ORDER BY AvgRating DESC;

SELECT u.user_guid AS uUserID, d.user_guid AS dUserID, d.dog_guid AS dDogID,
d.breed, count(*) AS numrows
FROM users u LEFT JOIN dogs d
ON u.user_guid=d.user_guid
GROUP BY u.user_guid
ORDER BY numrows DESC;

SELECT *
FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time,end_time) >
(SELECT AVG(TIMESTAMPDIFF(minute,start_time,end_time)) AS AvgDuration
FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time,end_time)>0 AND
test_name="Yawn Warm-Up");

SELECT DistinctUUsersID.user_guid AS uUserID, d.user_guid AS dUserID, count(*) AS
numrows
FROM (SELECT DISTINCT u.user_guid
FROM users u
WHERE u.user_guid='ce7b75bc-7144-11e5-ba71-058fbc01cf0b') AS
DistinctUUsersID
LEFT JOIN dogs d
ON DistinctUUsersID.user_guid=d.user_guid
GROUP BY DistinctUUsersID.user_guid
ORDER BY numrows DESC;

SELECT DistinctUUsersID.user_guid AS uUserID, DistictDUsersID.user_guid AS
dUserID, count(*) AS numrows
FROM (SELECT DISTINCT u.user_guid
FROM users u
WHERE u.user_guid='ce7b75bc-7144-11e5-ba71-058fbc01cf0b') AS
DistinctUUsersID
LEFT JOIN (SELECT DISTINCT d.user_guid
FROM dogs d) AS DistictDUsersID
ON DistinctUUsersID.user_guid=DistictDUsersID.user_guid
GROUP BY DistinctUUsersID.user_guid
ORDER BY numrows DESC;

SELECT DistictUUsersID.user_guid AS userid, d.breed, d.weight, count(*) AS numrows
FROM (SELECT DISTINCT u.user_guid
FROM users u) AS DistictUUsersID
LEFT JOIN dogs d
ON DistictUUsersID.user_guid=d.user_guid
GROUP BY DistictUUsersID.user_guid
HAVING numrows>10
ORDER BY numrows DESC;
SELECT d.dog_guid AS dogID, d.breed_type AS breed_type, count(c.created_at) AS
numtests,
IF(d.breed_type='Pure Breed','pure_breed', 'not_pure_breed') AS pure_breed
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid
GROUP BY dogID, breed_type, pure_breed
LIMIT 50;

SELECT COUNT(DISTINCT user_guid),
CASE
WHEN (state="NY" OR state="NJ") THEN "Group 1-NY/NJ"
WHEN (state="NC" OR state="SC") THEN "Group 2-NC/SC"
WHEN state="CA" THEN "Group 3-CA"
ELSE "Group 4-Other"
END AS state_group
FROM users
WHERE country="US" AND state IS NOT NULL
GROUP BY state_group;

SELECT dimension, AVG(numtests_per_dog.numtests) AS avg_tests_completed
FROM( SELECT d.dog_guid AS dogID, d.dimension AS dimension, count(c.created_at)
AS numtests
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid
GROUP BY dogID) AS numtests_per_dog
GROUP BY numtests_per_dog.dimension;

SELECT dimension, COUNT(DISTINCT dogID) AS num_dogs
FROM( SELECT d.dog_guid AS dogID, d.dimension AS dimension
FROM dogs d JOIN complete_tests c
ON d.dog_guid=c.dog_guid
WHERE d.dimension IS NULL OR d.dimension=''
GROUP BY dogID) AS dogs_in_complete_tests
GROUP BY dimension;

SELECT dimension, AVG(numtests_per_dog.numtests) AS avg_tests_completed,
COUNT(DISTINCT dogID)
FROM( SELECT d.dog_guid AS dogID, d.dimension AS dimension, count(c.created_at)
AS numtests
FROM dogs d JOIN complete_tests c
ON d.dog_guid=c.dog_guid
WHERE (dimension IS NOT NULL AND dimension!='') AND (d.exclude IS NULL
OR d.exclude=0)
GROUP BY dogID) AS numtests_per_dog
GROUP BY numtests_per_dog.dimension;

SELECT breed_type, AVG(numtests_per_dog.numtests) AS avg_tests_completed,
COUNT(DISTINCT dogID)
FROM( SELECT d.dog_guid AS dogID, d.breed_type AS breed_type,
count(c.created_at) AS numtests
FROM dogs d JOIN complete_tests c
ON d.dog_guid=c.dog_guid
WHERE d.exclude IS NULL OR d.exclude=0
GROUP BY dogID) AS numtests_per_dog
GROUP BY breed_type;

SELECT numtests_per_dog.pure_breed AS pure_breed, neutered,
AVG(numtests_per_dog.numtests) AS avg_tests_completed, COUNT(DISTINCT dogID)
FROM( SELECT d.dog_guid AS dogID, d.breed_group AS breed_type, d.dog_fixed AS
neutered,
CASE WHEN d.breed_type='Pure Breed' THEN 'pure_breed'
ELSE 'not_pure_breed'
END AS pure_breed,
count(c.created_at) AS numtests
FROM dogs d JOIN complete_tests c
ON d.dog_guid=c.dog_guid
WHERE d.exclude IS NULL OR d.exclude=0
GROUP BY dogID) AS numtests_per_dog
GROUP BY pure_breed, neutered;

SELECT DAYOFWEEK(created_at),COUNT(created_at) AS numtests,
(CASE
WHEN DAYOFWEEK(created_at)=1 THEN "Su"
WHEN DAYOFWEEK(created_at)=2 THEN "Mo"
WHEN DAYOFWEEK(created_at)=3 THEN "Tu"
WHEN DAYOFWEEK(created_at)=4 THEN "We"
WHEN DAYOFWEEK(created_at)=5 THEN "Th"
WHEN DAYOFWEEK(created_at)=6 THEN "Fr"
WHEN DAYOFWEEK(created_at)=7 THEN "Sa"
END) AS daylabel
FROM complete_tests
GROUP BY daylabel
ORDER BY numtests DESC;

SELECT DAYOFWEEK(c.created_at) AS dayasnum, YEAR(c.created_at) AS year,
COUNT(c.created_at) AS numtests,
(CASE
WHEN DAYOFWEEK(c.created_at)=1 THEN "Su"
WHEN DAYOFWEEK(c.created_at)=2 THEN "Mo"
WHEN DAYOFWEEK(c.created_at)=3 THEN "Tu"
WHEN DAYOFWEEK(c.created_at)=4 THEN "We"
WHEN DAYOFWEEK(c.created_at)=5 THEN "Th"
WHEN DAYOFWEEK(c.created_at)=6 THEN "Fr"
WHEN DAYOFWEEK(c.created_at)=7 THEN "Sa"
END) AS daylabel
FROM complete_tests c JOIN
(SELECT DISTINCT dog_guid
FROM dogs d JOIN users u
ON d.user_guid=u.user_guid
WHERE ((u.exclude IS NULL OR u.exclude=0)
AND (d.exclude IS NULL OR d.exclude=0))) AS dogs_cleaned
ON c.dog_guid=dogs_cleaned.dog_guid
GROUP BY daylabel
ORDER BY numtests DESC;

SELECT DAYOFWEEK(DATE_SUB(created_at, interval 6 hour)) AS dayasnum,
YEAR(c.created_at) AS year, COUNT(c.created_at) AS numtests,
(CASE
WHEN DAYOFWEEK(DATE_SUB(created_at, interval 6 hour))=1 THEN "Su"
WHEN DAYOFWEEK(DATE_SUB(created_at, interval 6 hour))=2 THEN "Mo"
WHEN DAYOFWEEK(DATE_SUB(created_at, interval 6 hour))=3 THEN "Tu"
WHEN DAYOFWEEK(DATE_SUB(created_at, interval 6 hour))=4 THEN "We"
WHEN DAYOFWEEK(DATE_SUB(created_at, interval 6 hour))=5 THEN "Th"
WHEN DAYOFWEEK(DATE_SUB(created_at, interval 6 hour))=6 THEN "Fr"
WHEN DAYOFWEEK(DATE_SUB(created_at, interval 6 hour))=7 THEN "Sa"
END) AS daylabel
FROM complete_tests c JOIN
(SELECT DISTINCT dog_guid
FROM dogs d JOIN users u
ON d.user_guid=u.user_guid
WHERE ((u.exclude IS NULL OR u.exclude=0)
AND u.country="US"
AND (u.state!="HI" AND u.state!="AK")
AND (d.exclude IS NULL OR d.exclude=0))) AS dogs_cleaned
ON c.dog_guid=dogs_cleaned.dog_guid
GROUP BY year,daylabel
ORDER BY year ASC, numtests DESC;



