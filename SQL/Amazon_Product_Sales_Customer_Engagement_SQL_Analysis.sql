-- ==========================================================
-- AMAZON PRODUCT SALES & CUSTOMER ENGAGEMENT ANALYSIS
-- DATABASE: amazon_sales_db
-- Table: amazon_products
-- Records: 41,650
-- ==========================================================

CREATE DATABASE  IF NOT EXISTS amazon_sales_db;
USE amazon_sales_db;
-- =============================================================================================
# DATA VALIDATION
-- ===============================================================================================

-- Check total number of records

SELECT COUNT(*) AS Total_Rows
FROM amazon_products;

-- Columns and Data Types

Describe amazon_products;

-- Missing Values

SELECT
SUM(CASE WHEN `Product_title` IS NULL OR TRIM(`Product_title`)= '' THEN 1 ELSE 0 END) AS missing_product_title,
SUM(CASE WHEN `rating` IS NULL THEN 1 ELSE 0 END) AS missing_rating,
SUM(CASE WHEN `review_count_clean` IS NULL OR TRIM(`review_count_clean`)= '' THEN 1 ELSE 0 END) AS missing_review_count,
SUM(CASE WHEN `monthly_purchase_estimate` IS NULL OR TRIM(`monthly_purchase_estimate`)= '' THEN 1 ELSE 0 END) AS missing_monthly_purchase,
SUM(CASE WHEN `current_price_clean` IS NULL OR TRIM(`current_price_clean`)= '' THEN 1 ELSE 0 END) AS missing_current_price,
SUM(CASE WHEN `variant_price_clean` IS NULL OR TRIM(`variant_price_clean`)= '' THEN 1 ELSE 0 END) AS missing_variant_price,
SUM(CASE WHEN `listed_price_clean` IS NULL OR TRIM(`listed_price_clean`)= ''THEN 1 ELSE 0 END) AS missing_listed_price
FROM amazon_products;

-- Duplicate Product URLs

SELECT
COUNT(*) AS total_records,
COUNT(DISTINCT `product_url`) AS unique_product_url,
COUNT(*) - COUNT(DISTINCT `product_url`) AS duplicate_url_records
FROM amazon_products;

-- =============================================================================================
# PRODUCT PERFORMANCE ANALYSIS
-- ==============================================================================================

-- Average product rating

SELECT 
ROUND(AVG(`rating`), 2) AS average_product_rating
FROM amazon_products;

-- Total Reviews

SELECT
SUM(`review_count_clean`) AS total_reviews
FROM amazon_products;

-- Average Reviews

SELECT
ROUND(AVG(`review_count_clean`), 2) AS average_reviews_per_products
FROM amazon_products;

-- Average monthly Purchases

SELECT
ROUND(AVG(`monthly_purchase_estimate`), 2) AS average_monthly_purchase
FROM amazon_products;

-- Top 10 Products by Reviews

SELECT
`Product_title`,
`review_count_clean`,
`rating`,
`current_price_clean`
FROM amazon_products
WHERE `review_count_clean` IS NOT NULL
ORDER BY `review_count_clean` DESC
LIMIT 10;

-- ============================================================================================
# PRICING ANALYSIS
-- =============================================================================================

-- Average current price

SELECT
ROUND(AVG(`current_price_clean`), 2) AS average_current_price
FROM amazon_products
WHERE `current_price_clean` IS NOT NULL;

-- Minimum and maximum current price

SELECT
MIN(`current_price_clean`) AS minimum_current_price,
MAX(`current_price_clean`) AS maximum_current_price
FROM amazon_products
WHERE `current_price_clean` IS NOT NULL;

-- Product count by Price Range

SELECT
`Price Range`,
COUNT(*) AS product_count
FROM amazon_products
WHERE `Price Range` IS NOT NULL
GROUP BY `Price Range`
ORDER BY product_count DESC;

-- Average rating by Price Range

SELECT
`Price Range`,
ROUND(AVG(`rating`), 2) AS average_rating,
COUNT(*) AS product_count
FROM amazon_products
WHERE `Price Range` IS NOT NULL
AND `rating` IS NOT NULL
GROUP BY `Price Range`
ORDER BY average_rating DESC;

-- Average review count by Price Range

SELECT 
`Price Range`,
ROUND(AVG(`review_count_clean`), 2) AS average_review_count,
COUNT(*) AS product_count
FROM amazon_products
WHERE `Price Range` IS NOT NULL
AND `review_count_clean` IS NOT NULL
GROUP BY `Price Range`
ORDER BY average_review_count DESC;

-- ==========================================================================================
# DISCOUNT ANALYSIS
-- ===========================================================================================

-- Average discount percentage

SELECT
ROUND(AVG(`Discount %`), 2) AS average_discount_percentage
FROM amazon_products
WHERE `Discount %` IS NOT NULL;

-- Product count by Discount Range

SELECT
`Discount Range`,
COUNT(*) AS product_count
FROM amazon_products
WHERE `Discount Range` IS NOT NULL
GROUP BY `Discount Range`
ORDER BY product_count DESC;

-- Average rating by Discount Range

SELECT
`Discount Range`,
ROUND(AVG(`rating`), 2) AS average_rating,
COUNT(*) AS product_count
FROM amazon_products
WHERE `Discount Range` IS NOT NULL
AND `rating` IS NOT NULL
GROUP BY `Discount Range`
ORDER BY average_rating DESC;

-- Average review count by Discount Range

SELECT 
`Discount Range`,
ROUND(AVG(`review_count_clean`), 2) AS average_review_count,
COUNT(*) AS product_count
FROM amazon_products
WHERE `Discount Range` IS NOT NULL
AND `review_count_clean` IS NOT NULL
GROUP BY `Discount Range`
ORDER BY average_review_count DESC;

-- =========================================================================================
# MARKETPLACE & PROMOTION ANALYSIS
-- ==========================================================================================

-- Q19. Best Seller vs non-Best Seller product count

SELECT
`is_best_seller`,
COUNT(*) AS product_count
FROM amazon_products
WHERE `is_best_seller` IS NOT NULL
GROUP BY `is_best_seller`
ORDER BY product_count DESC;

-- Sponsored vs non-sponsored product count
SELECT
`is_sponsored`,
COUNT(*) AS product_count
FROM amazon_products
WHERE `is_sponsored` IS NOT NULL
GROUP BY `is_sponsored`
ORDER BY product_count DESC;

-- Coupon available vs unavailable product count

SELECT
`coupon_available`,
COUNT(*) AS product_count
FROM amazon_products
WHERE `coupon_available` IS NOT NULL
GROUP BY `coupon_available`
ORDER BY product_count DESC;

-- Buy Box available vs unavailable product count

SELECT
`buy_box_status_clean`,
COUNT(*) AS product_count
FROM amazon_products
WHERE `buy_box_status_clean` IS NOT NULL
GROUP BY `buy_box_status_clean`
ORDER BY product_count DESC;

-- Sustainability badge vs no badge product count

SELECT
`Sustainablity_badge_status`,
COUNT(*) AS product_count
FROM amazon_products
WHERE `Sustainablity_badge_status` IS NOT NULL
GROUP BY `Sustainablity_badge_status`
ORDER BY product_count DESC;

-- ==========================================================================================
# CUSTOMER ENGAGEMENT ANALYSIS
-- ===========================================================================================

-- Product count by rating

SELECT
`rating`,
COUNT(*) AS product_count
FROM amazon_products
WHERE `rating` IS NOT NULL
GROUP BY `rating`
ORDER BY product_count DESC;

-- Average reviews by rating

SELECT
`rating`,
ROUND(AVG(`review_count_clean`), 2) AS average_review_count,
COUNT(*) AS product_count
FROM amazon_products
WHERE `rating` IS NOT NULL
AND `review_count_clean` IS NOT NULL
GROUP BY `rating`
ORDER BY `average_review_count` DESC;

-- Which rating has the highest average review count?

SELECT
`rating`,
ROUND(AVG(`review_count_clean`),  2) AS average_review_count
FROM amazon_products
WHERE `rating` IS NOT NULL
AND `review_count_clean` IS NOT NULL
GROUP BY `rating`
ORDER BY average_review_count DESC
LIMIT 1;

-- How do Best Seller products compare with non-Best Sellers?

SELECT
`is_best_seller` AS seller_status,
COUNT(*) AS product_count,
ROUND(AVG(`rating`), 2) AS average_rating,
ROUND(AVG(`review_count_clean`), 2) AS average_reviews,
ROUND(AVG(`monthly_purchase_estimate`), 2) AS average_monthly_purchases
FROM amazon_products
WHERE `is_best_seller` IS NOT NULL
GROUP BY `is_best_seller`
ORDER BY average_reviews DESC;

-- =====================================================================================
# CASE WHEN — PRODUCT SEGMENTATION
-- =====================================================================================
-- Rating Segmentation

SELECT
`Product_title`,
`rating`,
CASE 
WHEN `rating` >= 4.5 THEN 'Excellent'
WHEN `rating` >= 4.0 THEN 'Good'
WHEN `rating` >= 3.0 THEN 'Average'
ELSE 'Poor'
END AS rating_categories
FROM amazon_products
WHERE `rating` IS NOT NULL;

-- THEN 

-- Analyze rating categories
SELECT
    CASE
        WHEN `rating` >= 4.5 THEN 'Excellent'
        WHEN `rating` >= 4.0 THEN 'Good'
        WHEN `rating` >= 3.0 THEN 'Average'
        ELSE 'Poor'
    END AS rating_category,
    COUNT(*) AS product_count
FROM amazon_products
WHERE `rating` IS NOT NULL
GROUP BY rating_category
ORDER BY product_count DESC;

-- Review Segmentation

SELECT
`Product_title`,
`review_count_clean`,
CASE
WHEN `review_count_clean` < 100 THEN 'Low'
WHEN `review_count_clean`< 1000 THEN 'Medium'
WHEN `review_count_clean` < 10000 THEN 'High'
ELSE 'Very High'
END AS review_category
FROM amazon_products
WHERE `review_count_clean` IS NOT NULL;

-- THEN

-- Analyze review-count categories
SELECT
CASE
WHEN `review_count_clean` < 100 THEN 'Low'
WHEN `review_count_clean`< 1000 THEN 'Medium'
WHEN `review_count_clean` < 10000 THEN 'High'
ELSE 'Very High'
END AS review_category,
COUNT(*) AS Product_count
FROM amazon_products
WHERE `review_count_clean` IS NOT NULL
GROUP BY `review_category`
ORDER BY Product_count DESC;

-- Price Segmentation

SELECT
`Product_title`,
`Current_price_clean`,
CASE 
WHEN `Current_price_clean` < 100 THEN 'Budget'
WHEN `Current_price_clean` < 300 THEN 'Mid-Range'
WHEN `Current_price_clean` < 1000 THEN 'Premium'
ELSE 'Luxury'
END AS Price_Category
FROM amazon_products
WHERE `Current_price_clean` IS NOT NULL;

-- THEN

-- Analyze price categories
SELECT
CASE 
WHEN `Current_price_clean` < 100 THEN 'Budget'
WHEN `Current_price_clean` < 300 THEN 'Mid-Range'
WHEN `Current_price_clean` < 1000 THEN 'Premium'
ELSE 'Luxury'
END AS Price_Category,
COUNT(*) AS Product_count
FROM amazon_products
WHERE `Current_price_clean` IS NOT NULL
GROUP BY Price_Category
ORDER BY Product_count DESC;

-- =========================================================================== 
# ADVANCED BUSINESS ANALYSIS
-- ============================================================================

-- Which products are priced above the marketplace average?

SELECT
`Product_title`,
`Current_price_clean`,
`rating`,
`review_count_clean`
FROM amazon_products
WHERE `Current_price_clean` > (
SELECT AVG(`Current_price_clean`)
FROM amazon_products
WHERE `Current_price_clean` IS NOT NULL
)
ORDER BY Current_price_clean DESC;

-- Which products have ratings above the marketplace average?

SELECT
`Product_title`,
`rating`,
`review_count_clean`,
`Current_price_clean`
FROM amazon_products
WHERE `rating` > (
SELECT AVG(`rating`)
FROM amazon_products
WHERE `rating` IS NOT NULL
)
ORDER BY `rating` DESC;

-- Which products are above average in both rating and reviews?

WITH averages AS(
SELECT
AVG(`rating`) AS avg_rating,
AVG(`review_count_clean`) AS avg_reviews
FROM amazon_products
)
SELECT 
p.`Product_title`,
p.`rating`,
p.`review_count_clean`,
p.`Current_price_clean`
FROM amazon_products p
CROSS JOIN averages a
WHERE p.`rating` > a.avg_rating
AND p.`review_count_clean` > a.avg_reviews
ORDER BY p.`review_count_clean` DESC;

-- Product Ranking

SELECT
`Product_title`,
`review_count_clean`,
RANK() OVER(
ORDER BY `review_count_clean` DESC
) AS review_rank
FROM amazon_products 
WHERE `review_count_clean` IS NOT NULL
ORDER BY `review_rank`
LIMIT 20; 

-- Rank products within each Price Range

SELECT
`Product_title`,
`Price Range`,
`review_count_clean`,
RANK() OVER(
PARTITION BY `Price Range`
ORDER BY `review_count_clean` DESC
) AS price_range_rank
FROM amazon_products
WHERE `Price Range` IS NOT NULL
AND `review_count_clean` IS NOT NULL
ORDER BY `Price Range`, `price_range_rank`;

--  Find the top 3 most-reviewed products in each Price Range

WITH ranked_products AS (
SELECT
`Product_title`,
`Price Range`,
`review_count_clean`,
`rating`,
`Current_price_clean`,
RANK() OVER(
PARTITION BY `Price Range`
ORDER BY `review_count_clean` DESC
) AS product_rank
FROM amazon_products
WHERE `Price Range` IS NOT NULL
AND `review_count_clean` IS NOT NULL
)
SELECT
`Product_title`,
`Price Range`,
`review_count_clean`,
`rating`,
`Current_price_clean`,
product_rank
FROM ranked_products 
WHERE product_rank <= 3
ORDER BY `Price Range`, product_rank;

-- ========================================================================================= 
-- FINAL BUSINESS ANALYSIS
-- ========================================================================================= 

-- Identify high-performing products

WITH averages AS(
SELECT
AVG(`rating`) AS avg_rating,
AVG(`review_count_clean`) AS avg_reviews,
AVG(`monthly_purchase_estimate`) AS avg_purchases
FROM amazon_products
)
SELECT
p.`Product_title`,
p.`rating`,
p.`review_count_clean`,
p.`monthly_purchase_estimate`,
p.`current_price_clean`
FROM amazon_products p
CROSS JOIN averages a
WHERE p.`rating` >= a.avg_rating
AND p.`review_count_clean` >= a.avg_reviews
AND p.`monthly_purchase_estimate` >= a.avg_purchases
ORDER BY p.`review_count_clean` DESC;

-- Identify potentially weak products

WITH averages AS (
SELECT
AVG(`rating`) AS avg_rating,
AVG(`review_count_clean`) AS avg_reviews,
AVG(`monthly_purchase_estimate`) AS avg_purchases
FROM amazon_products
)
SELECT
p.`Product_title`,
p.`rating`,
p.`review_count_clean`,
p.`monthly_purchase_estimate`,
p.`current_price_clean`
FROM amazon_products p
CROSS JOIN averages a
WHERE p.`rating` < a.avg_rating
AND p.`review_count_clean` < a.avg_reviews
AND p.`monthly_purchase_estimate` < a.avg_purchases
ORDER BY p.`rating` ASC;

-- Strongest Price Segment

SELECT
    `Price Range`,
    COUNT(*) AS product_count,
    ROUND(AVG(`rating`), 2) AS average_rating,
    ROUND(AVG(`review_count_clean`), 2) AS average_reviews,
    ROUND(AVG(`monthly_purchase_estimate`), 2) AS average_purchases
FROM amazon_products
WHERE `Price Range` IS NOT NULL
GROUP BY `Price Range`
ORDER BY average_purchases DESC;

-- Compare performance across discount segments

SELECT
`Discount Range`,
COUNT(*) AS Product_count,
ROUND(AVG(`rating`), 2) AS average_rating,
ROUND(AVG(`review_count_clean`), 2) AS average_reviews
FROM amazon_products
WHERE `Discount Range` IS NOT NULL
GROUP BY `Discount Range`
ORDER BY average_reviews DESC; 


-- ==========================================================
-- FINAL SQL SUMMARY
-- AMAZON PRODUCT SALES & CUSTOMER ENGAGEMENT ANALYSIS
-- ==========================================================

-- 1. DATA QUALITY
-- Total records: 41,650
-- Duplicate Product URLs: 1,044
-- Key missing values: Missing values were identified in Product Title,Rating, Review Count,
-- Monthly Purchase,Current Price, Variant Price, and Listed Price.

-- ===============================================================
# PRODUCT PERFORMANCE
-- ===============================================================
-- Average product rating: 4.39
-- Total customer reviews: 123, 176, 576
-- Average reviews per product: 2,958.97
-- Average monthly purchase estimate: 895.72

-- ================================================================
-- 3. PRICING
-- =================================================================

-- Average current price: 218.17
-- Minimum current price: 2.49
-- Maximum current price: 4699
-- Strongest price range: $0-$99

-- ===============================================
-- 4. DISCOUNT
-- ================================================

-- Average discount percentage: 0.22
-- Most common discount range: 10%-19%
-- Highest-engagement discount range: 10%-19%

-- ====================================================
-- 5. MARKETPLACE PERFORMANCE
-- =====================================================

-- Best Seller product count: 275
-- Sponsored product count: 6,233
-- Coupon-enabled product count: 1,948
-- Buy Box available product count: 27,158
-- Sustainability badge product count: 3,408

-- ========================================================
-- 6. CUSTOMER ENGAGEMENT
-- =========================================================

-- Rating with highest average reviews:
-- Best Seller vs Non-Best Seller performance:
-- Highest-engagement rating category:

-- ===============================================================
-- 7. PRODUCT SEGMENTATION
-- ===============================================================

-- Rating categories:
-- Excellent: 4.5+
-- Good: 4.0–4.49
-- Average: 3.0–3.99
-- Poor: Below 3.0

-- Review categories:
-- Low: Below 100
-- Medium: 100–999
-- High: 1,000–9,999
-- Very High: 10,000+

-- Price categories:
-- Budget: Below $100
-- Mid-Range: $100–$299
-- Premium: $300–$999
-- Luxury: $1,000+

-- ==============================================================
-- 8. ADVANCED ANALYSIS
-- ===============================================================
-- Number of above-average-price products: 7004
-- Number of above-average-rating products: 26603
-- Number of high-performing products: 2213
-- Number of potentially weak products: 8545

-- ===================================================================
-- 9. KEY BUSINESS INSIGHTS
-- =====================================================================

-- Insight 1:
-- The dataset contains 41,650 product records, with 1,044
-- duplicate Product URL records identified during validation.

-- Insight 2:
-- Products have an overall average rating of 4.39,
-- indicating generally strong customer ratings.

-- Insight 3:
-- The data set contains 123, 176, 576 total customer reviews,
-- indicating substantial customer engagement across the catlog.

-- Insight 4:
-- The average estimated monthly purchase volume is 895.72 per product.

-- Insight 5:
-- The average current product price is 218.17, providing 
-- a base line for comparing different price segements.

-- ==================================================================
-- 10. BUSINESS RECOMMENDATIONS
-- ===================================================================

-- Recommendation 1:
-- Focus on products that combine high rating, strong review
-- Volume, and high estimated monthly purchases.

-- Recommendation 2:
-- Compare price segements using rating, reviews, and purchases before making price decisions.

-- Recommendation 3:
-- Evaluate discount ranges based on customer engagement and 
-- estimated purchases rather than discount percentage alone.

-- Recommendation 4:
-- Investigate Best Seller Products to identify characteristics 
-- associated with stronger customer engagement and sales.