# SA-00 – Was kann R? (2026-10-06)

Name: Florian Benes · 4AHWIT (x)

Angabe: [GRG-PMM/unterricht/SA-00-was-kann-r/aufgabe.md](https://github.com/georgernstgraf/GRG-PMM/blob/main/unterricht/SA-00-was-kann-r/aufgabe.md)
„Alle Übungen von der Folie selber committen.“

## Dateien

| Datei | Inhalt |
|---|---|
| `pmm-sa-00.Rproj` | RStudio-Projekt |
| `analyse.R` | alle Folienübungen (2 + 2, `<-`, `glimpse`, `group_by`/`summarise`, NA-Fehler, `t.test`) + Beispiele 1 und 3 mit Antworten als Kommentare |
| `pinguine_flosse_masse.png` | Diagramm von der Folie: Flossenlänge vs. Körpermasse (vom Skript gespeichert) |
| `daten/betriebsdaten.csv` | Betriebsdaten (aus `assets/`) |
| `konsolenausgabe.txt` | vollständige RStudio-Konsolenausgabe eines Durchlaufs (17.11.2026, ohne Fehler) |
| `eingaben_konsole.Rhistory` | die Befehle, die ich in der Console eingegeben habe (Beleg für den Testlauf) |

## Beispiel 1 – Antworten

- **1a:** 120 Zeilen, 3 Spalten. `masse_mm` ist `<dbl>`. `maschine` ist `<chr>`, weil „M1“, „M2“, „M3“ Text sind.
- **1b:** M1 37 / 10.0 · M2 39 / 9.98 · M3 40 / 10.1. M1 hat n = 37, weil dort 3 Messwerte fehlen (`NA`).
- **1c:** **6 Teile** liegen außerhalb der Toleranz (10,00 ± 0,15 mm) – alle von **M3** (Chargen 103, 106, 106, 107, 108, 110, jeweils ca. 10,2 mm). M3 misst also systematisch zu groß. Ohne `na.rm = TRUE` kommt `NA` heraus, weil ein einziger fehlender Wert die Summe unbrauchbar macht.
- **1d:** `analyse.R` läuft per Source komplett von oben nach unten durch.

## Beispiel 2 – Selbsttest

| Frage | Meine Antwort |
|---|---|
| 2.1 | im Skript |
| 2.2 | nichts – die Zuweisung speichert nur |
| 2.3 | Gentoo ca. 1375 g schwerer; `n` zählt die Pinguine je Art |
| 2.4 | Messrauschen kann so einen Unterschied fast nie erzeugen; gehört zu KM 7 |
| 2.5 | jede Zeile steht in der Datei; bei 120.000 Zeilen gleicher Code; Skript erneut laufen lassen |
| 2.6 | 342 Punkte (2 ohne Massung); `aes()` ordnet zu, `geom_point()` zeichnet |

Die Warnung „Removed 2 rows containing missing values“ am Ende der Konsolenausgabe gehört zum Pinguin-Streuplot: genau die 2 Pinguine ohne Massung (siehe 2.6) – kein Fehler.

## Beispiel 3 – Antworten

- **3a/3b:** 3 Zeilen; Biscoe 168/4716 · Dream 124/3713 · Torgersen 52/3706 → Biscoe am schwersten.
- **3c:** Die Gentoos (schwerste Art) leben nur auf Biscoe – darum ist der Inselmittelwert dort hoch. Gentoo kommt nur auf Biscoe, Chinstrap nur auf Dream vor.
- **3d:** p-value = 4.794e-16. Mit `island` (drei Gruppen) funktioniert `t.test` nicht, weil er genau zwei Gruppen vergleicht → dafür braucht man z. B. eine ANOVA (KM 7).
