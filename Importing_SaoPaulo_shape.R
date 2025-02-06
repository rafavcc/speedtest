# Read São Paulo city shape from file using read_sf method
# Transform it into LAT and LON 
shp_sp <- read_sf("SP_Municipios_2023/SP_Municipios_2023.shp") %>% st_transform(4326)
shp_sp <- shp_sp %>% filter(CD_MUN == "3550308")

ggplot(shp_sp) + # Verify that São Paulo city map is correctly shown
  geom_sf(fill = "lightgray", color = "black", linewidth = 0.9) + 
  theme_minimal() +  # Clean background
  labs(
    title = "São Paulo City Map",
    caption = "Data Source: IBGE | Visualization: ggplot2"
  ) +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title = element_blank(),  # Remove axis titles
    axis.text = element_text(size = 10),  # Increase axis label size
  )
