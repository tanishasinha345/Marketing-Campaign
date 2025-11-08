-- 1.1 Create DB
CREATE DATABASE IF NOT EXISTS marketing;
USE marketing;

-- 1.2 Campaign master table
CREATE TABLE IF NOT EXISTS campaigns (
  campaign_id INT AUTO_INCREMENT PRIMARY KEY,
  campaign_name VARCHAR(255),
  channel VARCHAR(100),
  start_date DATE,
  end_date DATE,
  budget DOUBLE
);

-- 1.3 User exposure & outcome
CREATE TABLE IF NOT EXISTS campaign_users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  campaign_id INT NOT NULL,
  exposed_date DATE,
  converted TINYINT(1) DEFAULT 0,   -- 0=no, 1=yes
  revenue DOUBLE DEFAULT 0,
  FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- Insert sample campaigns
INSERT INTO campaigns (campaign_name, channel, start_date, end_date, budget) VALUES
('Campaign A', 'Email', '2025-08-01', '2025-08-15', 10000),
('Campaign B', 'Social Media', '2025-08-01', '2025-08-15', 12000);

-- Insert sample exposures
INSERT INTO campaign_users (user_id, campaign_id, exposed_date, converted, revenue) VALUES
(101, 1, '2025-08-02', 1, 50),
(102, 1, '2025-08-03', 0, 0),
(103, 2, '2025-08-02', 1, 70),
(104, 2, '2025-08-03', 0, 0);

-- 2.1 Conversion rate per campaign
SELECT c.campaign_id, c.campaign_name,
       COUNT(*) AS total_users,
       SUM(converted) AS total_conversions,
       ROUND(SUM(converted)/COUNT(*), 3) AS conversion_rate
FROM campaign_users cu
JOIN campaigns c ON cu.campaign_id = c.campaign_id
GROUP BY c.campaign_id, c.campaign_name;

-- 2.2 Revenue vs. budget (ROI)
SELECT c.campaign_id, c.campaign_name,
       SUM(cu.revenue) AS total_revenue,
       c.budget,
       ROUND((SUM(cu.revenue) - c.budget)/c.budget, 2) AS roi
FROM campaign_users cu
JOIN campaigns c ON cu.campaign_id = c.campaign_id
GROUP BY c.campaign_id, c.campaign_name;

-- 2.3 Data export for Python
SELECT cu.user_id, cu.campaign_id, c.campaign_name, cu.converted, cu.revenue
FROM campaign_users cu
JOIN campaigns c ON cu.campaign_id = c.campaign_id;

