
-----------------------------------------------------------------------
USE ecommerce;
/*
    Homework week 4. Procedures, functions, views, and a review of SQL
    =============================================================

    We want to develop an automated process that will helps us to
    follow sales for a given period of time.
    To achieve this purpose, we will create:
        - A summary table to store results
        - A view that will get the specified information
        - Procedures that will allow us to store that information
        - A function to convert money values from euros to dollars
*/

/*
    Step 1. Create a table, call it: "myreport" to store results. This table must
    contain five fields:
        - dt_ini (will store the initial date for the queried period)
        - dt_end (will store the final date for the queried period)
        - qty (will store the number of sales for a given period)
        - amount_e (will store the amount generated in euros)
        - amount_d (will store the amount generated in dollars)
*/









/*  Step 2. Create a procedure, call it: "create_myreport" that creates the table we just defined
    (Note: it is a good practice for the procedure to delete 
    the table if it previously exists. 
    An initial version of the the procedure could be the following:
*/            
DROP PROCEDURE IF EXISTS create_myreport;
DELIMITER //    
CREATE PROCEDURE create_myreport()
BEGIN
DROP TABLE IF EXISTS myreport;
/* Code to create the table*/
END //
DELIMITER ;


/* Answer */


-- Call the procedure to create myreport




/*  
    Step 3) Create a function that receives a value in euros and 
    converts it to dollars.
    Note: Assume 1.25 dollars = 1 euro
    An initial version of the function is the following:
*/
DROP FUNCTION IF EXISTS euro_to_dollar;
DELIMITER //
CREATE FUNCTION euro_to_dollar(qty DECIMAL(8,2)) RETURNS DECIMAL(8,2)
    /* function body! */
    RETURN qty
//
DELIMITER ;


/* Answer */




/* 
    Step 4) A view is provided that summarizes the information about orders.
            The result of the view contains
            - Date of the order
            - Total amount generated in euros
    Note: we assume that the unit price of each product is 1 euro.
*/
DROP VIEW IF EXISTS myview;
CREATE VIEW myview AS
SELECT a.OrderID,
        a.OrderDate, 
        SUM(b.Quantity * 1 - b.Discount) AS total_e
FROM orders a
LEFT JOIN order_details b
ON a.OrderID = b.OrderID
GROUP BY a.OrderID, a.OrderDate;

/* Check that the view is syntactically correct */



/* 
    Step 5) Create a procedure, call it: "insert_myreport" that, given
    the initial date and the final date, calculates the total
    sales between the specified period, the amount generated
    (in euros and dollars), and inserts the result into the
    table.
    This procedure must use the previously created function and 
    view.    
    (Hint: you must use the INSERT INTO statement.)
    A preliminary version of the procedure is given below:
*/


DROP PROCEDURE IF EXISTS insert_myreport;
DELIMITER //
CREATE PROCEDURE insert_myreport (dt_ini DATE, dt_end DATE)
BEGIN
    INSERT INTO myreport (dt_ini, dt_end, qty, amount_e, amount_d)
    /* Query... */
    WHERE dt_ini <= OrderDate AND OrderDate <= dt_end;
END
//
DELIMITER ;


/* Answer */


/* CALL insert_myreport('1990-01-01','2000-01-01'); */


/*
    Step 6) Now everything is ready. We are asked to report the
    generated sales in semesters during the years 1996, 1997, and 1998
	(e.g.from '1996-01-01' to '1996-07-31' and so on).
    As we already have all procedures, functions, and views prepared to
    generate the report, it is as simple as executing....
*/





/*  And we have the result in the report table. have a look at it */



/*  
    Step 7)  Imagine now that we are asked to refine
    the report with a different exchange rate between
    euros and dollars (Now 1.30 dollars = 1 euro).
    Explain in few words what would you do to get the
    updated report.    
*/

/*  
    Answer: 
*/
