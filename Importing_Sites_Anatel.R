# The ANATEL database can be obtained in the MOSAICO platform:
# https://sistemas.anatel.gov.br/se/public/view/b/licenciamento

# Now let's import the other dataset used in this work: The ANATEL database of
# Antennas
antennas <- read_csv(file ="csv/csv_licenciamento.csv", col_names = TRUE, col_types = cols(.default = "c") , locale = locale(encoding = "ISO-8859-1"))

# Let's take a look at the variables and verify which ones we are going to take
# for the analysis
names(antennas)
# Iremos selecionar as seguintes informações:
# NomeEntidade = Empresa detentora da Antena
# NumEstacao = Código identificador da Antena
# CodMunicipio = Código IBGE do município da antena
# Tecnologia = Tecnologia de Rede de Acesso da Antena (2G, 3G, 4G ou 5G)
# SiglaUf = UF do Brasil em que está localizada a Antena
# Latitude = Coordenada geográfica da Antena
# Longitude = Coordenada geográfica da Antena

# Now, let's use function select to maintain only the variables of interest
antennas <- antennas %>% select (NomeEntidade, NumEstacao, CodMunicipio, 
                                 Tecnologia, SiglaUf, Latitude, Longitude)

antennas$Latitude <- suppressWarnings(as.numeric(antennas$Latitude))
antennas$Longitude <- suppressWarnings(as.numeric(antennas$Longitude))
antennas$NumEstacao <- as.factor(antennas$NumEstacao)
antennas$CodMunicipio <- as.factor(antennas$CodMunicipio)

# Selecting only antennas belonging to Radio Access Network Technologies
antennas <- antennas %>% filter(Tecnologia %in% c("LTE", "NR", "WCDMA", "GSM"))

# Check let's action result
count(antennas,Tecnologia, sort = TRUE)

# Let's check for NA
anyNA(antennas)
skim(antennas)

# Now, let's tranform the antennas list into a SF (Simple Feature), so we can
# use it geographically
antennas <- st_as_sf(antennas, coords = c("Longitude", "Latitude") )
antennas <- st_set_crs(antennas, value = 4326)

# Removing the duplicates
antennas = antennas %>% distinct()

# Now, let's filter for Antennas with São Paulo City IBGE City Code
antennas_sp = filter(antennas, CodMunicipio == "3550308") 

# Geographically we can see that there are
# point outside São Paulo area perimeter.

antennas_sp %>% ggplot() + geom_sf() + 
  scale_x_continuous(labels = scales::label_number()) + 
  scale_y_continuous(labels = scales::label_number()) 

# Let's should remove them.
antennas_sp <- antennas_sp %>% filter(st_coordinates(geometry)[,2] > -24)
antennas_sp <- antennas_sp %>% filter(st_coordinates(geometry)[,1] > -47)

# Check SP tiles and contour
ggplot() + 
  geom_sf(data = shp_sp, fill = "lightgray", color = "black", linewidth = 0.7) +  # São Paulo city
  geom_sf(data = antennas_sp, color = "blue", size = 0.1, alpha = 0.1) + # Tiles sites in red
  scale_x_continuous(labels = scales::label_number()) +  
  scale_y_continuous(labels = scales::label_number()) +
  labs(
    title = "São Paulo City Map with Ookla Tiles",
    caption = "Data Source: IBGE and Ookla | Visualization: ggplot2 "
  ) + theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.text = element_text(size = 10)
  )

# Done!