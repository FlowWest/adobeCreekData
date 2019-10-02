The export you requested contains 3 files with a prefix corresponding to the following data type:
GST - station (well) header data
GWL - groundwater level data
PERF - well perforation details 

The data files are in CSV-delimited format. Each file contains a header row 
describing the contents of the file.
The field descriptions for each file are given below:
*******************************************************************************
GST
        Field   Field Name              Description                             Data Type	 
        =====   ===========             ============================            =========	 
          1     site_code               Unique station identifier               Char
          2     state_well_nbr          State Well Number                       Char
          3     local_well_designation  Identifier used by local agency         Char
          4     latitude                station latitude, dec. degrees          Number
          5     longitude               station longitude, dec. degrees         Number
          6     basin_name              Groundwater basin of well               Char
          7     is_voluntary_reporting  Code (Y/N) indicating rept status       Char
          8     total_depth_ft          Total depth of well (if public)         Number
          9     well_use                Reported use of well                    Char

GWL
        Field   Field Name              Description                             Data Type	 
        =====   ===========             ============================            =========	 
          1     site_code          			Unique station Identifier               Char
          2     measurement_date        Measurement Date/Time                   Date (YYYY-MM-DD HH:MI:SS.S)
          3     rp_elevation            Reference Point Elevation               Number
          4     gs_elevation            Ground Surface Elevation                Number
          5     ws_reading              Water surface reading                   Number
          6     rp_reading              Reference point reading                 Number
          7     measurement_issue       Measurement problem code                Char
          8     agency_code             Measuring Agency Code                   Number
          9     comment                 Measurement Remarks                     Char

PERF
        Field   Field Name              Description                                   Data Type	 
        =====   ===========             ============================                  =========	 
          1     site_code          			Unique station Identifier                     Char
          2     perf_top_ft             Top of perfs depth for this interval          Number
          3     bottom_top_ft           Bottom of perfs depth for this interval       Number

*******************************************************************************
The horizontal datum for all coordinates is NAD83.
The vertical datum for all elevations is NAVD88.
All depth measurements are in feet.
*******************************************************************************
Please see the WDL web site for a key to the codes you find in the files
(http://www.water.ca.gov/waterdatalibrary/includes/Key_Codes_Abb_gw.cfm).
*******************************************************************************
If you encounter problems, find any errors, or have any suggestions,
please contact the WDL site administrator at wdlweb@water.ca.gov
Last updated 10/28/2013
*******************************************************************************

