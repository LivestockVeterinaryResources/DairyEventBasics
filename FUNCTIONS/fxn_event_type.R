library(tidyverse)

fxn_event_type<-function(df){
  
  standard<-read_csv('Data/StandardizationFiles/standardize_event_type.csv', 
                     col_types = cols(.default = col_character()))%>%
    select(-count)
  
  
  df%>%
    #define event types------------------------------------
  left_join(standard)
}

# fxn_EVT_type<-function(df){
#   df%>%
#     #define event types------------------------------------
#   mutate(EVT_type = case_when(
#     Event %in% c("ABORT","BRED", "BULLPEN", "FMARTIN", "GNRH", "HEAT", "MV2AI", 
#                  "OK",      "OPEN", "PREG", "PREV", "PROST", "RECHK" )~'repro', 
#     Event %in% c ("ASSIST", "BLOAT", "DIPTHRA", "FEVER", "HLTHSCR", "ILLMISC", "INDIG", "INJURY", 
#                   "LAME", "MAST", "NAVEL", "OTHER","OTITIS",  "PINKEYE", "PNEU", "RP", 
#                   "SCOURS",  "SEPTIC", "SWLNLEG")~'health', 
#     Event %in% c("ARVDPOT", "DNB", "DRY", "GOAMISH", "GODEER", "GOHOME",  "MOVE")~'mgmt', 
#     Event %in% c("ARVKDD", "BEEF", "DIED", "FRESH", "SOLD")~'param', 
#     Event %in% c("INWEIGH", "MEASURE", "TP")~'measure',
#     Event %in% c("CHECK", "CHKDBN", "CLFSERU", "COMMENT", "INV",  "OBSERVE", "TBTEST",  
#                  "TRIAL", "USER6", "USER7",  "XID", "ZPRBRED")~'ask', 
#     Event %in% c("BANGVAC", "VACC")~'vac', 
#     TRUE~'Unknown'
#   ))
# }