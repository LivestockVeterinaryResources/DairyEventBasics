library(tidyverse)

fxn_event_type_custom<-function(df){
  
  standard<-read_csv('Data/StandardizationFiles/standardize_event_type.csv', 
                     col_types = cols(.default = col_character()))%>%
    select(-count)
  
  
  df%>%
    #define event types------------------------------------
  select(-event_type)%>%
  left_join(standard)
}

fxn_event_type_default<-function(df){
  df%>%
    #define event types------------------------------------
  mutate(event_type = case_when(
    Event %in% c("ABORT","BRED", "BULLPEN", "GNRH", "HEAT", "LUT", "RECK",
                 "OK", "OPEN", "PREG", "PREV", "PROST", "PG", "DNB",
                 "CIDR")~'repro',
    Event %in% c ("ASSIST", "BLOAT", "DIPTHRA", "FEVER",  "ILLMISC", "INDIG", 
                  "INJURY", "MF", "DA", "METR", "KETOSIS",
                  "LAME", "MAST", "NAVEL", "OTHER", "OTITIS", "PINKEYE", "PNEU",
                  "RP",
                  "SCOURS",  "SEPTIC", "HARDWARE", "CULTURE", "FOOTTRIM", "TRIM", 
                  "TRIMONLY", "FOOTRIM")~'health',
    Event %in% c( "GOHOME",  "MOVE", "TOCLOSE". "TOGROWR")~'mgmt',
    Event %in% c("DIED", "FRESH", "SOLD", "DRY")~'param',
    Event %in% c("INWEIGH", "MEASURE", "TP")~'measure',
    Event %in% c("BANGVAC", "VACC")~'vac',
    TRUE~'Unknown'
  ))
}