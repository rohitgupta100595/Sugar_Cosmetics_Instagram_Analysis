CREATE DATABASE IF NOT EXISTS sugar_cosmetics;

USE sugar_cosmetics;

DROP TABLE instagram_data;
CREATE TABLE instagram_data(
Serial_Number INT AUTO_INCREMENT PRIMARY KEY,
Post_Date VARCHAR(244),
Post_Type VARCHAR(244),
Campaign_Type VARCHAR(244),
Hashtags VARCHAR(244),
Audience_Emotion VARCHAR(30),
Engagement_Source VARCHAR(30),
Impressions INT,
Reach INT,
Likes INT,
Comments INT,
Shares INT,
Saves INT,
Profile_Visits INT,
Follows INT
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:\\Users\\Rohit Gupta\\Documents\\Sugar Cosmetics\\sugar_cosmetics_instagram_data.csv'
INTO TABLE instagram_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Post_Date,Post_Type,Campaign_Type,Hashtags,Audience_Emotion,Engagement_Source,Impressions,Reach,Likes,Comments,Shares,Saves,Profile_Visits,Follows);

SELECT * FROM instagram_data;


-- Data Validation
SELECT * FROM instagram_data 
WHERE Post_Date IS NULL OR 
Post_Date = '' OR 
Post_Date = '00-00-0000' OR 
Post_Date NOT REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' OR
Post_Type IS NULL OR Post_Type = '' OR Post_Type = ' ' OR LOWER(TRIM(Post_Type)) IN ('n/a', 'unknown') OR
Campaign_Type IS NULL OR Campaign_Type = '' OR Campaign_Type = ' ' OR LOWER(TRIM(Campaign_Type)) IN ('n/a', 'unknown') OR
Hashtags IS NULL OR Hashtags = '' OR Hashtags = ' ' OR LOWER(TRIM(Hashtags)) IN ('n/a', 'unknown') OR
Audience_Emotion IS NULL OR Audience_Emotion = '' OR Audience_Emotion = ' ' OR LOWER(TRIM(Audience_Emotion)) IN ('n/a', 'unknown') OR
Engagement_Source IS NULL OR Engagement_Source = '' OR Engagement_Source = ' ' OR LOWER(TRIM(Engagement_Source)) IN ('n/a', 'unknown') OR 
Impressions IS NULL OR
Reach IS NULL OR
Likes IS NULL OR
Comments IS NULL OR
Shares IS NULL OR
Saves IS NULL OR
Profile_Visits IS NULL OR
Follows IS NULL; 


-- Hashtag Format Validtaion
WITH CTE AS (
SELECT
  Serial_Number,
  REGEXP_SUBSTR(Hashtags, '#[A-Za-z0-9_]+', 1, 1) AS Hashtag1,
  REGEXP_SUBSTR(Hashtags, '#[A-Za-z0-9_]+', 1, 2) AS Hashtag2,
  REGEXP_SUBSTR(Hashtags, '#[A-Za-z0-9_]+', 1, 3) AS Hashtag3,
  REGEXP_SUBSTR(Hashtags, '#[A-Za-z0-9_]+', 1, 4) AS Hashtag4
FROM instagram_data)

SELECT * FROM CTE WHERE Hashtag1 LIKE '#%,' OR Hashtag2 LIKE '#%,' OR Hashtag3 LIKE '#%,' OR Hashtag1 LIKE '#%,';

-- Convert Post_Date column format to data
ALTER TABLE instagram_data
ADD COLUMN Post_Date_Converted DATE;

UPDATE instagram_data
SET Post_Date_Converted = STR_TO_DATE(Post_Date,'%d-%m-%Y');

ALTER TABLE instagram_data
ADD COLUMN Hashtags_bak VARCHAR(244);
UPDATE instagram_data
SET Hashtags_bak = TRIM(Hashtags);
ALTER TABLE instagram_data DROP COLUMN Hashtags;
ALTER TABLE instagram_data CHANGE Hashtags_bak Hashtags VARCHAR(244);

SELECT Post_Date,Post_Date_Converted FROM instagram_data;

ALTER TABLE instagram_data DROP COLUMN Post_Date;
ALTER TABLE instagram_data CHANGE Post_Date_Converted Post_Date DATE;

SELECT * FROM instagram_data LIMIT 10;

-- Preliminary Analysis
SELECT
	Post_Type,
	COUNT(Post_Type) AS Number_of_Post
FROM instagram_data
GROUP BY Post_Type; 

SELECT
	Campaign_Type,
	COUNT(Campaign_Type) AS Number_of_Campaigns
FROM instagram_data
GROUP BY Campaign_Type;

SELECT
	Audience_Emotion,
	COUNT(Audience_Emotion) AS Number_of_Audience
FROM instagram_data
GROUP BY Audience_Emotion;

SELECT
	Engagement_Source,
	COUNT(Post_Type) AS Number_of_Engagement
FROM instagram_data
GROUP BY Engagement_Source;   