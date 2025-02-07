# Import Mobile Tiles from Ookla Database. Date = 01-Oct-2024
tiles  <- read_sf("2024-10-01_performance_mobile_tiles/gps_mobile_tiles.shp") %>% st_transform(4326)
tiles_sp <- st_intersection(tiles,shp_sp) # Select only those inside SP city contour
tiles_sp <- tiles_sp %>% select(quadkey, avg_d_kbps, avg_u_kbps, avg_lat_ms, tests, devices, geometry)
tiles_sp$avg_d_kbps <-  tiles_sp$avg_d_kbps / 1000 # Considering kbps as mbps
tiles_sp$avg_u_kbps <-  tiles_sp$avg_u_kbps / 1000 # Considering kbps as mbps
