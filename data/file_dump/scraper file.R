



library(stringr)
library(stringi)
setwd('C:/Users/stanley/Desktop/MISCELLANEOUS R/nse-scrape/WSJ/file_dump')
ticker_list <- nse_sec$Ticker
for (i in 1:length(ticker_list))
{
  a <- ticker_list[i]
  page <- str_c('https://www.wsj.com/market-data/quotes/KE/XNAI/',
                a,
                '/historical-prices/download?num_rows=10001&range_days=10000&endDate=01/07/2022')
  filename <- str_c(a, '.csv')
  print(paste(a, ' : ', dim(df)[1]))
  
  download.file(page, destfile = filename, quiet=TRUE)
  
}



# 'https://www.wsj.com/market-data/quotes/KE/XNAI/SCOM/historical-prices/download?num_rows=10001&range_days=10000&endDate=11/10/2021'





