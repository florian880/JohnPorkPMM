# =============================================================
# SA-00 „Was kann R?“ – Übungen von der Folie + Aufgabe
# Florian Benes, 4AHWIT (x), Prozessmanagement, 2026-10-06
# RStudio-Projekt pmm-sa-00 öffnen, dann Source (Ctrl+Shift+S)
# =============================================================

library(tidyverse)
library(palmerpenguins)

# -------------------------------------------------------------
# Folie: Erste Schritte im Skript
# -------------------------------------------------------------
2 + 2                                  # [1] 4

mittel <- mean(c(10.01, 9.98, 10.03))  # Zuweisung druckt nichts
mittel                                 # [1] 10.00667

# -------------------------------------------------------------
# Beispiel 1: Betriebsdaten von Null auf Vergleichstabelle
# -------------------------------------------------------------

# 1a. Einlesen und Erstblick
teile <- read_csv("daten/betriebsdaten.csv")
glimpse(teile)
# 120 Zeilen, 3 Spalten
# masse_mm ist <dbl> (Kommazahl)
# maschine ist <chr>, weil die Werte "M1", "M2", "M3" Text sind (Buchstabe M),
# keine Zahlen.

# 1b. Vorhersage: 3 Zeilen (eine pro Maschine), Mittelwerte alle ca. 10 mm
teile |>
  group_by(maschine) |>
  summarise(n = sum(!is.na(masse_mm)),
            mittel = mean(masse_mm, na.rm = TRUE))
# Ergebnis: M1 37 / 10.0 · M2 39 / 9.98 · M3 40 / 10.1 -> stimmt mit Kontrollwerten
# M1 hat n = 37 statt 40, weil bei M1 drei Messwerte fehlen (NA).
# sum(!is.na(...)) zählt nur tatsächlich gemessene Teile.

# 1c. Toleranz prüfen: Soll 10,00 mm ± 0,15 mm
sum(abs(teile$masse_mm - 10) > 0.15, na.rm = TRUE)
# -> Anzahl gemessener Teile außerhalb der Toleranz
# Vorhersage ohne na.rm: Ergebnis ist NA, weil eine einzige fehlende
# Messung die ganze Summe zu NA macht (klassischer Fehler: fehlende Werte
# ohne na.rm).
sum(abs(teile$masse_mm - 10) > 0.15)   # -> NA

# Welche Teile sind außerhalb?
teile |> filter(abs(masse_mm - 10) > 0.15)

# -------------------------------------------------------------
# Folie: Pinguine – Plot, Kennzahlen, NA-Fehler, t-Test
# -------------------------------------------------------------
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
# 342 Punkte: zwei Pinguine haben keine Massung (Warnung "Removed 2 rows")

penguins |>
  group_by(species) |>
  summarise(n = n(), mittel = round(mean(body_mass_g, na.rm = TRUE)))
# Adelie 152/3701 · Chinstrap 68/3733 · Gentoo 124/5076

mean(penguins$body_mass_g)              # NA -> fehlende Werte!
mean(penguins$body_mass_g, na.rm = TRUE)

t.test(body_mass_g ~ sex, data = penguins)
# p-value = 4.794e-16 -> Unterschied Männchen/Weibchen kaum durch Zufall erklärbar

# -------------------------------------------------------------
# Beispiel 3: Transfer – Inseln statt Maschinen
# -------------------------------------------------------------
# 3a. Vorhersage: 3 Zeilen (Biscoe, Dream, Torgersen);
#     schwerste Insel vermutlich Biscoe
penguins |>
  group_by(island) |>
  summarise(n = n(), mittel = round(mean(body_mass_g, na.rm = TRUE)))
# 3b. Biscoe 168/4716 · Dream 124/3713 · Torgersen 52/3706 -> Vorhersage stimmt

# 3c. Warum ist Biscoe so schwer?
penguins |>
  count(species, island)
# Die Gentoos (schwerste Art, ca. 5076 g) leben nur auf Biscoe.
# Deshalb zieht Biscoe den Inselmittelwert nach oben – es liegt an der Art,
# nicht an der Insel selbst.
# Nur auf einer Insel: Gentoo (Biscoe) und Chinstrap (Dream);
# Adelie lebt auf allen drei Inseln.

# 3d. t-Test nach Geschlecht
t.test(body_mass_g ~ sex, data = penguins)
# p-value = 4.794e-16
# Vermutung: Mit island (drei Gruppen) läuft t.test nicht – der t-Test
# vergleicht genau zwei Gruppen. Für drei Gruppen braucht man z. B. eine
# ANOVA (KM 7).
