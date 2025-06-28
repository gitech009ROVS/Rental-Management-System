-- --------------------   READ DATA IN RELATIONS  -----------------------

SELECT * FROM USER;
SELECT * FROM LOCATION;
SELECT * FROM PROPERTY;
SELECT * FROM  RESERVATION;
SELECT * FROM  PAYMENT;
SELECT * FROM CANCELLATION;
SELECT * FROM REVIEW;

-- ----------------------   DESTROYING RELATIONS   -----------------------

DROP TABLE USER;
DROP TABLE LOCATION;
DROP TABLE PROPERTY;
DROP TABLE RESERVATION;
DROP TABLE PAYMENT;
DROP TABLE CANCELLATION;
DROP TABLE REVIEW;

-- --------------------   DEMO QUERIES  ----------------------- 

-- List all properties with their host names and locations.
SELECT P.PropertyID as Property_Id, U.Name AS Name, P.Title, P.PricePerNight, L.City, L.State, L.Country
FROM 
	PROPERTY P
	JOIN USER U ON P.HostID = U.UserID
	JOIN LOCATION L ON P.LocationID = L.LocationID
ORDER BY 
	L.City,P.Title;

-- Show reservations with guest names and property titles.
SELECT R.ReservationId, U.Name as Name, P.Title
FROM
	RESERVATION R
    JOIN USER U ON R.GuestID = U.UserID
    JOIN PROPERTY P ON R.PropertyID = P.PropertyID;
    
-- List all properties along with their reservation count [including properties with zero reservations]
SELECT P.PropertyID, P.Title, COUNT(R.ReservationID) AS COUNT
FROM 
	PROPERTY P 
    LEFT JOIN RESERVATION R ON P.PropertyID = R.PropertyID
GROUP BY P.propertyID;
	
-- List average rating for each property.
SELECT P.PropertyID, P.Title, AVG(R.Rating) AS AVERGAE
FROM 
	PROPERTY P 
    JOIN REVIEW R ON R.PropertyID = P.PropertyID
GROUP BY P.PropertyID;


-- Show total payment amount received per property.
WITH 
T AS
(
	SELECT R.ReservationID, SUM(Amount) AS Amount
    FROM 
		RESERVATION R 
        JOIN PAYMENT P ON R.ReservationID = P.ReservationID
	GROUP BY R.ReservationID
),
T1 AS
(
	SELECT P.PropertyID, T.ReservationID,
			CASE
				WHEN Amount IS NULL THEN 0
                ELSE Amount
			END AS Amount
    FROM PROPERTY P
    LEFT JOIN T ON P.PropertyID = (SELECT PropertyID FROM RESERVATION WHERE ReservationID = T.ReservationID)
),
T2 AS 
(
	SELECT T1.PropertyID, T1.Amount,
		CASE
			WHEN C.RefundAmount IS NULL THEN 0
            ELSE C.RefundAmount
		END AS RefundAmount
    FROM T1
    LEFT JOIN CANCELLATION C ON C.ReservationID = T1.ReservationID
)
SELECT PropertyID, Amount-RefundAmount AS Net_Amount
FROM T2
ORDER BY PropertyID ASC;

-- procedure to update the property only by host
DELIMITER $$
CREATE PROCEDURE UpdateProperty(
	IN inHostID INT,
    IN inPropertyID INT,
    IN inTitle VARCHAR(100),
    IN inAddress VARCHAR(200),
    IN inDescription TEXT,
    IN inPricePerNight DECIMAL(10, 2)
)
BEGIN
	IF (SELECT COUNT(*) FROM USER WHERE UserID = inHostID and Role = 'HOST') = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNAUTHORIZED USER'; -- CUSTOM ERROR
	ELSE
		UPDATE PROPERTY 
        SET 
			Title = inTitle,
            Address = inAddress,
            Description = inDescription,
            PricePerNight = inPricePerNight
		WHERE PropertyID = inPropertyID AND HostID = inHostID;
	END IF;
END$$
DELIMITER ;

-- Delete old failed payments about 1 year before [made a procedure as it requires authentication]
DELIMITER $$
CREATE PROCEDURE DeleteOldFailedPayments(IN inAdminID INT)
BEGIN
	IF (SELECT COUNT(*) FROM USER WHERE UserID = inAdminID and Role = 'ADMIN') = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNAUTHORIZED USER'; -- CUSTOM ERROR
	ELSE 
		DELETE FROM PAYMENT
		WHERE PaymentID IN (
			SELECT PaymentID
			FROM (
				SELECT PaymentID
				FROM PAYMENT
				WHERE (Status = 'FAILED' OR Status = 'PROCESSING')
					AND (PaymentDate < DATE_SUB(CURDATE(), INTERVAL 1 YEAR))
			) AS sub
		);
	END IF;
END$$
DELIMITER ;
-- CALL DeleteOldFailedPayments(); --> for admin only
-- drop procedure DeleteOldFailedPayments;

-- Identify loyal or repeat customers. [in future if possible we can give a special discount to these]
SELECT U.Name, COUNT(ReservationID) AS VISIT_COUNT
FROM USER U
	JOIN RESERVATION R ON U.UserID = R.GuestID
WHERE U.Role = 'GUEST'
GROUP BY U.UserID
HAVING VISIT_COUNT > 2;

-- Top 5 Properties by Review Rating
SELECT DENSE_RANK() OVER (ORDER BY AVG(Rating) DESC) AS RNK,
P.PropertyID, P.Title, AVG(Rating) AS AVG_RATING
FROM REVIEW R 
	JOIN PROPERTY P ON R.PropertyID = P.PropertyID
GROUP BY P.PropertyID
ORDER BY RNK
LIMIT 5;

-- Top 5 most expensive properties
SELECT DENSE_RANK() OVER (ORDER BY PricePerNight DESC) AS RNK,
P.PropertyID, P.Title, PricePerNight
FROM PROPERTY P
ORDER BY RNK
LIMIT 5;

-- procedure for cancelling with automatic refund
DELIMITER $$
CREATE PROCEDURE cancelReservation(IN resID INT, IN reason TEXT)
BEGIN

	-- our local variables
	DECLARE start_date DATE; 
    DECLARE curr_amount DECIMAL(10,2);
    DECLARE Refund DECIMAL(10,2);
    
    IF (SELECT COUNT(*) FROM RESERVATION WHERE resID = ReservationID) > 0 THEN
		SELECT StartDate into start_date FROM RESERVATION WHERE ReservationID = resID;
        SELECT P.Amount into curr_amount FROM PAYMENT P WHERE P.ReservationID = resID;
        IF DATEDIFF(start_date, CURDATE()) >= 7 THEN
			SET Refund = curr_amount;
		ELSEIF DATEDIFF(start_date, CURDATE()) >= 5 THEN
			SET Refund = curr_amount/2;
		ELSEIF DATEDIFF(start_date, CURDATE()) >= 2 THEN
			SET Refund = curr_amount/4;
		ELSE 
			SET Refund = 0;
		END IF;
	END IF;
    
    INSERT INTO CANCELLATION (ReservationID, CancelDate, Reason, RefundAmount)
    VALUES (resID, CURDATE(), reason, Refund);
    
END$$
DELIMITER ;
-- CALL cancelReservation(); --> for admin only
-- drop procedure cancelReservation;

-- --------------------   DELETING STALE DATA AUTOMATICALLY WITH NO AUTHORIZATIONS  ----------------------- 

-- delete all the payments whose status is processing and the deadline crossed
SET SQL_SAFE_UPDATES = 0;
DELETE FROM PAYMENT 
WHERE Status = 'PROCESSING' 
	AND ReservationID IN ( 
		SELECT ReservationID 
        FROM RESERVATION 
        WHERE StartDate <= CURDATE()
	);
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM PAYMENT;

-- delete user who reserved a property but did not go for payment with in 1 day 
SET SQL_SAFE_UPDATES = 0;
DELETE FROM RESERVATION
WHERE reservationID NOT IN (
		SELECT reservationID
        FROM PAYMENT
	);
SET SQL_SAFE_UPDATES = 1;

-- delete user whose endDate has gone past one year ago
SET SQL_SAFE_UPDATES = 0;
DELETE FROM RESERVATION
WHERE CURDATE() >= DATE_ADD(endDate, INTERVAL 1 YEAR) ;
SET SQL_SAFE_UPDATES = 1;