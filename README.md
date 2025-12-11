# 🌾 Agriculture Yield Intelligence

A complete end-to-end agriculture analytics solution built using **SSIS**, **SSAS**, and **Power BI** to forecast crop yield, optimize irrigation, monitor soil health, and assess climate risks through a unified data warehouse and interactive dashboards.

---

## 🚀 Project Overview
This project delivers a scalable BI ecosystem that integrates multi-source agricultural data — including soil telemetry, irrigation logs, pest incidents, field operations, and yield outcomes — to enable data-driven decision-making for farm management and climate resilience.

---

## 🛠 Tech Stack
- **SQL Server** – Data warehouse & star schema  
- **SSIS** – ETL pipelines (validation, SCD handling, surrogate keys)  
- **SSAS** – Multidimensional cubes with KPIs & aggregations  
- **Power BI** – Dashboarding & reporting  

---

## 📊 Data Warehouse Design
### **Fact Tables**
- Crop Yield  
- Irrigation  
- Soil Telemetry  
- Pest Incidents  
- Field Operations  

### **Dimension Tables**
- Farm, Field (SCD2), Region  
- Crop, Season  
- Soil Sensor, Pest, Severity  
- Irrigation Method, Action  
- DateTime (hourly & daily)

---

## 📦 SSAS Cubes
### **1️⃣ Yield & Profitability**
- Measures: Total Yield, Yield/ha, Input Cost  
- KPIs: Yield vs Target, Gross Margin %

### **2️⃣ Water & Irrigation Efficiency**
- Measures: Water Volume, Energy Use  
- KPIs: Application Efficiency, Water Intensity

### **3️⃣ Soil, Weather & Risk**
- Measures: Soil Moisture, EC Level, Pest Incidents  
- KPIs: Soil Moisture Compliance, Pest Risk Index

---

## 📈 Power BI Report Pages
1. **Farm Overview**  
2. **Yield & Forecast**  
3. **Water & Irrigation**  
4. **Soil & Climate Risk**  
5. **Field Operations Analysis**

Includes slicers (Region, Farm, Crop, Season) and RLS (Region Manager, Farm Manager, Corporate Access).

---

## 📁 Repository Structure

Agriculture_Yield_Intelligence/
│
├── PowerBI/
├── SSIS/
├── SSAS/
├── Datasets/
├── Documentation/
└── Screenshots/

---

## 🏁 How to Use
1. Run SSIS ETL to load all dimensions & facts.  
2. Deploy and process SSAS cubes.  
3. Open Power BI dashboard connected to the SSAS model.  
4. Interact with insights across yield, irrigation, soil, and operations.
