

# loading libs and setwd
library(readxl)
library(stringr)
library(stringi)
setwd('C:/Users/stanley/Desktop/MISCELLANEOUS R/nse-scrape/WSJ/file_dump')

# loading NSE data
nse_sec <- read_xlsx('C:/Users/stanley/Desktop/MISCELLANEOUS R/nse-scrape/Complete-List-of-Listed-Companies-on-Nairobi-Securities-Exchange-Jan-2020-Best.xlsx')
nse_sec <- nse_sec[-(66:71), -4]
nse_sec$Industry <- ifelse(test = nse_sec$Industry == 'Investment Services',
                           yes = 'Investment',
                           no = nse_sec$Industry)
colnames(nse_sec) <- c('Company Name', 'Ticker', 'Industry')

ticker_list <- nse_sec$Ticker
for (i in 1:length(ticker_list))
{
  a <- ticker_list[i]
  page <- str_c('https://www.wsj.com/market-data/quotes/KE/XNAI/',
                a,
                '/historical-prices/download?num_rows=100001&range_days=100000&endDate=01/01/2023') #mdy'
  filename <- str_c(a, '.csv')
  print(paste(a, ' : ', dim(df)[1]))
  
  download.file(page, destfile = filename, quiet=TRUE)
  
}



# 'https://www.wsj.com/market-data/quotes/KE/XNAI/SCOM/historical-prices/download?num_rows=10001&range_days=10000&endDate=11/10/2021'




