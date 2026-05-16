library(ggplot2)
library(tidyr)

# Data
indikator <- c(
  "Ruang kelas nyaman",
  "Meja & kursi",
  "AC/Kipas",
  "Pencahayaan",
  "TV/LCD",
  "Laboratorium",
  "WiFi",
  "Kebersihan kelas",
  "Kebersihan toilet",
  "Area parkir",
  "Kepuasan keseluruhan"
)

naive <- c(0.607, 0.679, 0.214, 0.571, 0.536, 0.750, 0.607, 0.679, 0.500, 0.821, 0.750)

weighted <- c(0.637, 0.701, 0.253, 0.574, 0.552, 0.765, 0.449, 0.681, 0.767, 0.809, 0.765)

data <- data.frame(
  Indikator = indikator,
  Naive = naive,
  Weighted = weighted
)

# Ubah ke format long
data_long <- pivot_longer(data,
                          cols = c(Naive, Weighted),
                          names_to = "Metode",
                          values_to = "Nilai")

# Plot
ggplot(data_long, aes(x = Indikator, y = Nilai, fill = Metode)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Perbandingan Naïve vs Weighted Estimation",
       x = "Indikator Fasilitas",
       y = "Nilai Estimasi") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

