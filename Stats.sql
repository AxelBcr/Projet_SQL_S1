-- Rapport statistique sur les Offres
SELECT 
    S.NumberID AS StoreID,
    S.Description AS StoreName,
    COUNT(O.NumberID) AS TotalOffers,
    SUM(CASE WHEN O.PeriodEnd = '9999-12-31' THEN 1 ELSE 0 END) AS ActiveOffers,
    SUM(CASE WHEN O.PeriodEnd < GETDATE() THEN 1 ELSE 0 END) AS ClosedOffers,
    SUM(CASE WHEN O.StockShortageDate IS NOT NULL THEN 1 ELSE 0 END) AS StockShortages,
    AVG(O.Price) AS AvgPrice,
    MIN(O.Price) AS MinPrice,
    MAX(O.Price) AS MaxPrice
FROM Offer AS O
LEFT JOIN Store AS S
ON O.StoreNumberID = S.NumberID
GROUP BY S.NumberID, S.Description
ORDER BY StoreID;
