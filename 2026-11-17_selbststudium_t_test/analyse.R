# =============================================================
# 2026-11-17 Selbststudium t-Test – Aufgabe KM7-01
# Mittelwertsvergleich: z-Test und t-Test
# Florian Benes, 4AHWIT (x), Prozessmanagement
# Projektordner = R-Projekt, Daten unter daten/betriebsdaten.csv
# =============================================================

library(tidyverse)

daten <- read_csv("daten/betriebsdaten.csv", show_col_types = FALSE)
glimpse(daten)   # 120 Zeilen, 3 Spalten, 4 Messungen fehlen

# Kennzahlen je Maschine (na.rm = TRUE wegen der 4 fehlenden Werte)
kennzahlen <- daten |>
  group_by(maschine) |>
  summarise(
    n           = sum(!is.na(masse_mm)),
    mittel      = mean(masse_mm, na.rm = TRUE),
    streuung    = sd(masse_mm, na.rm = TRUE),
    abstand_soll = mittel - 10
  )
kennzahlen

# -------------------------------------------------------------
# 1. Vorhersagen (vor dem Ausführen aufgeschrieben)
# -------------------------------------------------------------
# a) Vorhersage: M1 37, M2 39, M3 40 gültige Messungen
#    (120/3 = 40 je Maschine, minus 3 fehlende bei M1, minus 1 bei M2)
daten |> group_by(maschine) |>
  summarise(n = sum(!is.na(masse_mm)))
# -> stimmt: 37 / 39 / 40

# b) Vorhersage: M3 liegt am weitesten vom Sollmaß weg,
#    ca. 6 Hundertstel (10,063 - 10,000 = 0,063 mm) zu groß
#    -> siehe Spalte abstand_soll in kennzahlen

# c) M1 gegen M3 fällt leichter durch: Die Differenz (0,062 mm) ist fast
#    doppelt so groß wie die größere Streuung, bei M1 gegen M2 ist die
#    Differenz (0,024 mm) kleiner als beide Streuungen.
#    Der t-Test vergleicht Effekt mit Rauschen – je größer der Effekt im
#    Verhältnis zur Streuung, desto eindeutiger das Ergebnis.

# -------------------------------------------------------------
# 2. Ungepaarter Vergleich M1 gegen M3 (Welch-t-Test)
# -------------------------------------------------------------
# H0: M1 und M3 haben denselben Mittelwert (Differenz = 0)
# H1: M1 und M3 haben unterschiedliche Mittelwerte (Differenz ≠ 0)
vergleich <- daten |> filter(maschine %in% c("M1", "M3"))
t.test(masse_mm ~ maschine, data = vergleich)
# Erwartet laut Lektion: t = -5.1132, df = 55.272, p = 4.092e-06,
# 95%-KI der Differenz (M1 - M3): -0.08659 bis -0.03783
# In Sätzen: M3 liegt mit 95 % Sicherheit mindestens 0,038 mm und
# höchstens 0,087 mm über M1. Das ganze Intervall liegt deutlich
# innerhalb der Toleranz von ± 0,15 mm.

# -------------------------------------------------------------
# 3. Gepaarter Vergleich über die 10 Chargen
# -------------------------------------------------------------
chargen <- daten |>
  group_by(maschine, charge) |>
  summarise(mm = mean(masse_mm, na.rm = TRUE), .groups = "drop") |>
  pivot_wider(names_from = maschine, values_from = mm)
chargen

differenzen <- chargen$M3 - chargen$M1
differenzen

# a) Anzahl positiver / negativer Differenzen
sum(differenzen > 0)   # positiv
sum(differenzen < 0)   # negativ

# b) gepaarter t-Test
t.test(chargen$M3, chargen$M1, paired = TRUE)

# c) 9 Freiheitsgrade: Der gepaarte Test rechnet nicht mit den 37 bzw. 40
#    Einzelmessungen, sondern mit den 10 Differenzen der Chargenmittel.
#    Bei n = 10 Differenzen sind es n - 1 = 9 Freiheitsgrade.

# d) t-Wert von Hand nachrechnen
# über die Differenzen: Mittel der Differenzen / (sd der Differenzen / sqrt(n))
t_diff <- mean(differenzen) / (sd(differenzen) / sqrt(length(differenzen)))
t_diff
# über die Messwerte: Mittelwert-Differenz / Standardfehler beider Gruppen
m1 <- kennzahlen |> filter(maschine == "M1")
m3 <- kennzahlen |> filter(maschine == "M3")
t_mess <- (m3$mittel - m1$mittel) / sqrt(m1$streuung^2 / m1$n + m3$streuung^2 / m3$n)
t_mess
# t über die Differenzen stimmt mit dem gepaarten Test überein.
# t über die Messwerte ist der Wert des ungepaarten Welch-Tests (Aufgabe 2).
# Lehre: Die gepaarte Formel nimmt die Streuung der Differenzen –
# Unterschiede zwischen den Chargen fallen dadurch heraus, das Rauschen
# wird kleiner und der t-Wert größer.

# -------------------------------------------------------------
# 5. Die Frage hinter der Aufgabe: M1 gegen M2
# -------------------------------------------------------------
t.test(masse_mm ~ maschine, data = daten |> filter(maschine %in% c("M1", "M2")))
# laut Angabe p = 0.005456 -> signifikant, aber nur 0,024 mm Unterschied
