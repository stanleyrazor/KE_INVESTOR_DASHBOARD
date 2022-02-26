
# Fundamental data scraper ------------------------------------------------


page2 <- 'https://simplywall.st/stocks/ke/market-cap-large'
pp2 <- read_html(page2)

# successful
links <- pp2 %>%
  html_node('body') %>%
  xml2::xml_find_all("//a[contains(@class, 'sc-j2jiwi-0 sc-n7l64u-1 hxrYKN dGQEKd')]") %>%
  html_attr('href')

comp_names <- pp2 %>%
  html_node('body') %>%
  xml2::xml_find_all("//a[contains(@class, 'sc-j2jiwi-0 sc-n7l64u-1 hxrYKN dGQEKd')]") %>%
  html_text2()

index <- seq(from = 1, to = length(links), by = 2)
comp_names <- comp_names[index]
links <- links[index]

comp_ticker <- c('SCOM', 'EQTY', 'KCB', 'EABL', 'COOP', 'ABSA',
                 'SCBK', 'BAT', 'NCBA', 'SBIC', 'IMH', 'BKG', 'KEGN',
                 'JUB', 'BRIT', 'DTK', 'TOTL', 'BAMB', 'CTUM', 'KUKZ',
                 'NBV', 'KNRE', 'CIC', 'CRWN')
length(comp_ticker)



# scraping the data frames ------------------------------------------------

for (i in 20:length(links))
{
  message(comp_ticker[i])
  page <- str_c('https://simplywall.st', links[i])
  pp2 <- read_html(page)
  tt3 <- pp2 %>%
    html_node('section') %>%
    #xml2::xml_find_all("//table[contains(@class, 'sc-1ss47ks-0 sc-vximwt-0 jABhQK jsotaj')]") %>%
    html_table()
  
  hist_table <- tt3[7:16, 1:2] %>%
    t %>%
    data.frame()
  colnames(hist_table) <- hist_table[1, ]
  rownames(hist_table) <- 1:nrow(hist_table)
  hist_table <- hist_table[2, ]
  cc <- colnames(hist_table)
  cc[5:10] <- str_c(cc[5:10], '(%)')
  colnames(hist_table) <- cc
  hist_table[1, ] <- ifelse(hist_table[1, ] == 'n/a', NA, hist_table[1, ])
  hist_table[1, ] <- str_extract_all(hist_table[1, ], '[-.0123456789]') %>%
    stri_join_list() %>% 
    as.numeric()
  
  ### end
  
  
  
  ## volatility table
  vol_table <- tt3[21:25, 1:2] %>%
    t %>%
    data.frame()
  colnames(vol_table) <- c('Average Weekly Movement(%)',
                           'Industry Average Movement(%)',
                           'Market Average Movement(%)',
                           'Volatility for 10% most volatile stocks(%)',
                           'Volatility for 10% least volatile stocks(%)')
  rownames(vol_table) <- 1:nrow(vol_table)
  vol_table <- vol_table[2, ]
  vol_table[1, ] <- ifelse(vol_table[1, ] == 'n/a', NA, vol_table[1, ])
  vol_table[1, ] <- str_extract_all(vol_table[1, ], '[-.0123456789]') %>%
    stri_join_list() %>% 
    as.numeric()
  
  
  ##### income statement table
  income_table <- income_table2 <- tt3[c(29, 33:41), 1:2]
  income_table <- income_table %>%
    t %>%
    data.frame()
  colnames(income_table) <- c("Market Cap", "Revenue", "Cost of Revenue", "Gross Profit", 
                              "Expenses", "Earnings", "Earnings per share (EPS)",
                              "Gross Margin(%)", 
                              "Net Profit Margin(%)", "Debt/Equity Ratio(%)")
  rownames(income_table) <- 1:nrow(income_table)
  income_table <- income_table[2, ]
  #View(income_table)
  income_table[1, ] <- ifelse(income_table[1, ] == 'n/a', NA, income_table[1, ])
  income_table[1, ] <- str_extract_all(income_table[1, ], '[-.0123456789bt]') %>%
    stri_join_list()
  
  #####
  
  merged <- cbind(hist_table, vol_table, income_table)
  if (i == 1)
  {
    full_merged <- merged
  }
  else
  {
    full_merged <- rbind(full_merged, merged)
    
  }
  
  
}

rownames(full_merged) <- comp_ticker
write.csv(full_merged, 'fundamental_df.csv')

