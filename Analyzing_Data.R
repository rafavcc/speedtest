# Let's check the content and some stats of the tiles imported
summary (tiles_sp)
# Create temporary variable to check Chart Correlation
tiles_sp_numeric = tiles_sp%>% select(avg_d_kbps, avg_u_kbps, tests, devices) %>% st_drop_geometry()
chart.Correlation(tiles_sp_numeric, histogram = TRUE, pch = 19)

# From the histogram, we see that :
# 1 - avg_d_kbps e avg_u_kbps have a high correlation, # so we can infer that in places with good download, there is also good upload rates.
# 2 - Very high correlation of tests and devices indicate is expected, since
# devices are needed to perform the tests.
# 3 - A very high frequency of small number of all the variables. Let's dive into this analysis

# Checking data for avg_d_kbps. 
summary(tiles_sp$avg_d_kbps)
quantile(tiles_sp$avg_d_kbps, probs = c(0.01, 0.05, 0.25, 0.5, 0.75, 0.95, 0.99))
boxplot(tiles_sp$avg_d_kbps)
ggplot(tiles_sp, aes(x = avg_d_kbps)) + geom_histogram(bins = 100, fill = "gray", color = "black") + scale_x_continuous(breaks = seq(0,max(tiles_sp$avg_d_kbps),by = 100))

# Initial takes
# Percentile 99 is very far from Max
# Lots of Outliers and very frequent low values
# Something is OFF, need to investigate further.
# Let's investigate the tests variable
 
summary(tiles_sp$tests)
quantile(tiles_sp$tests, probs = c(0.01, 0.05, 0.25, 0.5, 0.75, 0.95, 0.99))
boxplot(tiles_sp$tests)
ggplot(tiles_sp, aes(x = tests)) + geom_histogram(bins = 60, fill = "gray", color = "black") + scale_x_continuous(breaks = seq(0,max(tiles_sp$avg_d_kbps),by = 20))

# Initial takes
# Percentile 99 is very, very far from Max
# There are a lot of tiles with few measures (1, 2, 3...)
# Since this data is collected during three months, this data can be impacted
# due to external conditions (transmission problems, availability of Ookla servers, and others.)
# Let's investigate the Coefficient of Variation of the feature avg_d_kbps and
# see how it varies for each number of tests

storage = tibble()
for (i in 1:309) {
  temp = filter(tiles_sp, tests == i)
  a = sd(temp$avg_d_kbps)/mean(temp$avg_d_kbps)
  storage = storage %>%  bind_rows(tibble(Testes = i, Variabilidade = a))
}
ggplot(storage) + geom_col(aes(x = storage$Testes, y = Variabilidade )) + 
  scale_x_continuous(breaks = seq(from = 0, to = max(storage$Testes), by = 10 ))

# Zooming in, x in range from 1 to 10
ggplot(storage) + geom_col(aes(x = storage$Testes, y = Variabilidade )) + 
  scale_x_continuous(limits = c(0,11), breaks = seq(1, 11, by = 1))

# Let's calculate the percentage of outliers
q1 = quantile(tiles_sp$avg_d_kbps, probs = 0.25)
q2 = quantile(tiles_sp$avg_d_kbps, probs = 0.50)
q3 = quantile(tiles_sp$avg_d_kbps, probs = 0.75)
iqr = q3 - q1
superior_limit = q3 + 1.5 * iqr
tiles_outliers = sum(tiles_sp$avg_d_kbps > superior_limit)
tiles_not_null = sum(tiles_sp$avg_d_kbps > 0)
tiles_outliers / tiles_not_null
# 1,7% of sample of outliers.

# Moving on with the analysis, we will count how many antennas are inside each
# of the tiles. For that, I will use st_intersects and I'll add the value to 
# tiles_sp

resultssites <- st_intersects(tiles_sp, antennas)
sites_per_tile <- lengths(resultssites)

# One possible approach here is to use the st_buffer function, to create
# a circular buffer around the site, as a "area of influence" of the site.
# This buffer is a circle with radius of 250m (diameter = 500m)
# I'll save it similarly as the sites_per_tile
buffer_500 <- st_buffer(antennas_sp, dist = 500)
result_buffer_500 <- st_intersects(tiles_sp, buffer_500)
buffer_500_per_tile <- lengths(result_buffer_500)

# Analyzing the result
summary(buffer_500_per_tile)
hist(buffer_500_per_tile,breaks = 75)
boxplot(buffer_500_per_tile)
quantile(buffer_500_per_tile, probs = c(0.01, 0.05, 0.25, 0.5, 0.75, 0.95, 0.99))
skim(buffer_500_per_tile)

# Analyzing the result
summary(sites_per_tile)
hist(sites_per_tile,breaks = 75)
boxplot(sites_per_tile)
quantile(sites_per_tile, probs = c(0.01, 0.05, 0.25, 0.5, 0.75, 0.95, 0.99))
skim(sites_per_tile)
# Surprinsingly many tiles doesn't have at no site at all

# Now let's add both variables to out tiles database
tiles_sp <- tiles_sp %>% add_column(sites_per_tile)
tiles_sp <- tiles_sp %>% add_column(buffer_500_per_tile)

# Let's see how the new variable created relates with the previous ones
tiles_sp_numeric = 
  tiles_sp %>% 
  select(avg_d_kbps, avg_u_kbps, tests, devices, sites_per_tile, buffer_500_per_tile) %>% 
  st_drop_geometry()
chart.Correlation(tiles_sp_numeric, histogram = TRUE, pch = 19)
# Analysis:
# There is a very low positive correlation between avg_d_kbps and both
# sites_per_tile and buffer_500_per_tile. It indicates that the data rates
# observed by the users is not directly related to the number of antennas
# in the area.
# On the other hand, there is a high correlation between the number of sites (and the buffer too) and the number of devices/tests in the area. This shows that, in places with good coverage, users are more prompted to perform tests to verify their performance.
# 
# Now, let's do a quick linear regression to check if it's possible to develop a model for avg_d_kbps in terms of sites
# 
# 
modelo = lm(data = tiles_sp_numeric, avg_d_kbps ~ sites_per_tile)
summary(modelo)
tiles_sp <- tiles_sp %>% add_column(avg_d_kbps_predicted = modelo$fitted.values)
rmse(data = tiles_sp, truth = avg_d_kbps, estimate = avg_d_kbps_predicted)


# Final words
# 
# Test F shows us that at least one variable can be used to estimate avg_d_kbps, and the sites_per_tile variable has a p-value from the t-distribution that could be used to estimate y. Sadly, the R-squared metric for this model is very low, close to 0.05, meaning it is not enough to make a good estimation of y (avg_d_kbps). Additionally, RMSE for this model is 137, which is more than half of the mean of avg_d_kbps, further indicating that the model lacks predictive power.
#
# One interesting fact we have observed from this analysis is that while the number of sites per tile does not strongly predict average download speed, it does have a high correlation with the number of tests performed. This suggests that:
# *	More antennas correlate with more users, which naturally leads to more speed tests.
# *	Users might be more inclined to test in high-coverage areas due to expectations of better performance.
# *	Congested areas with fluctuating speeds might prompt users to run more tests.
# *	Network expansions or upgrades might trigger more speed tests.

# These findings highlight the complexity of mobile network performance, where infrastructure density does not directly translate to better speeds, but rather to higher user engagement and network utilization. Further investigation into factors such as spectrum allocation, backhaul capacity, and real-time congestion metrics would be necessary to develop a more reliable predictive model for download speeds.