USE musicstore;

###########################
# Exercise 1: Levenshtein #
###########################

-- levenshtein
DROP FUNCTION IF EXISTS levenshtein;

DELIMITER $$
CREATE FUNCTION levenshtein( s1 VARCHAR(255), s2 VARCHAR(255) )
	RETURNS INT
	DETERMINISTIC
	BEGIN
		DECLARE s1_len, s2_len, i, j, c, c_temp, cost INT;
		DECLARE s1_char CHAR;
		DECLARE cv0, cv1 VARBINARY(256);
    
		SET s1_len = CHAR_LENGTH(s1), s2_len = CHAR_LENGTH(s2), cv1 = 0x00, j = 1, i = 1, c = 0;
		IF s1 = s2 THEN
			RETURN 0;
		ELSEIF s1_len = 0 THEN
			RETURN s2_len;
		ELSEIF s2_len = 0 THEN
			RETURN s1_len;
		ELSE
			WHILE j <= s2_len DO
				SET cv1 = CONCAT(cv1, UNHEX(HEX(j))), j = j + 1;
			END WHILE;
			WHILE i <= s1_len DO
				SET s1_char = SUBSTRING(s1, i, 1), c = i, cv0 = UNHEX(HEX(i)), j = 1;
				WHILE j <= s2_len DO
					SET c = c + 1;
					IF s1_char = SUBSTRING(s2, j, 1) THEN
						SET cost = 0; 
					ELSE 
						SET cost = 1;
					END IF;
					SET c_temp = CONV(HEX(SUBSTRING(cv1, j, 1)), 16, 10) + cost;
					IF c > c_temp THEN SET c = c_temp; END IF;
					SET c_temp = CONV(HEX(SUBSTRING(cv1, j+1, 1)), 16, 10) + 1;
					IF c > c_temp THEN
						SET c = c_temp;
					END IF;
					SET cv0 = CONCAT(cv0, UNHEX(HEX(c))), j = j + 1;
				END WHILE;
				SET cv1 = cv0, i = i + 1;
			END WHILE;
		END IF;
		RETURN c;
	END$$
DELIMITER ;


-- Levenshtein ratio
DROP FUNCTION IF EXISTS levenshtein_ratio;

DELIMITER $$
CREATE FUNCTION levenshtein_ratio( s1 VARCHAR(255), s2 VARCHAR(255) )
	RETURNS INT
	DETERMINISTIC
	BEGIN
		DECLARE s1_len, s2_len, max_len INT;
        
		SET s1_len = LENGTH(s1), s2_len = LENGTH(s2);
		IF isnull(s1) or isnull(s2) THEN
			RETURN 0;
		ELSEIF s1_len=0 AND s2_len=0 THEN
			RETURN 1;
        ELSEIF s1_len > s2_len THEN
			SET max_len = s1_len;
		ELSE
			SET max_len = s2_len;
		END IF;
		RETURN ROUND((1 - LEVENSHTEIN(s1, s2) / max_len) * 100);
	END$$
DELIMITER ;    
    
-- test function    
SELECT levenshtein_ratio('aaa','bbb') FROM dual;
SELECT levenshtein_ratio('aaa','bab') FROM dual;
SELECT levenshtein_ratio('','') FROM dual;
SELECT levenshtein_ratio(NULL,'bab') FROM dual;
SELECT levenshtein_ratio('aaa',NULL) FROM dual;
SELECT levenshtein_ratio(NULL,NULL) FROM dual;

####################################
# Exercise 2: k-nearest neighbours #
####################################
DROP TABLE IF EXISTS knn_summary;

CREATE TABLE knn_summary AS
	SELECT a.CustomerID, a.Country, a.SupportRepId,
		   CASE WHEN b.total IS NULL THEN 0 ELSE b.total END AS TotalAmount
      FROM Customer a
           LEFT JOIN (SELECT CustomerID, SUM(Total) AS total
                        FROM Invoice
                    GROUP BY CustomerID) b
				  ON a.CustomerID = b.CustomerID;

DROP TABLE IF EXISTS customers_genres;

CREATE TABLE customers_genres AS
	SELECT a.CustomerID, Genre.Name Genre
	from Genre inner join (
		select b.CustomerID, Track.GenreId 
		 from Track inner join (
			SELECT Invoice.CustomerID, InvoiceLine.TrackID 
				from InvoiceLine 
					inner join	Invoice 
				ON InvoiceLine.InvoiceID=Invoice.InvoiceID) b 
			ON Track.TrackID=b.TrackID) a 
		ON Genre.GenreId=a.GenreID
		group by Genre.Name, a.CustomerID;

DROP PROCEDURE IF EXISTS similar_customers;

DELIMITER $$
CREATE PROCEDURE similar_customers ()
BEGIN
	declare n int default 0;
	declare i int default 0;
    declare cntry varchar(255);
    declare supprep int;
    declare totam double;
    declare cust int;
    
    
    
    select count(CustomerId) from Customer into n;

	DROP TABLE IF EXISTS similar_customers;

    CREATE TABLE similar_customers(
							CustomerID int,
                            similar_CustomerID int,
                            Country Varchar(255),
                            SupportRepId int,
                            TotalAmount double,
                            country_sim int,
                            support_sim int,
                            amount_sim double,
                            gen_sim int,
                            similarity double);

	set i=0;
    while i<n DO
			
		select CustomerID, Country, SupportRepId, TotalAmount
			from knn_summary
		order by CustomerID limit i,1 into cust, cntry, supprep, totam;
                    
		INSERT INTO similar_customers 
        SELECT cust, z.*,
			   country_sim + support_sim + amount_sim + gen_sim AS similarity
		  FROM (
				SELECT knn_summary.*,
					   CASE WHEN Country = cntry THEN 3 ELSE 0 END AS country_sim,
					   CASE WHEN SupportRepID = supprep THEN 1 ELSE 0 END AS support_sim,
					   6 * (1 - ABS(TotalAmount - totam)/GREATEST(TotalAmount,totam)) AS amount_sim,
					   count(genre) as gen_sim 
				  FROM knn_summary
				  inner join (select genre, CustomerID 
								from customers_genres where genre in 
								(select genre from customers_genres where customerID=1)) a
							ON knn_summary.CustomerID=a.CustomerID         
				 WHERE knn_summary.CustomerId != cust
				 group by knn_summary.CustomerID, Country, SupportRepId, TotalAmount
				) z
		  ORDER BY similarity DESC
		  LIMIT 3;
		
        set i=i+1;
	END WHILE;
END$$
DELIMITER ;         

call similar_customers;


SELECT z.*,
       country_sim + support_sim + amount_sim + gen_sim AS similarity
  FROM (
        SELECT knn_summary.*,
			   CASE WHEN Country = 'Brazil' THEN 3 ELSE 0 END AS country_sim,
               CASE WHEN SupportRepID = 3 THEN 1 ELSE 0 END AS support_sim,
			   6 * (1 - ABS(TotalAmount - 39.62)/GREATEST(TotalAmount,39.62)) AS amount_sim,
               count(genre) as gen_sim 
          FROM knn_summary
          inner join (select genre, CustomerID 
						from customers_genres where genre in 
                        (select genre from customers_genres where customerID=1)) a
					ON knn_summary.CustomerID=a.CustomerID         
         WHERE knn_summary.CustomerId != 1
         group by knn_summary.CustomerID, Country, SupportRepId, TotalAmount
        ) z
  ORDER BY similarity DESC
  LIMIT 3;

##################################
# Exercise 3: Transitive Closure #
##################################

-- create table karate
DROP TABLE IF EXISTS karate;
CREATE TABLE karate (
	f1 INT,
	f2 INT);
    
-- data dump    
INSERT INTO karate(f1,f2) VALUES(2,1);
INSERT INTO karate(f1,f2) VALUES(3,1);
INSERT INTO karate(f1,f2) VALUES(3,2);
INSERT INTO karate(f1,f2) VALUES(4,1);
INSERT INTO karate(f1,f2) VALUES(4,2);
INSERT INTO karate(f1,f2) VALUES(4,3);
INSERT INTO karate(f1,f2) VALUES(5,1);
INSERT INTO karate(f1,f2) VALUES(6,1);
INSERT INTO karate(f1,f2) VALUES(7,1);
INSERT INTO karate(f1,f2) VALUES(7,5);
INSERT INTO karate(f1,f2) VALUES(7,6);
INSERT INTO karate(f1,f2) VALUES(8,1);
INSERT INTO karate(f1,f2) VALUES(8,2);
INSERT INTO karate(f1,f2) VALUES(8,3);
INSERT INTO karate(f1,f2) VALUES(8,4);
INSERT INTO karate(f1,f2) VALUES(9,1);
INSERT INTO karate(f1,f2) VALUES(9,3);
INSERT INTO karate(f1,f2) VALUES(10,3);
INSERT INTO karate(f1,f2) VALUES(11,1);
INSERT INTO karate(f1,f2) VALUES(11,5);
INSERT INTO karate(f1,f2) VALUES(11,6);
INSERT INTO karate(f1,f2) VALUES(12,1);
INSERT INTO karate(f1,f2) VALUES(13,1);
INSERT INTO karate(f1,f2) VALUES(13,4);
INSERT INTO karate(f1,f2) VALUES(14,1);
INSERT INTO karate(f1,f2) VALUES(14,2);
INSERT INTO karate(f1,f2) VALUES(14,3);
INSERT INTO karate(f1,f2) VALUES(14,4);
INSERT INTO karate(f1,f2) VALUES(17,6);
INSERT INTO karate(f1,f2) VALUES(17,7);
INSERT INTO karate(f1,f2) VALUES(18,1);
INSERT INTO karate(f1,f2) VALUES(18,2);
INSERT INTO karate(f1,f2) VALUES(20,1);
INSERT INTO karate(f1,f2) VALUES(20,2);
INSERT INTO karate(f1,f2) VALUES(22,1);
INSERT INTO karate(f1,f2) VALUES(22,2);
INSERT INTO karate(f1,f2) VALUES(26,24);
INSERT INTO karate(f1,f2) VALUES(26,25);
INSERT INTO karate(f1,f2) VALUES(28,3);
INSERT INTO karate(f1,f2) VALUES(28,24);
INSERT INTO karate(f1,f2) VALUES(28,25);
INSERT INTO karate(f1,f2) VALUES(29,3);
INSERT INTO karate(f1,f2) VALUES(30,24);
INSERT INTO karate(f1,f2) VALUES(30,27);
INSERT INTO karate(f1,f2) VALUES(31,2);
INSERT INTO karate(f1,f2) VALUES(31,9);
INSERT INTO karate(f1,f2) VALUES(32,1);
INSERT INTO karate(f1,f2) VALUES(32,25);
INSERT INTO karate(f1,f2) VALUES(32,26);
INSERT INTO karate(f1,f2) VALUES(32,29);
INSERT INTO karate(f1,f2) VALUES(33,3);
INSERT INTO karate(f1,f2) VALUES(33,9);
INSERT INTO karate(f1,f2) VALUES(33,15);
INSERT INTO karate(f1,f2) VALUES(33,16);
INSERT INTO karate(f1,f2) VALUES(33,19);
INSERT INTO karate(f1,f2) VALUES(33,21);
INSERT INTO karate(f1,f2) VALUES(33,23);
INSERT INTO karate(f1,f2) VALUES(33,24);
INSERT INTO karate(f1,f2) VALUES(33,30);
INSERT INTO karate(f1,f2) VALUES(33,31);
INSERT INTO karate(f1,f2) VALUES(33,32);
INSERT INTO karate(f1,f2) VALUES(34,9);
INSERT INTO karate(f1,f2) VALUES(34,10);
INSERT INTO karate(f1,f2) VALUES(34,14);
INSERT INTO karate(f1,f2) VALUES(34,15);
INSERT INTO karate(f1,f2) VALUES(34,16);
INSERT INTO karate(f1,f2) VALUES(34,19);
INSERT INTO karate(f1,f2) VALUES(34,20);
INSERT INTO karate(f1,f2) VALUES(34,21);
INSERT INTO karate(f1,f2) VALUES(34,23);
INSERT INTO karate(f1,f2) VALUES(34,24);
INSERT INTO karate(f1,f2) VALUES(34,27);
INSERT INTO karate(f1,f2) VALUES(34,28);
INSERT INTO karate(f1,f2) VALUES(34,29);
INSERT INTO karate(f1,f2) VALUES(34,30);
INSERT INTO karate(f1,f2) VALUES(34,31);
INSERT INTO karate(f1,f2) VALUES(34,32);
INSERT INTO karate(f1,f2) VALUES(34,33);


-- transitive closure
DROP PROCEDURE IF EXISTS proc_karate_transitive_closure;

DELIMITER //
CREATE PROCEDURE proc_karate_transitive_closure(initialid INT)
	BEGIN
		SET @initialid = initialid;
		DROP TABLE IF EXISTS karate_tc;
		CREATE TABLE karate_tc AS SELECT @initialid AS id FROM dual;
		SELECT * FROM karate_tc;
        
		REPEAT
			INSERT INTO karate_tc(id)
				SELECT DISTINCT f1 AS id FROM karate WHERE f2 IN (SELECT id FROM karate_tc) AND f1 NOT IN (SELECT id FROM karate_tc)
				UNION DISTINCT
				SELECT DISTINCT f2 AS id FROM karate WHERE f1 IN (SELECT id FROM karate_tc) AND f2 NOT IN (SELECT id FROM karate_tc);
		UNTIL ROW_COUNT() = 0 END REPEAT;
	END//
DELIMITER ;

-- test transitive closure    
CALL proc_karate_transitive_closure(1);
SELECT COUNT(*) FROM karate_tc;
CALL proc_karate_transitive_closure(11);
SELECT COUNT(*) FROM karate_tc;