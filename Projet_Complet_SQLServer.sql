-- 1. Création de la table Log
drop table if exists Log
IF OBJECT_ID('Log', 'U') IS NULL
CREATE TABLE Log (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    LogDate DATETIME DEFAULT GETDATE(),
    Action VARCHAR(50),
    Details NVARCHAR(MAX)
);

-- 2. Validation des données dans blk_data (suppression des anomalies)
DELETE FROM blk_data
WHERE AppliedPrice <= 0 OR LocalReco <= 0;

-- 3. Insertion des nouvelles offres avec descriptions
INSERT INTO Offer (NumberID, StoreNumberID, StoreDescription, EAN, ItemDescription, Price, VerifiedDate, PeriodStart, PeriodEnd)
SELECT 
    ISNULL((SELECT MAX(NumberID) FROM Offer), 0) + ROW_NUMBER() OVER (ORDER BY B.AV_EAN) AS NumberID,
    B.StoreNumberID,
    S.Description AS StoreDescription, -- Récupération de la description du magasin
    B.AV_EAN,
    E.ItemDescription AS ItemDescription, -- Récupération de la description de l'article
    B.AppliedPrice, 
    GETDATE(), GETDATE(), '9999-12-31 00:00:00.000'
FROM blk_data AS B
LEFT JOIN Store AS S
ON B.StoreNumberID = S.NumberID
LEFT JOIN EANItem AS E
ON B.AV_EAN = E.EAN
WHERE NOT EXISTS (
    SELECT 1 FROM Offer AS O
    WHERE O.EAN = B.AV_EAN AND O.StoreNumberID = B.StoreNumberID
);

-- 4. Mise à jour des offres existantes avec descriptions
UPDATE O
SET 
    O.Price = B.AppliedPrice,
    O.VerifiedDate = GETDATE(),
    O.StoreDescription = ISNULL(S.Description, O.StoreDescription), -- Mise à jour description magasin
    O.ItemDescription = ISNULL(E.ItemDescription, O.ItemDescription) -- Mise à jour description article
FROM Offer AS O
INNER JOIN blk_data AS B
ON O.EAN = B.AV_EAN AND O.StoreNumberID = B.StoreNumberID
LEFT JOIN Store AS S
ON B.StoreNumberID = S.NumberID
LEFT JOIN EANItem AS E
ON B.AV_EAN = E.EAN
WHERE O.PeriodEnd = '9999-12-31 00:00:00.000';

-- 5. Fermeture des offres inactives (mise à jour de PeriodEnd, StockShortageDate)
UPDATE Offer
SET StockShortageDate = GETDATE(), PeriodEnd = GETDATE()
WHERE PeriodEnd <> '9999-12-31'
AND NOT EXISTS (
    SELECT 1 
    FROM blk_data AS B
    WHERE B.AV_EAN = Offer.EAN AND B.StoreNumberID = Offer.StoreNumberID
);

-- 6. Ajout de logs pour suivre l'importation
INSERT INTO Log (Action, Details)
VALUES ('IMPORT', 'Traitement des données depuis blk_data terminé avec descriptions.');

-- 7. Dernier tri post-insertion
DELETE from Offer
where Price <= 0 OR Price >= 5000

-- FIN DU SCRIPT
select * from Log
select * from Offer