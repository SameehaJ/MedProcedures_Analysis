# 🏥 Medical Procedure Insight Dashboard for Hospital Administrators

**Author:** Sameeha Jameel  
**Published:** May 15, 2025

---

## 📘 Project Overview

This project explores trends in medical procedures using synthetic electronic health records to design an interactive and insightful dashboard for hospital administrators. The dashboard is intended to answer key clinical and operational questions — such as who receives care, what procedures are most common, and how cost and demographics intersect.

**Tools Used:** SQL Server Management Studio (SSMS), Tableau Public

---

## 🗃️ About the Dataset

- **Source:** SyntheticMass by Synthea™ (open-source patient simulator by MITRE) (https://synthea.mitre.org/downloads)
- **Format:** 27 CSV files (project uses 3 core files)

### Key Files and Columns:

#### 1. `Patients.csv`
- `Id`, `Birthdate`, `Deathdate`
- `Gender`, `Race`, `County`, `State`

#### 2. `Encounters.csv`
- `Id`, `Start`, `Stop`, `Patient`

#### 3. `Procedures.csv`
- `Start`, `Stop`, `Patient`, `Encounter`
- `Description`, `Base_Cost`

---

## 🧮 SQL Data Preparation

### Step 1: Define Active Patients
```sql
WITH ActivePatients AS (
  SELECT DISTINCT Patient
  FROM Encounters AS Enc
  JOIN Patients AS Pat ON Enc.Patient = Pat.Id
  WHERE Start BETWEEN '2022-01-01' AND '2024-12-31'
  AND Pat.DeathDate IS NULL
)
```

### Step 2: Filter 2024 Procedures
```sql
Proceduresin2024 AS (
  SELECT Patient, Description, Base_Cost, ReasonDescription,
         CAST(Start AS DATE) AS StartDate,
         CAST(Stop AS DATE) AS StopDate
  FROM Procedures
  WHERE CAST(Start AS DATE) >= '2024-01-01'
    AND CAST(Stop AS DATE) <= '2024-12-31'
)
```

### Step 3: Combine with Patient Data
```sql
SELECT  
 Pat.Id, Pat.First, Pat.Last, Pat.Birthdate, 
 DATEDIFF(YEAR, Pat.Birthdate, '2024-12-31') AS Age, 
 Pat.Gender, Pat.Race, Pat.County,
 Prod.Description, Prod.Base_Cost, Prod.ReasonDescription,
 Prod.StartDate, Prod.StopDate, 
 CASE WHEN Prod.Patient IS NOT NULL THEN 1 ELSE 0 END AS Proceduresin2024
FROM Patients AS Pat
LEFT JOIN Proceduresin2024 AS Prod ON Pat.Id = Prod.Patient
WHERE Pat.Id IN (SELECT * FROM ActivePatients)
```

### Step 4: Export for Tableau
The final dataset was exported as `.xlsx` for use in Tableau Public.

---

## 📊 Tableau Dashboard Design

### Summary Dashboard – *"Medical Procedure Insights"*
Provides high-level metrics and visual trends.

#### Visual Elements:
- % of Active Patients with Procedures
- Patient Count by Gender
- Top Procedures Table (Top 12)
- Calendar Heatmap – Daily activity
- Monthly Trend Line – Procedures/month
- County-Level Map – Patient distribution
- Race Breakdown – % by race
- Age Segmentation – Age group bar chart

### Interactivity:
- Sidebar month filter
- Navigation buttons between dashboards
- Download buttons (PDF/image)

---

## 🗂️ Procedures Dashboard – *"Detailed Patient Records"*

### Visual Elements:
- Patient Full Name
- Gender and Age
- Procedure Date
- Procedure Description
- Procedure Cost

### Features:
- Multi-month filter
- Navigation button to Summary dashboard

---

## 🔍 Key Insights

### 1. High Procedure Rate
- 99.39% of patients received at least one procedure in 2024

### 2. Gender Balance
- Female: 48 (52.75%)  
- Male: 44 (48.35%)

### 3. Temporal Trends
- Peak procedure volume in **August**
- Lowest in **October**
- Highest weekday activity on **Fridays and Mondays**

### 4. Most Frequent Procedure
- **Depression screening** ranks as the most common

### 5. Inclusive Care Delivery
- High procedural coverage across all demographics

---

## 🧾 Final Thoughts

This dashboard blends operational oversight with detailed patient-level data, helping hospital leadership optimize resources while supporting transparency and inclusivity.
View dashboard at: https://public.tableau.com/app/profile/sameeha.jameel/viz/HospitalProcedures/HospitalProceduresDashboard
