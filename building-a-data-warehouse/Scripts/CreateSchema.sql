CREATE TABLE "Dim_Gear"
(
    "Id"       INTEGER PRIMARY KEY,
    "GearType" VARCHAR,
    "GearName" VARCHAR
);

CREATE TABLE "Dim_Fishing_Sector"
(
    "Id"                INTEGER PRIMARY KEY,
    "FishingSectorName" VARCHAR
);

CREATE TABLE "Dim_Commercial_Group"
(
    "Id"                  INTEGER PRIMARY KEY,
    "CommercialGroupName" VARCHAR
);

CREATE TABLE "Dim_Functional_Group"
(
    "Id"                  INTEGER PRIMARY KEY,
    "FunctionalGroupName" VARCHAR
);

CREATE TABLE "Dim_End_Use_Type"
(
    "Id"             INTEGER PRIMARY KEY,
    "EndUseTypeName" VARCHAR
);

CREATE TABLE "Dim_EEZ"
(
    "Id"             INTEGER PRIMARY KEY,
    "EEZ"            INTEGER,
    "EEZName"        VARCHAR,
    "EEZAltName"     VARCHAR,
    "HDICountryName" VARCHAR
);

CREATE TABLE "Dim_Taxon"
(
    "Id"         INTEGER PRIMARY KEY,
    "Phylum"     VARCHAR,
    "Class"      VARCHAR,
    "Order"      VARCHAR,
    "Family"     VARCHAR,
    "Genus"      VARCHAR,
    "Species"    VARCHAR,
    "CommonName" VARCHAR
);

CREATE TABLE "Dim_Year"
(
    "Id"   INTEGER PRIMARY KEY,
    "Year" INTEGER
);

CREATE TABLE "Dim_HDI"
(
    "Id"             INTEGER PRIMARY KEY,
    "HDICountryName" VARCHAR,
    "HDIYear"        INTEGER, -- In lieu of effective start/end, since all data in this DW is year-based
    "HDICurrent"     BOOLEAN,
    "HDI"            REAL
);

CREATE VIEW "Dim_HDI_Current" AS
SELECT
    *
FROM
    "Dim_HDI"
WHERE
    "HDICurrent" IS TRUE
;

CREATE TABLE "Fact_Catch"
(
    "Id"                INTEGER PRIMARY KEY,
    "YearId"            INTEGER REFERENCES "Dim_Year" ("Id"),
    "EEZId"             INTEGER REFERENCES "Dim_EEZ" ("Id"),
    "TaxonId"           INTEGER REFERENCES "Dim_Taxon" ("Id"),
    "FunctionalGroupId" INTEGER REFERENCES "Dim_Functional_Group" ("Id"),
    "CommercialGroupId" INTEGER REFERENCES "Dim_Commercial_Group" ("Id"),
    "FishingSectorId"   INTEGER REFERENCES "Dim_Fishing_Sector" ("Id"),
    "GearId"            INTEGER REFERENCES "Dim_Gear" ("Id"),
    "EndUseTypeId"      INTEGER REFERENCES "Dim_End_Use_Type" ("Id"),
    "HDIId"             INTEGER, -- To the Dim_HDI_Current view
    "HDIIdHistorical"   INTEGER REFERENCES "Dim_HDI" ("Id"),
    "CatchWeight"       REAL,
    "ExVesselValue"     REAL
);

CREATE TABLE "Raw_Fact"
(
    "source_file"       VARCHAR,
    "area_name"         VARCHAR,
    "area_type"         VARCHAR,
    "data_layer"        VARCHAR,
    "uncertainty_score" VARCHAR,
    "year"              VARCHAR,
    "scientific_name"   VARCHAR,
    "common_name"       VARCHAR,
    "functional_group"  VARCHAR,
    "commercial_group"  VARCHAR,
    "fishing_entity"    VARCHAR,
    "fishing_sector"    VARCHAR,
    "catch_type"        VARCHAR,
    "reporting_status"  VARCHAR,
    "gear_type"         VARCHAR,
    "end_use_type"      VARCHAR,
    "tonnes"            VARCHAR,
    "landed_value"      VARCHAR
);
