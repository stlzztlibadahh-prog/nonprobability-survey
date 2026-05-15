# =========================
# LOAD LIBRARY
# =========================
library(readxl)
library(psych)
library(tidyverse)

# =========================
# 1. PENGUMPULAN DATA
# =========================
data <- read_excel("D:/SEMESTER 4/TEKSAM/ANALISIS KEPUASAN MHS STAT TRHDP FASILITAS FMIPA (Data RStudio).xlsx")

View(data)
str(data)


## AMBIL ITEM
item <- data[, 1:12]

## pastikan numeric bersih
item <- data.frame(lapply(item, function(x) as.numeric(as.character(x))))

# =========================
# 2. UJI VALIDITAS
# =========================
total_skor <- rowSums(item, na.rm = TRUE)

validitas <- data.frame(
  Item = colnames(item),
  r_hitung = sapply(item, function(x)
    cor(x, total_skor, use = "complete.obs")),
  p_value = sapply(item, function(x)
    cor.test(x, total_skor)$p.value)
)

print(validitas)

# =========================
# 3. UJI RELIABILITAS
# =========================

library(psych)

## buang item tidak valid (item ke-10)
item_valid <- item[, -10]

## pastikan semua numeric
item_valid <- as.data.frame(lapply(item_valid, function(x)
  as.numeric(as.character(x))
))

## buang missing value
item_valid <- na.omit(item_valid)

## cek struktur data
str(item_valid)

## hitung Cronbach Alpha
reliabilitas <- psych::alpha(item_valid)

## tampilkan hasil lengkap
print(reliabilitas)

## ambil nilai alpha saja
cat("Cronbach Alpha =", reliabilitas$total$raw_alpha)

# =========================
# 4. ANALISIS DESKRIPTIF
# =========================

## TABEL FREKUENSI SEMUA ITEM (1-12)
freq_all <- lapply(item, table)
freq_all

## PERSENTASE SEMUA ITEM
perc_all <- lapply(item, function(x) prop.table(table(x)) * 100)
perc_all

## STATISTIK DESKRIPTIF
summary(item)
describe(item)

# =========================
# 5. GRAFIK DISTRIBUSI RESPONDEN
# =========================

hist(total_skor,
     main = "Histogram Total Skor Kepuasan",
     xlab = "Total Skor",
     col = "lightgreen")

# =========================
# 6. NAÏVE ESTIMATION
# =========================
library(readxl)
naive <- read_excel("D:/SEMESTER 4/TEKSAM/DATA NAIVE ESTIMATION.xlsx")
item <- data[,1:12]

View(naive)

# =========================
# 7. WEIGHTED ESTIMATION (SEDERHANA)
# =========================
# Proporsi Populasi
populasi_laki <- 31
populasi_perempuan <- 126
populasi_total <- 157
# Proporsi Sampel
sampel_laki <- 9
sampel_perempuan <- 19
sampel_total <- 28
#Proporsi Populasi
proporsi_populasi_laki <- 0.197
proporsi__populasi_perempuan <- 0.803
# Proporsi Sampel
proporsi_sampel_laki <- 0.321
proporsi_sampel_perempuan <- 0.679
# menghitung bobot
Wl <- proporsi_populasi_laki/proporsi_sampel_laki
Wp <- proporsi__populasi_perempuan/proporsi_sampel_perempuan
# Output
Wl
Wp

# =========================
# 8. PERBANDINGAN ESTIMASI
# =========================
# =========================
### LOAD LIBRARY
library(readxl)

### IMPORT DATA
data <- read_excel("D:/SEMESTER 4/TEKSAM/WEIGHTING SEDERHANA.xlsx")

### AMBIL 11 VARIABEL LIKERT
item <- data[,1:11]
item <- data.frame(lapply(item, function(x) as.numeric(as.character(x))))

### VARIABEL JENIS KELAMIN
gender <- data$JenisKelamin

### MENGHITUNG BOBOT (WEIGHT)
Wl <- 0.197 / 0.321
Wp <- 0.803 / 0.679

weight <- ifelse(gender == "Laki-Laki", Wl, Wp)

### NAÏVE ESTIMATION
naive <- colMeans(item %in% c(4,5), na.rm = TRUE)

### WEIGHTED ESTIMATION
item_bin <- item %in% c(4,5)

weighted <- colSums(item_bin * weight, na.rm = TRUE) / sum(weight)

### TABEL PERBANDINGAN
perbandingan <- data.frame(
  Item = colnames(item),
  Naive_Estimation = round(naive, 3),
  Weighted_Estimation = round(weighted, 3)
)

print(perbandingan)

### GRAFIK PERBANDINGAN
barplot(rbind(naive, weighted),
        beside = TRUE,
        col = c("skyblue", "orange"),
        legend = c("Naïve", "Weighted"),
        main = "Perbandingan Naïve vs Weighted Estimation",
        ylab = "Proporsi Kepuasan")

### OUTPUT HASIL
cat("Naïve Estimation:/n")
print(naive)

cat("/nWeighted Estimation:/n")
print(weighted)