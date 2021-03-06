# ========================================================================
#                      HYDROLOGICAL SIMULATION IN SWAT
# ========================================================================

'Hydrological simulation process using computational languaje R
applied to the Mantaro river basin in Perú.

Code developed for the Mg.Sc. thesis in Water Resources
Universidad Nacional Agraria la Molina

@autor: Kevin Arnold Traverso Yucra
mail: arnold.traverso@gmail.com'

# Install/load required packages -----------------------------------------

if(!require(tidyverse)) install.packages("tidyverse")
if(!require(SWATplusR)) devtools::install_github("chrisschuerz/SWATplusR")
if(!require(zoo)) install.packages("zoo")
if(!require(raster)) install.packages("raster")
if(!require(mapview)) install.packages("mapview")

# Inital parameters of the simulation -------------------------------------

Start_d <- "1981-01-01" # Simulation start date
End_d <- "2016-12-31"   # Simulation end date
Y_skip <- 1             # Years of warming
Time_step <- "y"        # Simulation time step
Sub_b <- c(1:154)       # Number of Sub-basins

# Model's txinout directory
Dir_tx <- "D:/04_TESIS_UNALM/04_Swat_Mantaro/03_Modelo/Modelo_uhm/Scenarios/Default/TxtInOut/"

# Process directory 
R_path <- "./Swat_model"

# Outputs variables
# the verables entered are the basic ones of the hydrological balance

varb <- list(Pcp = define_output(file = "sub", variable = "PRECIP", unit = Sub_b),
             Flow = define_output(file = "rch", variable = "FLOW_OUT", unit = Sub_b),
             Wyld = define_output(file = "sub", variable = "WYLD", unit = Sub_b),
             Sw = define_output(file = "sub", variable = "SW", unit = Sub_b),
             Et = define_output(file = "sub", variable = "ET", unit = Sub_b),
             Pet = define_output(file = "sub", variable = "PET", unit = Sub_b))

# Running simulation -------------------------------------------------------

Basic_sim <- run_swat2012(project_path = Dir_tx,
                          output = varb,
                          start_date = Start_d,
                          end_date = End_d,
                          output_interval = Time_step,
                          years_skip = Y_skip,
                          run_path = R_path,
                          add_date = TRUE, 
                          keep_folder = FALSE)

# Presenting results -------------------------------------------------------

Sub_res <- Basic_sim %>% dplyr::select(-date) %>%
  summarise_all(., .funs = mean) %>% 
  gather(.) %>% 
  mutate(Subbasin = gsub("[^[:digit:]]", "",key) %>% as.numeric(.),
         sb_comp = gsub("[^[:alpha:]]", "",key)) %>% 
  dplyr::select(Subbasin, sb_comp, value) %>% 
  spread(., key = sb_comp, value = value)

# Loading the shapefile of sub-basin and rivers

Shp_Sb <- shapefile(x = "./Shapefiles/DEM_UHM90mutmwshed.prj")
Shp_riv <- shapefile(x = "./Shapefiles/DEM_UHM90mutmnet.shp")

# merge simulated information to shapefiles

Shp_Sb <- merge(Shp_Sb, Sub_res, by = "Subbasin")

# Displaying ---------------------------------------------------------------

pcp <- mapview(Shp_Sb, zcol = "Pcp", col.regions = viridisLite::viridis)
wyld <- mapview(Shp_Sb, zcol = "Wyld", col.regions = viridisLite::inferno)
pt <- mapview(Shp_Sb, zcol = "Et", col.regions = viridisLite::cividis)
pet <- mapview(Shp_Sb, zcol = "Pet", col.regions = viridisLite::magma)

sync(pcp, wyld, pt, pet)
