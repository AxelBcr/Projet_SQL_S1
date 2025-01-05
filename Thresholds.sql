-- Creating Dynamical Price Filter Threshold For Categories
-- Step 1: Create CategoryThreshold Table (if it does not exist)
IF OBJECT_ID('CategoryThreshold', 'U') IS NULL
CREATE TABLE CategoryThreshold (
    Category VARCHAR(50) PRIMARY KEY,
    MinPrice DECIMAL(10, 2),
    MaxPrice DECIMAL(10, 2)
);

-- Step 2: Extract Categories from ItemDescription and Insert Defaults
INSERT INTO CategoryThreshold (Category, MinPrice, MaxPrice)
SELECT DISTINCT 
    TRIM(LEFT(ItemDescription, CHARINDEX(')', ItemDescription))) AS Category,
    1 AS MinPrice, -- Default MinPrice
    1000 AS MaxPrice -- Default MaxPrice
FROM Offer
WHERE NOT EXISTS (
    SELECT 1 
    FROM CategoryThreshold CT
    WHERE CT.Category = TRIM(LEFT(Offer.ItemDescription, CHARINDEX(')', Offer.ItemDescription)))
);

-- Update Thresholds for Existing Categories in CategoryThreshold Table

-- J'ai pas eu le courage de tout optimiser, bonne chance...

-- Alimentaire
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Alimentaire)';

-- Artisanat
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Artisanat)';

-- Audio
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 800 WHERE Category = '(Audio)';

-- Automobile
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Automobile)';

-- Beaut�
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Beaut�)';

-- Bureau
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Bureau)';

-- Cuisine
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Cuisine)';

-- D�coration
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(D�coration)';

-- �clairage
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(�clairage)';

-- �lectronique
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(�lectronique)';

-- High-Tech
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(High-Tech)';

-- Hygi�ne
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 200 WHERE Category = '(Hygi�ne)';

-- Jardinage
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Jardinage)';

-- Jouets
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Jouets)';

-- Loisirs
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Loisirs)';

-- Maison
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 550 WHERE Category = '(Maison)';

-- Sant�
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 800 WHERE Category = '(Sant�)';

-- Sport
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Sport)';

-- Textile
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Textile)';

-- Transport
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Transport)';

-- V�tement
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(V�tements)';

-- Validate the Updated Thresholds
SELECT * FROM CategoryThreshold;