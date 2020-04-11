#' @title Time series of flows to SWATCUP
#' 
#' @description
#' 
#' Bring a time series of daily / monthly / annual flows
#' to the SWATCUP entry format
#' 
#' @param Q_obs Flow time series
#' @param Start_date  Starting date of time series
#' @param End_date End date of the time series
#' @param Time_step Pasage of time of series (daily, monthly, annual)
#' @param Name_station hydrological staton name
#' 
#' @author Kevin Arnold Traverso, \email {arnold.traverso@gmail.com}


Q_to_SwatCup <- function
(
  Q_obs,
  Start_date,
  End_date,
  Time_step,
  Name_station
){
  
  # stop when there is more than one time series
  if(NCOL(Q_obs)>1) stop("Q_obs must only be a series of flow")
  
  # Adjusting the time series to the desired dates
  Q_adj <- window(x = Q_obs,
                  start = Start_date,
                  end = End_date)
  
  # Deleting empty data
  Q_adj <- Q_adj[!is.na(Q_adj[, 1])]
  
  # Construction of the new data frame 
  df_sc <- data.frame(ID = 1:length(Q_adj),
                      FORMAT = paste0("FLOW_OUT_",
                                      format(index(Q_adj),
                                             ifelse(Time_step == "daily", "%j",
                                                    ifelse(Time_step == "monthly", "%m",
                                                           ifelse(Time_step == "annual", "%y",
                                                                  message("Passage of tieme of unspecified flow series"))))),
                                      "_",
                                      data.table::year(index(Q_adj))),
                      Q_OBS = coredata(round(Q_adj[, 3], 3)))
  
  # Saving the information
  write.csv(x = df_sc,
            file = paste0(getwd(), "/SwatCup_", Name_station, ".csv"),
            row.names = FALSE)
  # Sending a message
  cat(nrow(df_sc), "Is the total number of points!")
  
}
