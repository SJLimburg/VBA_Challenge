# VBA_Challenge
VBA homework for GT BC Data Science - Shirley Limburg

This Stock Report Summarizes daily stock data for each year of 2014, 2015 and 2016

This VBA scxript requires that the data be sorted specifically by Ticker symbol and date of the stock metrics.
As such the script assumes the first row of data for each ticker is the opening day.
The last row for the specific ticker is the last day of the year

This script assumes the given data is accurate and does not validate for accuracy.
A check exists for a zero opening price to avoid divide by zero errors in calculating the percent change in the price for the year.
The checker sets the percent change to zero. There may be other ways to report this. 
in this dataset the daily values were zeroes and in reality no stock opens with a zero opening price.
If this were a production report that data set would have been flagged to send to an error bucket for futher evaluation.

For each of the 3 years the stocks with the greatest percentage increase, greatest percentage decrease and greatest total volume of trades was reported along with the values.
