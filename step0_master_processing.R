
library(tidyverse)
library(rmarkdown)

start<-now()

#***IMPORTANT*** make sure you have opened the 'step1_ReadInDate.Rmd' file and completed the set up 
#instructions before running this master processing script

### Step 1 ----------
rmarkdown::render(input = 'step1_ReadInData.Rmd')

### Step 2 ----------------------
rmarkdown::render(input = 'step2_CreateIntermediateFiles.Rmd')

end<-now()

end-start

