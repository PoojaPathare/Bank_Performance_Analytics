🏦Bank Performance Analytics: Capital Utilization & Profitability.

This repository evaluates bank performance against internal profitability benchmarks to determine whether financial targets are being met, capital is being efficiently utilized. It also analyzes Year-Over-Year performance using SQL and Power BI Dashboard.

📌 Project Overview:

Internal bank management requires a standardized, recurring method to evaluate financial success.

This project focuses on Profitability as the primary indicator of a branch's ability to operate within internal benchmarks and withstand RBI regulatory pressure. By analyzing how efficiently a branch utilizes its assets and equity, management can identify systemic risks before they affect the bank's overall stability.

📊 Benchmarking & Business Logic:

    Financial success is measured by the "Success Gap" distance between current performance and management-defined ranges.

    Net Interest Margin (NIM)3.0% – 3.5%Ability to generate income from lending vs. borrowing costs.

    Return on Assets (ROA)0.9% – 1.2%Efficiency of total asset utilization under regulatory norms.

    Return on Equity (ROE)12.0% – 15.0%The final measure of financial success for shareholders.


🏳️ Success Symbols & Business Logic:

   ⭐ Above Benchmark: Superior efficiency; highly resilient to regulatory/market pressure.

   ✅ Within Benchmark: Optimal utilization; performing well under current norms.

   ⚠️ Below Benchmark: Margin pressure detected; management intervention required to meet RBI norms.



🛠️ Technical Implementation & SQL Engineering:

1. SQL Stored Procedures for YoY Analysis:- To facilitate recurring annual reviews, I developed a Stored Procedure (YoY_Calculation) that automates the calculation of Year-over-Year (YoY) growth.
    
2. Data Modeling (Star Schema):- A high-performance Star Schema was designed to allow management to slice data by Fiscal Year, Region, and Branch.

3. Power BI Visualization:- Success Gap Analysis: Visualized using Gauge charts with dynamic "Target" lines. Trend Analysis: Dual Axis charts showing the indivisual metrics performance through out the fiscal year over every branch. YoY performance: KPI Cards showing Increase or decrease of metrics from previous year's metrics.


💡 Key Executive Insights: Strategic Capital Utilization:

🚀 The Growth Corridor (East & South)

► South Branch (Benchmark Leader): Achieved 100% compliance across all profitability targets.

Strategic Note: NIM remains the highest at over 3.5% (above the upper band). While currently peak, it is slightly below the previous year's performance, requiring a watch on interest rate spreads.

► East Branch (Momentum Leader): Successfully achieved positive growth (bps) across all KPIs compared to the previous fiscal year.

Efficiency Gap: Despite strong momentum, ROE remains slightly below the 12% target, necessitating continued equity optimization to maximize shareholder value.

⚠️ The Resilience Risk (Central & West)

► Central & West (The Trend Warning): Both branches are currently Within Benchmark, yet exhibited a significant downward trend (negative bps) across all metrics, with ROE trending toward the lower safety limit.

► Central Branch (Worst Performer): Flagged as a Critical Risk; all key metrics have entered negative growth territory, signaling a high probability of breaching RBI regulatory norms in the next cycle.

🏛️ Systemic Capital Oversight

► NIM Stability: Core lending operations remain healthy with bank-wide stability consistently within the 3.0%–3.5% threshold or above 3.5% threshold.

► ROE Deficiency: Marginal deficiencies across 80% of regional branches highlight a systemic need for optimized equity allocation to maintain long-term capital adequacy and regulatory compliance.
