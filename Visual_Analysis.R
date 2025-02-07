# In this file, I'll generate some visual analysis using R functions
# 
# GGPLOT + BOXPLOT = Boxplot of Download Speeds

ggplot(tiles_sp, aes(y = avg_d_kbps)) + 
  geom_boxplot(fill = "lightblue", color = "black") +
  labs(
    title = "Boxplot of Download Speeds",
    y = "Download Speed (kbps)"
  ) +
  theme_minimal()

# GGPLOT + SCATTER = Download Speed vs. Number of Tests
ggplot(tiles_sp, aes(x = tests, y = avg_d_kbps)) + 
  geom_point(alpha = 0.5, color = "blue") +
  labs(
    title = "Download Speed vs. Number of Tests",
    x = "Number of Tests",
    y = "Download Speed (kbps)"
  ) +
  theme_minimal()

# GGPLOT + GEOM_SF (Simple Feature) = Average Download Speeds Across São Paulo
# using Viridis
ggplot() + 
  geom_sf(data = shp_sp, fill = "gray", color = "black", linewidth = 0.7) +   geom_sf(data = tiles_sp, aes(fill = avg_d_kbps), color = NA) + 
  scale_x_continuous(labels = scales::label_number()) +  
  scale_y_continuous(labels = scales::label_number()) +
  scale_fill_viridis_c(option = "C", name = "Avg DL Rate (kbps)") +
  labs(
    title = "Average Download Speeds Across São Paulo",
    caption = "Source: IBGE and Ookla | Visualization: ggplot2"
  ) +
  theme_minimal() 

# GGPLOT + HISTOGRAM = Distribution of Download Speeds in São Paulo
ggplot(tiles_sp, aes(x = avg_d_kbps)) + 
  geom_histogram(bins = 50, fill = "blue", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Download Speeds in São Paulo",
    x = "Download Speed (kbps)",
    y = "Frequency"
  ) +
  theme_minimal()
