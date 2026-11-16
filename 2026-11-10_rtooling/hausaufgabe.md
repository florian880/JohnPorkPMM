# 2026-11-10_rtooling – CSV einlesen, als Excel ausgeben

Name: Florian Benes

**Aufgabe:** Recherchiere eigenständig, wie du das eingelesene Betriebsdaten-File als Excel
wieder in das R-Projekt zurückschreiben kannst. Erweitere das in der Schule erstellte Skript
dahingehend, dass CSV eingelesen und im Excel-Format ausgegeben wird.

## Dateien

| Datei | Inhalt |
|---|---|
| `betriebsdaten.csv` | Messdaten: 3 Maschinen × 10 Chargen × 4 Messungen = 120 Zeilen, 4 fehlende Werte |
| `csv_to_excel.R` | Skript: CSV einlesen → Kennzahlen → Excel schreiben → Kontrolle |
| `betriebsdaten.xlsx` | Ergebnis (entsteht beim Ausführen des Skripts) |

## Recherche: Wie schreibt man in R eine Excel-Datei?

| Paket | Schreiben | Vorteile | Nachteile |
|---|---|---|---|
| `writexl` | `write_xlsx()` | sehr einfach, schnell, keine Abhängigkeiten (kein Java, kein Excel nötig), mehrere Blätter über eine Liste | keine Formatierung |
| `openxlsx` | `write.xlsx()` | Formatierung (fett, Farben, Spaltenbreite), mehrere Blätter, kein Java | etwas mehr Code |
| `xlsx` | `write.xlsx()` | viele Funktionen | braucht Java (rJava) → oft Installationsprobleme |
| `readxl` | – | Teil vom tidyverse, liest Excel | **kann nur lesen, nicht schreiben** |

**Entscheidung:** `writexl`, weil es mit einer Zeile funktioniert und keine Zusatzsoftware braucht.
Zum Kontrollieren wird die Datei mit `readxl::read_excel()` wieder eingelesen.

## Ablauf im Skript

1. `read_csv()` liest die CSV ein; `col_types` legt fest: `maschine` = Faktor, `charge` = Ganzzahl, `masse_mm` = Kommazahl. Leere Felder werden automatisch zu `NA`.
2. Mit `group_by()` + `summarise()` Kennzahlen pro Maschine und pro Maschine/Charge (Mittelwert, Standardabweichung, Min, Max) – `na.rm = TRUE`, damit die 4 fehlenden Werte nicht alles zu `NA` machen.
3. `write_xlsx(list(Rohdaten = ..., Kennzahlen_Maschine = ..., Kennzahlen_Charge = ...), path = "betriebsdaten.xlsx")` – jeder Listeneintrag wird ein eigenes Tabellenblatt.
4. Kontrolle: `excel_sheets()` zeigt die Blätter, `read_excel()` liest sie zurück, Zeilenzahl wird verglichen.

## Ausführen

```r
install.packages(c("tidyverse", "writexl"))   # einmalig
source("2026-11-10_rtooling/csv_to_excel.R")
```

## Quellen

- writexl: https://docs.ropensci.org/writexl/
- openxlsx: https://ycphs.github.io/openxlsx/
- readxl: https://readxl.tidyverse.org/
- R4DS 2e, Kap. 7 Data import: https://r4ds.hadley.nz/data-import.html
