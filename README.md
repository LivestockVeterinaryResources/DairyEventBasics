# DairyEventBasics

The goal of this is to streamline initial data processing so that more time can be spent acting on conclusions from data rather than processing it.  The example code below pulls 5 years of data in order to have the opportunity to look at trends over at least 3 years with complete lactations for most cows.  However, depending on what you want to look at, a shorter time frame may be utilized.

Step 1 - Pull the data
We need the following items from Dairy Comp along with the columns always generated with an events2 command in DC305
"ID"         "PEN"        "REG"        "EID"        "CBRD"      
"BDAT"       "EDAT"       "LACT"       "RC"         "HDAT"      
"FDAT"       "CDAT"       "DDAT"       "PODAT"      "ABDAT"     
"VDAT"       "ARDAT"      "Event"      "DIM"        "Date"      
"Remark"     "R"          "T"          "B"          "Protocols" 
"Technician"

Pull events from dairy comp using one option from the code below. 

Option 1 Pull 5 years in one file: 
EVENTS\2S2000C #1 #2 #4 #5 #6 #11 #12 #13 #15 #28 #29 #30 #31 #32 #38 #40 #43

Option 2 pull smaller time frames using "days back" starting with "S""days back" and ending with "L""days back": 
EVENTS\2S99L0C #1 #2 4 #5 #6 #11 #12 #13 #15 #28 #29 #30 #31 #32 #38 #40 #43


Step 2 - Open the file names "step0_MasterProcessing.Rmd" in Rstudio.  Run the file.

