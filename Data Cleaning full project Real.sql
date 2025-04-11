-- DATA CLEANING


SELECT *
FROM layoffs;




CREATE TABLE layoffs_staging 
LIKE layoffs; 

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;



SELECT * 
FROM layoffs;



SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num #using the backticks for date as date is a key word in sql
FROM layoffs_staging;


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num 
FROM layoffs_staging;

WITH duplicate_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num #using the backticks for date as date is a key word in sql
FROM layoffs_staging
)
SELECT * 
FROM duplicate_CTE 
WHERE row_num > 1;




SELECT *
FROM layoffs_staging
WHERE company = 'oda';


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging;

WITH duplicate_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging
)
SELECT * 
FROM duplicate_CTE 
WHERE row_num > 1;



SELECT *
FROM layoffs_staging
WHERE company = 'casper';




CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



SELECT *
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num 
FROM layoffs_staging;


SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


DELETE 
FROM layoffs_staging2
WHERE row_num > 1;


SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


SELECT *
FROM layoffs_staging2;



-- 2. STANDARDISING DATA 

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company); 



SELECT company, TRIM(company)  
FROM layoffs_staging2;

SELECT DISTINCT industry  
FROM layoffs_staging2
ORDER BY 1; 



SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';


SELECT DISTINCT industry
FROM layoffs_staging2;



SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1; 

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1; 

-- THE RECOMMENDED ROUTE:

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%';


-- IF U DOUBLE CLICK LAYOFFS_STAGING3, DOUBLE CLICK COLUMNS, And u will see that date is in TEXT. this isnt good if u want to do a time series.
-- YOU WANT TO CHANGE THIS TO A DATE COLUMN 



SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y' ) 
FROM layoffs_staging2; 

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y' ) ;


SELECT `date`
FROM layoffs_staging2; 


-- To try to change to a date column. only do this on staging table, NEVER RAW TABLE

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT *
FROM layoffs_staging2;


-- 3. NULLS AND BLANK VALUES

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;




UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''; 



SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';


SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;



SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%'; 


SELECT * 
FROM layoffs_staging2;


-- 4. remove columns or rows that r not needed

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;



DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;



SELECT *
FROM layoffs_staging2;



ALTER TABLE layoffs_staging2
DROP COLUMN row_num;














 

































