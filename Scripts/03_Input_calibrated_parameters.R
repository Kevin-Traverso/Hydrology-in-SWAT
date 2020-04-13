# =========================================================================

# =========================================================================

# Install/load required packages -----------------------------------------

if(!require(tidyverse)) install.packages("tidyverse")
if(!require(SWATplusR)) devtools::install_github("chrisschuerz/SWATplusR")
if(!require(zoo)) install.packages("zoo")
if(!require(raster)) install.packages("raster")
if(!require(hydroGOF)) install.packages("hydroGOF")
if(!require(mapview)) install.packages("mapview")

# Inital parameters of the simulation -------------------------------------

Start_d <- "1981-01-01" # Simulation start date
End_d <- "2016-12-31"   # Simulation end date
Y_skip <- 1             # Years of warming
Time_step <- "m"        # Simulation time step
Sub_b <- c(1:154)       # Number of Sub-basins

# Model's txinout directory
Dir_tx <- "D:/04_TESIS_UNALM/04_Swat_Mantaro/03_Modelo/Modelo_uhm/Scenarios/Default/TxtInOut/"

# Process directory 
R_path <- "./Swat_model"

# 
par_cal <- tibble("EPCO.hru|change = absval"    = 0.863000,
                  "RCHRG_DP.gw|change = absval" = 0.149000,
                  "GW_DELAY.gw|change = absval" = 18.209999,
                  "SOL_AWC.sol|change = pctchg" = 5.400002,
                  "SOL_BD.sol|change = pctchg"  = -82.599998)

flows <- define_output(file = "rch", variable = "FLOW_OUT", unit = Sub_b)

# Calibrated simulation ---------------------------------------------------

Calib_sim <- run_swat2012(project_path = Dir_tx,
                          output = flows,
                          start_date = Start_d,
                          end_date = End_d,
                          output_interval = Time_step,
                          years_skip = Y_skip,
                          run_path = R_path,
                          add_date = F, 
                          keep_folder = FALSE)

Calib_sim






