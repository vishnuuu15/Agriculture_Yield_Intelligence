/*============================================================
   DATABASE: AgricultureDW
   PURPOSE : Agriculture Yield Intelligence & Climate Resilience
============================================================*/

-- 1️. Create Database
CREATE DATABASE AgricultureDW;
GO

-- 2️. Use the Database
USE AgricultureDW;
GO

/*============================================================
   DIMENSION TABLES
============================================================*/

-- DimRegion
CREATE TABLE DimRegion (
    RegionSK INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT NOT NULL,
    RegionName VARCHAR(100),
    ZoneType VARCHAR(20),
    ManagerName VARCHAR(100)
);

-- DimCrop
CREATE TABLE DimCrop (
    CropSK INT IDENTITY(1,1) PRIMARY KEY,
    CropID INT NOT NULL,
    CropName VARCHAR(60),
    CropType VARCHAR(40),
    MaturityDays INT
);

-- DimSeason
CREATE TABLE DimSeason (
    SeasonSK INT IDENTITY(1,1) PRIMARY KEY,
    SeasonID INT NOT NULL,
    SeasonName VARCHAR(40),
    StartMonth INT,
    EndMonth INT
);

-- DimIrrigationMethod
CREATE TABLE DimIrrigationMethod (
    IrrigationMethodSK INT IDENTITY(1,1) PRIMARY KEY,
    IrrigationMethodID INT NOT NULL,
    MethodName VARCHAR(40),
    EfficiencyPct DECIMAL(5,2)
);

-- DimPest
CREATE TABLE DimPest (
    PestSK INT IDENTITY(1,1) PRIMARY KEY,
    PestID INT NOT NULL,
    CommonName VARCHAR(80),
    Type VARCHAR(40),
    RiskSeasonality VARCHAR(80)
);

-- DimSeverity
CREATE TABLE DimSeverity (
    SeveritySK INT IDENTITY(1,1) PRIMARY KEY,
    SeverityID INT NOT NULL,
    SeverityLabel VARCHAR(20),
    ThresholdIndex INT
);

-- DimAction
CREATE TABLE DimAction (
    ActionSK INT IDENTITY(1,1) PRIMARY KEY,
    ActionID INT NOT NULL,
    ActionName VARCHAR(60),
    Notes VARCHAR(200)
);

-- DimOperationType
CREATE TABLE DimOperationType (
    OperationTypeSK INT IDENTITY(1,1) PRIMARY KEY,
    OperationTypeID INT NOT NULL,
    OperationTypeName VARCHAR(40)
);

-- DimInputMaterial
CREATE TABLE DimInputMaterial (
    InputMaterialSK INT IDENTITY(1,1) PRIMARY KEY,
    InputMaterialID INT NOT NULL,
    MaterialName VARCHAR(100),
    Category VARCHAR(40),
    Unit VARCHAR(20)
);

-- DimDateTime
CREATE TABLE DimDateTime (
    DateTimeSK INT IDENTITY(1,1) PRIMARY KEY,
    DateTimeID INT NOT NULL,
    [Date] DATE,
    [Hour] INT,
    [Day] INT,
    [Month] INT,
    [Year] INT,
    Quarter VARCHAR(2),
    WeekdayName VARCHAR(10),
    IsWeekend BIT,
    HolidayFlag BIT
);

-- DimFarm
CREATE TABLE DimFarm (
    FarmSK INT IDENTITY(1,1) PRIMARY KEY,
    FarmID INT NOT NULL,
    FarmName VARCHAR(120),
    OwnerName VARCHAR(120),
    RegionSK INT NOT NULL,
    SizeHectares DECIMAL(10,2),
    Status VARCHAR(20),
    FOREIGN KEY (RegionSK) REFERENCES DimRegion(RegionSK)
);

-- DimField
CREATE TABLE DimField (
    FieldSK INT IDENTITY(1,1) PRIMARY KEY,
    FieldID INT NOT NULL,
    FarmSK INT NOT NULL,
    FieldCode VARCHAR(40),
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6),
    SoilType VARCHAR(40),
    Irrigable BIT,
    EffectiveFrom DATE,
    EffectiveTo DATE,
    IsCurrent BIT,
    FOREIGN KEY (FarmSK) REFERENCES DimFarm(FarmSK)
);

-- DimSoilSensor
CREATE TABLE DimSoilSensor (
    SensorSK INT IDENTITY(1,1) PRIMARY KEY,
    SensorID INT NOT NULL,
    SensorCode VARCHAR(60),
    FieldSK INT NOT NULL,
    DepthCM INT,
    CommissionedDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (FieldSK) REFERENCES DimField(FieldSK)
);

/*============================================================
   FACT TABLES
============================================================*/

-- FactCropYield
CREATE TABLE FactCropYield (
    YieldRecordID INT PRIMARY KEY,
    FieldSK INT,
    FarmSK INT,
    RegionSK INT,
    CropSK INT,
    SeasonSK INT,
    DateTimeSK INT,
    AreaHectares DECIMAL(8,2),
    YieldTonnes DECIMAL(10,3),
    YieldPerHectare DECIMAL(10,3),
    MoisturePct DECIMAL(5,2),
    Grade VARCHAR(20),
    CreatedDate DATE,
    FOREIGN KEY (FieldSK) REFERENCES DimField(FieldSK),
    FOREIGN KEY (FarmSK) REFERENCES DimFarm(FarmSK),
    FOREIGN KEY (RegionSK) REFERENCES DimRegion(RegionSK),
    FOREIGN KEY (CropSK) REFERENCES DimCrop(CropSK),
    FOREIGN KEY (SeasonSK) REFERENCES DimSeason(SeasonSK),
    FOREIGN KEY (DateTimeSK) REFERENCES DimDateTime(DateTimeSK)
);

-- FactIrrigation
CREATE TABLE FactIrrigation (
    IrrigationEventID INT PRIMARY KEY,
    FieldSK INT,
    FarmSK INT,
    RegionSK INT,
    IrrigationMethodSK INT,
    DateTimeSK INT,
    VolumeM3 DECIMAL(12,2),
    DurationMinutes INT,
    EnergyKWh DECIMAL(10,2),
    SourceType VARCHAR(20),
    CreatedDate DATE,
    FOREIGN KEY (FieldSK) REFERENCES DimField(FieldSK),
    FOREIGN KEY (FarmSK) REFERENCES DimFarm(FarmSK),
    FOREIGN KEY (RegionSK) REFERENCES DimRegion(RegionSK),
    FOREIGN KEY (IrrigationMethodSK) REFERENCES DimIrrigationMethod(IrrigationMethodSK),
    FOREIGN KEY (DateTimeSK) REFERENCES DimDateTime(DateTimeSK)
);

-- FactSoilTelemetry
CREATE TABLE FactSoilTelemetry (
    SoilReadingID INT PRIMARY KEY,
    SensorSK INT,
    FieldSK INT,
    FarmSK INT,
    RegionSK INT,
    DateTimeSK INT,
    MoisturePct DECIMAL(5,2),
    TemperatureC DECIMAL(5,2),
    EC_dS_m DECIMAL(6,3),
    NPKIndex DECIMAL(6,2),
    BatteryPct DECIMAL(5,2),
    CreatedDate DATE,
    FOREIGN KEY (SensorSK) REFERENCES DimSoilSensor(SensorSK),
    FOREIGN KEY (FieldSK) REFERENCES DimField(FieldSK),
    FOREIGN KEY (FarmSK) REFERENCES DimFarm(FarmSK),
    FOREIGN KEY (RegionSK) REFERENCES DimRegion(RegionSK),
    FOREIGN KEY (DateTimeSK) REFERENCES DimDateTime(DateTimeSK)
);

-- FactPestIncidents
CREATE TABLE FactPestIncidents (
    PestIncidentID INT PRIMARY KEY,
    FieldSK INT,
    FarmSK INT,
    RegionSK INT,
    CropSK INT,
    PestSK INT,
    SeveritySK INT,
    DateTimeSK INT,
    AreaAffectedHectares DECIMAL(8,2),
    ActionTakenSK INT,
    FollowUpRequired BIT,
    CreatedDate DATE,
    FOREIGN KEY (FieldSK) REFERENCES DimField(FieldSK),
    FOREIGN KEY (FarmSK) REFERENCES DimFarm(FarmSK),
    FOREIGN KEY (RegionSK) REFERENCES DimRegion(RegionSK),
    FOREIGN KEY (CropSK) REFERENCES DimCrop(CropSK),
    FOREIGN KEY (PestSK) REFERENCES DimPest(PestSK),
    FOREIGN KEY (SeveritySK) REFERENCES DimSeverity(SeveritySK),
    FOREIGN KEY (ActionTakenSK) REFERENCES DimAction(ActionSK),
    FOREIGN KEY (DateTimeSK) REFERENCES DimDateTime(DateTimeSK)
);

-- FactFieldOperations
CREATE TABLE FactFieldOperations (
    OperationID INT PRIMARY KEY,
    FieldSK INT,
    FarmSK INT,
    RegionSK INT,
    CropSK INT,
    DateTimeSK INT,
    OperationTypeSK INT,
    InputMaterialSK INT NULL,
    Quantity DECIMAL(10,2),
    UnitCost DECIMAL(12,2),
    TotalCost DECIMAL(12,2),
    Operator VARCHAR(80),
    CreatedDate DATE,
    FOREIGN KEY (FieldSK) REFERENCES DimField(FieldSK),
    FOREIGN KEY (FarmSK) REFERENCES DimFarm(FarmSK),
    FOREIGN KEY (RegionSK) REFERENCES DimRegion(RegionSK),
    FOREIGN KEY (CropSK) REFERENCES DimCrop(CropSK),
    FOREIGN KEY (DateTimeSK) REFERENCES DimDateTime(DateTimeSK),
    FOREIGN KEY (OperationTypeSK) REFERENCES DimOperationType(OperationTypeSK),
    FOREIGN KEY (InputMaterialSK) REFERENCES DimInputMaterial(InputMaterialSK)
);
GO

-- =======================================================================

CREATE TABLE dbo.ETL_File_Log (
    File_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    File_Name VARCHAR(100) NOT NULL,
    File_Path VARCHAR(250) NULL,
    File_Type VARCHAR(50) NOT NULL, -- Example: 'CSV'
    File_Processed_Date_Time DATETIME NOT NULL DEFAULT (GETDATE()),
    File_Status VARCHAR(50) NOT NULL  -- Example: 'SUCCESS', 'FAILED', etc.
);

-- =======================================================================
