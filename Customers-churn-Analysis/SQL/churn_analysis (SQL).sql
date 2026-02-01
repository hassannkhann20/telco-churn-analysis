-- Create database
create database churn_analysis;

-- Select the database where churn data is stored
USE churn_analysis;

-- Calculate overall customer churn rate

SELECT 
    COUNT(*) AS total_customers,                     -- Total customers
    
    SUM(
        CASE 
            WHEN churn = 'Yes' THEN 1                -- Count churned customers
            ELSE 0
        END
    ) AS churned_customers,
    
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
        2
    ) AS churn_rate_percentage                        -- Churn rate %

FROM customer_churn;

-- Analyze churn rate for each contract type

SELECT 
    contract_type,                                   -- Contract category
    
    COUNT(*) AS total_customers,                     -- Customers per contract
    
    SUM(
        CASE 
            WHEN churn = 'Yes' THEN 1                -- Churned customers
            ELSE 0
        END
    ) AS churned_customers,
    
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
        2
    ) AS churn_rate_percentage                       -- Churn %

FROM customer_churn
GROUP BY contract_type                               -- Group by contract
ORDER BY churn_rate_percentage DESC;                 -- Highest churn first

-- Identify risky payment methods based on churn

SELECT 
    payment_method,                                  -- Payment type
    
    COUNT(*) AS total_customers,
    
    SUM(
        CASE 
            WHEN churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,
    
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM customer_churn
GROUP BY payment_method
ORDER BY churn_rate_percentage DESC;

-- Analyze churn based on customer tenure length

SELECT 
    CASE 
        WHEN tenure_months < 12 THEN 'New Customers (<1 year)'
        ELSE 'Old Customers (>=1 year)'
    END AS customer_type,
    
    COUNT(*) AS total_customers,
    
    SUM(
        CASE 
            WHEN churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,
    
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM customer_churn
GROUP BY customer_type;

-- Check churn behavior of senior citizens

SELECT 
    senior_citizen,                                  -- 1 = Senior, 0 = Non-senior
    
    COUNT(*) AS total_customers,
    
    SUM(
        CASE 
            WHEN churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,
    
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM customer_churn
GROUP BY senior_citizen;

-- Identify high-paying customers who churned

SELECT 
    customer_id,
    monthly_charges,
    total_charges,
    contract_type
FROM customer_churn
WHERE churn = 'Yes'
ORDER BY total_charges DESC;


-- • Month-to-month contracts have the highest churn rate
-- • Customers with tenure < 1 year churn more
-- • Long-term contracts reduce churn significantly

