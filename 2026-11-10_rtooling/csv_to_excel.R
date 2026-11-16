# =============================================================
# 2026-11-10_rtooling – Betriebsdaten: CSV einlesen -> Excel ausgeben
# Florian Benes, 4AHWIT, Prozessmanagement (Statistik)
# =============================================================
# Einmalig installieren (falls noch nicht vorhanden):
# install.packages(c("tidyverse", "writexl"))

library(readr)    # CSV einlesen
library(dplyr)    # Kennzahlen berechnen
library(writexl)  # Excel (.xlsx) schreiben – braucht kein Java/Excel
library(readxl)   # Excel wieder einlesen (Kontrolle)

# Ordner bestimmen: funktioniert, egal ob das Arbeitsverzeichnis
# der Repo-Ordner oder dieser Aufgaben-Ordner ist
ordner <- if (file.exists("betriebsdaten.csv")) "." else "2026-11-10_rtooling"

# -------------------------------------------------------------
# 1. CSV einlesen
# -------------------------------------------------------------
betriebsdaten <- read_csv(
  file.path(ordner, "betriebsdaten.csv"),
  col_types = cols(
    maschine = col_factor(),
    charge   = col_integer(),
    masse_mm = col_double()
  )
)

glimpse(betriebsdaten)                 # 120 Zeilen, 3 Spalten
sum(is.na(betriebsdaten$masse_mm))     # 4 fehlende Messwerte

# -------------------------------------------------------------
# 2. Kennzahlen (fehlende Werte mit na.rm = TRUE ignorieren)
# -------------------------------------------------------------
kennzahlen_maschine <- betriebsdaten |>
  group_by(maschine) |>
  summarise(
    n_messungen = n(),
    n_fehlend   = sum(is.na(masse_mm)),
    mittelwert  = mean(masse_mm, na.rm = TRUE),
    sd          = sd(masse_mm, na.rm = TRUE),
    min         = min(masse_mm, na.rm = TRUE),
    max         = max(masse_mm, na.rm = TRUE)
  )

kennzahlen_charge <- betriebsdaten |>
  group_by(maschine, charge) |>
  summarise(
    n_gueltig  = sum(!is.na(masse_mm)),
    mittelwert = mean(masse_mm, na.rm = TRUE),
    sd         = sd(masse_mm, na.rm = TRUE),
    .groups    = "drop"
  )

kennzahlen_maschine

# -------------------------------------------------------------
# 3. Als Excel ins R-Projekt zurückschreiben
#    Eine Liste von Data Frames = je ein Tabellenblatt
# -------------------------------------------------------------
excel_datei <- file.path(ordner, "betriebsdaten.xlsx")

write_xlsx(
  list(
    Rohdaten            = betriebsdaten,
    Kennzahlen_Maschine = kennzahlen_maschine,
    Kennzahlen_Charge   = kennzahlen_charge
  ),
  path = excel_datei
)

# -------------------------------------------------------------
# 4. Kontrolle: Excel wieder einlesen und vergleichen
# -------------------------------------------------------------
excel_sheets(excel_datei)              # "Rohdaten" "Kennzahlen_Maschine" "Kennzahlen_Charge"
kontrolle <- read_excel(excel_datei, sheet = "Rohdaten")
nrow(kontrolle) == nrow(betriebsdaten) # TRUE -> alle Zeilen drin

# -------------------------------------------------------------
# 5. Excel-Datei direkt in Excel öffnen (Windows)
# -------------------------------------------------------------
if (.Platform$OS.type == "windows") {
  shell.exec(normalizePath(excel_datei))
}

# Alternative mit Formatierung (fette Kopfzeile, Spaltenbreiten):
# install.packages("openxlsx")
# openxlsx::write.xlsx(betriebsdaten, file.path(ordner, "betriebsdaten_formatiert.xlsx"),
#                      headerStyle = openxlsx::createStyle(textDecoration = "bold"),
#                      colWidths = "auto")
