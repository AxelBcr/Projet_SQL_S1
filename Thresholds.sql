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

-- Beauté
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Beauté)';

-- Bureau
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Bureau)';

-- Cuisine
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Cuisine)';

-- Décoration
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Décoration)';

-- Éclairage
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Éclairage)';

-- Électronique
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Électronique)';

-- High-Tech
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(High-Tech)';

-- Hygiène
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 200 WHERE Category = '(Hygiène)';

-- Jardinage
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Jardinage)';

-- Jouets
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Jouets)';

-- Loisirs
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Loisirs)';

-- Maison
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 550 WHERE Category = '(Maison)';

-- Santé
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 800 WHERE Category = '(Santé)';

-- Sport
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Sport)';

-- Textile
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Textile)';

-- Transport
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 1000 WHERE Category = '(Transport)';

-- Vêtement
UPDATE CategoryThreshold SET MinPrice = 1, MaxPrice = 500 WHERE Category = '(Vêtements)';

-- Validate the Updated Thresholds
SELECT * FROM CategoryThreshold;