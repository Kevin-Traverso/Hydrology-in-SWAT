
# HYDROLOGICAL SIMULATION IN SWAT

# Install/load required packages
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(SWATplusR)) devtools::install_github("chrisschuerz/SWATplusR")

# Inital parameters of the simulation -------------------------------------

Start_d <- "1981-01-01" # Simulation start date
End_d <- "2016-12-31"   # Simulation end date
Years_skip <- 1         # Years of warming
Time_step <- "m"        # Simulation time step
Sub_b <- c(1:154)       # Number of Sub-basins

# Model's txinout directory
Dir_tx <- "D:/04_TESIS_UNALM/04_Swat_Mantaro/03_Modelo/Modelo_uhm/Scenarios/Default/TxtInOut/"
# Process directory 
Run_path <- "./Swat_model/"

# Outputs variables
Outputs <- list(Flows <- define_output(file = "rch",
                                       variable = "FLOW_OUT",
                                       unit = Sub_b),
                Wyld <- define_output(file = 'sub', 
                                      variable = 'WYLD',
                                      unit = Sub_b),
                Evt <- define_output(file = 'sub',
                                     variable = 'ET',
                                     unit = Sub_b))

# Running simulation -------------------------------------------------------

Basic_sim <- run_swat2012(project_path = Dir_tx,
                          output = define_output(file = "rch",
                                                 variable = "FLOW_OUT",
                                                 unit = 20),
                          start_date = Start_d,
                          end_date = End_d,
                          output_interval = Time_step,
                          years_skip = Years_skip,
                          run_path = Run_path,
                          add_date = TRUE)


