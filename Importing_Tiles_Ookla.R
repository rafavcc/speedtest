# Import Mobile Tiles from Ookla Database. Date = 01-Oct-2024
tiles  <- read_sf("2024-10-01_performance_mobile_tiles/gps_mobile_tiles.shp") %>% st_transform(4326)
tiles_sp <- st_intersection(mobile_tiles,shp_sp) # Select only those inside SP city contour
tiles_sp <- tiles_sp %>% select(quadkey, avg_d_kbps, avg_u_kbps, tests, devices, geometry)
# Transform kbps into mbps
tiles_sp$avg_d_kbps <-  tiles_sp$avg_d_kbps / 1000
tiles_sp$avg_u_kbps <-  tiles_sp$avg_u_kbps / 1000

# Check SP tiles and contour
ggplot() + 
  geom_sf(data = shp_sp, fill = "lightgray", color = "black", linewidth = 0.7) +  # São Paulo city
  geom_sf(data = tiles_sp, color = "red", size = 2, alpha = 0.1) + # Tiles sites in red
  scale_x_continuous(labels = scales::label_number()) +  
  scale_y_continuous(labels = scales::label_number()) +
  labs(
    title = "São Paulo City Map with Ookla Tiles",
    caption = "Data Source: IBGE and Ookla | Visualization: ggplot2 "
  ) + theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.text = element_text(size = 10)
  )