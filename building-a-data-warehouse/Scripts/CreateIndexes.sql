-- Dimension Table Indexes
CREATE INDEX idx_dim_gear_id ON "Dim_Gear" ("Id");

CREATE INDEX idx_dim_fishing_sector_id ON "Dim_Fishing_Sector" ("Id");

CREATE INDEX idx_dim_commercial_group_id ON "Dim_Commercial_Group" ("Id");

CREATE INDEX idx_dim_functional_group_id ON "Dim_Functional_Group" ("Id");

CREATE INDEX idx_dim_end_use_type_id ON "Dim_End_Use_Type" ("Id");

CREATE INDEX idx_dim_eez_id ON "Dim_EEZ" ("Id");

CREATE INDEX idx_dim_taxon_id ON "Dim_Taxon" ("Id");

CREATE INDEX idx_dim_year_id ON "Dim_Year" ("Id");

CREATE INDEX idx_dim_hdi_id ON "Dim_HDI" ("Id");

-- Fact Table Indexes
CREATE INDEX idx_fact_catch_id ON "Fact_Catch" ("Id");
CREATE INDEX idx_fact_catch_yearid ON "Fact_Catch" ("YearId");
CREATE INDEX idx_fact_catch_eezid ON "Fact_Catch" ("EEZId");
CREATE INDEX idx_fact_catch_taxonid ON "Fact_Catch" ("TaxonId");
CREATE INDEX idx_fact_catch_functionalgroupid ON "Fact_Catch" ("FunctionalGroupId");
CREATE INDEX idx_fact_catch_commercialgroupid ON "Fact_Catch" ("CommercialGroupId");
CREATE INDEX idx_fact_catch_fishingsectorid ON "Fact_Catch" ("FishingSectorId");
CREATE INDEX idx_fact_catch_gearid ON "Fact_Catch" ("GearId");
CREATE INDEX idx_fact_catch_endusetypeid ON "Fact_Catch" ("EndUseTypeId");
CREATE INDEX idx_fact_catch_hdiid ON "Fact_Catch" ("HDIId");
CREATE INDEX idx_fact_catch_hdiidhistorical ON "Fact_Catch" ("HDIIdHistorical");
ALTER TABLE "Fact_Catch" ADD CONSTRAINT fact_catch_unique UNIQUE
(
    "Id",
    "YearId",
    "EEZId",
    "TaxonId",
    "FunctionalGroupId",
    "CommercialGroupId",
    "FishingSectorId",
    "GearId",
    "EndUseTypeId",
    "HDIId",
    "HDIIdHistorical"
)
;