-- Declare Variables
DECLARE @FileDate DATE = '2024-11-25'; -- Replace dynamically based on the file date



-- Log Inserted Offers
DROP TABLE IF EXISTS Log
IF OBJECT_ID('Log', 'U') IS NULL
CREATE TABLE Log (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    LogDate DATETIME DEFAULT GETDATE(),
    Action VARCHAR(50),
    Details NVARCHAR(MAX)
);



-- Log Newly Created Offers
INSERT INTO Log (Action, Details)
SELECT 
    'Insert', 
    CONCAT('Created new offer for EAN ', B.AV_EAN, 
           ' in store ', B.StoreNumberID, 
           ' with start date ', @FileDate, 
           ' and end date 9999-12-31')
FROM blk_data B
LEFT JOIN Offer O ON O.EAN = B.AV_EAN AND O.StoreNumberID = B.StoreNumberID
WHERE O.EAN IS NULL; -- Log only new offers



-- Insert Offers (Active and Inactive) with PeriodEnd = '9999-12-31'
INSERT INTO Offer (
    NumberID, StoreNumberID, StoreDescription, EAN, ItemDescription, Price, VerifiedDate, PeriodStart, PeriodEnd
)
SELECT 
    ISNULL((SELECT MAX(NumberID) FROM Offer), 0) + ROW_NUMBER() OVER (ORDER BY B.AV_EAN) AS NumberID,
    B.StoreNumberID,
    S.Description AS StoreDescription,
    B.AV_EAN,
    ISNULL(E.ItemDescription, 'Unknown Item') AS ItemDescription, -- Default for missing EANs
    B.AppliedPrice,
    GETDATE(), -- Verified date
    @FileDate, -- PeriodStart
    '9999-12-31' -- Default PeriodEnd for all offers
FROM blk_data B
LEFT JOIN Store S ON B.StoreNumberID = S.NumberID
LEFT JOIN EANItem E ON B.AV_EAN = E.EAN
LEFT JOIN Offer O ON O.EAN = B.AV_EAN AND O.StoreNumberID = B.StoreNumberID
WHERE O.EAN IS NULL; -- Only new offers

INSERT INTO Log (Action, Details)
SELECT 
    'Insert',
    CONCAT('Inserted offer for EAN ', B.AV_EAN, ' in store ', B.StoreNumberID)
FROM blk_data B
LEFT JOIN EANItem E ON B.AV_EAN = E.EAN
LEFT JOIN Offer O ON O.EAN = B.AV_EAN AND O.StoreNumberID = B.StoreNumberID
WHERE O.EAN IS NULL;



-- Log Updated Offers Before Changing Data
INSERT INTO Log (Action, Details)
SELECT 'Update', 
       CONCAT('Updated offer for EAN ', B.AV_EAN, 
              ' in store ', B.StoreNumberID, 
              ' from price ', O.Price, 
              ' to price ', B.AppliedPrice)
FROM Offer O
JOIN blk_data B 
    ON O.EAN = B.AV_EAN AND O.StoreNumberID = B.StoreNumberID
WHERE O.Price <> B.AppliedPrice; -- Capture differences before updating




-- Update Existing Offers (Price and VerifiedDate)
UPDATE O
SET O.Price = B.AppliedPrice,
    O.VerifiedDate = GETDATE()
FROM Offer O
JOIN blk_data B 
    ON O.EAN = B.AV_EAN AND O.StoreNumberID = B.StoreNumberID
WHERE O.Price <> B.AppliedPrice; -- Actual update



-- Close Offers Not Observed in blk_data after update
IF EXISTS (SELECT 1 FROM blk_data)
    UPDATE O
    SET O.PeriodEnd = @FileDate
    FROM Offer O
    LEFT JOIN blk_data B ON O.EAN = B.AV_EAN AND O.StoreNumberID = B.StoreNumberID
    WHERE B.AV_EAN IS NULL AND O.PeriodEnd = '9999-12-31';



-- Log Closed Offers
INSERT INTO Log (Action, Details)
SELECT 'Close', CONCAT('Closed offer for EAN ', O.EAN, ' in store ', O.StoreNumberID, ' on ', @FileDate)
FROM Offer O
LEFT JOIN blk_data B ON O.EAN = B.AV_EAN AND O.StoreNumberID = B.StoreNumberID
WHERE B.AV_EAN IS NULL AND O.PeriodEnd = @FileDate;



-- Log Anomalous Prices Based on Dynamic Thresholds
INSERT INTO Log (Action, Details)
SELECT 
    'Anomaly', 
    CONCAT('Anomalous price detected: ', B.AppliedPrice,
           ' for EAN ', B.AV_EAN,
           ' in category ', LEFT(O.ItemDescription, CHARINDEX(')', O.ItemDescription)))
FROM blk_data B
LEFT JOIN Offer O ON B.AV_EAN = O.EAN
LEFT JOIN CategoryThreshold C
    ON LEFT(O.ItemDescription, CHARINDEX(')', O.ItemDescription)) = C.Category
WHERE B.AppliedPrice < C.MinPrice OR B.AppliedPrice > C.MaxPrice;



-- Remove Anomalous Prices
DELETE O
FROM Offer O 
	INNER JOIN CategoryThreshold C
    ON LEFT(O.ItemDescription, CHARINDEX(')', O.ItemDescription)) = C.Category
WHERE O.Price < C.MinPrice OR O.Price > C.MaxPrice;



-- Printing Results
SELECT * FROM Offer;
SELECT * FROM Log;

-- End
