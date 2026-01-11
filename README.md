  🚗 Motor Insurance Claims Analysis
  
📘 Introduction

Vehicle insurance companies face continuous challenges in managing claim risks, controlling payouts, and designing profitable policy products.

This project analyses vehicle insurance policy and claims data to understand why claims occur, identify high-risk segments, and uncover key drivers influencing claim payouts.

The analysis combines structured insurance data with SQL-based analytics and Power BI dashboards to generate actionable, business-focused insights for risk management and decision-making.

________________________________________


🎯 Objectives


The key objectives of this analysis are:


• To analyse overall insurance claim trends across the portfolio

• To examine claim patterns by insurance type, vehicle type, and vehicle usage

• To understand the impact of engine type, vehicle capacity, and manufacturer on claim amounts

• To identify high-risk policyholder and vehicle segments

• To provide data-driven recommendations that can help insurers reduce claim losses and improve risk management

________________________________________


🗂️ Dataset and Context


One primary dataset was used:


Motor Insurance Dataset (motordata.csv)

The dataset contains policy- and vehicle-level information such as:

• Policy Details: Insurance Type, Insurance Begin Date, Insurance End Date

• Policy Holders: Gender, Policyholder ID

• Vehicle Information: Vehicle Type, Manufacturer, Engine Type, Carrying Capacity, CCM/Ton

• Vehicle Usage: Usage Category

• Claims: Claim Paid Amount

Each row represents one insured vehicle policy record.

________________________________________


🧰Tools Used


The analysis was carried out using:


SQL

o Data cleaning and transformation

o Claim and policy aggregations

o CTEs, CASE statements, and business-rule logic

Power BI

o Interactive dashboards

o KPI visualization and business storytelling

CSV / Excel

The SQL script and dashboard are included for reproducibility.

________________________________________


🧹 Data Preparation


The following data preparation steps were undertaken:

• Cleaned and standardized insurance and vehicle data fields

• Created derived columns such as policy duration and vehicle capacity segments

• Converted categorical variables for analytical grouping

• Built a star-schema data model for optimized reporting

• Created a date table to enable time-based claim trend analysis

• Validated claim paid fields and filtered null or invalid records

• Aggregated data to compute insurance-type and vehicle-level claim rates


________________________________________


📊 Key Findings



• Certain vehicle types and usage categories show significantly higher claim payouts, indicating elevated risk exposure

• High-capacity and heavy-engine vehicles are associated with higher average claim amounts

• Commercial usage vehicles demonstrate higher claim frequency compared to private usage

• Specific manufacturers show above-average claim costs, suggesting risk-pattern differences

• Policy duration and insurance type influence claim probability and payout size

________________________________________


📈 Dashboard Insights


The Power BI dashboard provides:

• Overall claim KPIs

• Claim distribution by insurance type and vehicle type

• Vehicle usage vs claim frequency analysis

• Manufacturer-wise claim comparison

• Time-based claim trend analysis

• Filters for deep-dive exploration

________________________________________


💬 Conclusion and Insights


• The analysis shows that vehicle characteristics and usage patterns are major drivers of insurance claim risk.

• Commercial and high-capacity vehicles carry higher claim exposure.

• Certain vehicle types and manufacturers require closer underwriting attention.

• Insurance type and policy structure significantly influence claim costs.

• Risk-based segmentation can improve pricing accuracy and reduce losses.
________________________________________


💡 Strategic Recommendations


• Risk-Based Premium Pricing: Adjust premiums based on vehicle type, capacity, and usage risk

• Targeted Risk Monitoring: Flag high-risk vehicle categories for proactive claim control

• Policy Design Optimization: Revisit coverage terms for high-claim insurance types

• Manufacturer Risk Profiling: Use claim history to guide underwriting decisions

• Claim Forecasting Models: Implement predictive analytics using historical claim patterns 
________________________________________


🎯 Expected Business Impact


• Reduced unexpected claim payouts

• Improved risk-based pricing accuracy

• Better underwriting and portfolio risk management

• Enhanced profitability for insurance operations
