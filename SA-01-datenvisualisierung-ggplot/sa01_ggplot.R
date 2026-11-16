# =============================================================
# SA-01 Datenvisualisierung mit ggplot – Hausaufgabe UE 1
# Florian Benes, 4AHWIT (x), Prozessmanagement
# Gesamtes Skript: läuft von oben nach unten durch (Source)
# =============================================================

library(tidyverse)
library(palmerpenguins)   # liefert penguins mit body_mass_g usw.

# -------------------------------------------------------------
# 1. Setup + erstes Ritual
# -------------------------------------------------------------
glimpse(penguins)
# -> 344 Zeilen, 8 Spalten
# -> species: factor, body_mass_g: integer

# -------------------------------------------------------------
# 2. Die Einstiegsfrage nachbauen (Ziel-Plot)
# -------------------------------------------------------------
p_ziel <- ggplot(penguins,
                 aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  labs(x = "Flossengröße (mm)", y = "Körpermasse (g)")
p_ziel
# Körpermasse steigt bei allen drei Arten mit der Flossengröße.
# Am schwersten: Gentoo.

# -------------------------------------------------------------
# 3. Vorhersagen
# -------------------------------------------------------------
# a) color = "red" in geom_point() -> alle Punkte rot (fixe Farbe)
ggplot(penguins, aes(x = species, y = body_mass_g)) + geom_point(color = "red")
# color = species in aes() -> Farbe abhängig von der Spalte species
ggplot(penguins, aes(x = species, y = body_mass_g, color = species)) + geom_point()

# b) + am Zeilenanfang: R hält die erste Zeile für einen fertigen Befehl,
#    die zweite Zeile beginnt mit + und erzeugt einen Fehler.
#    Deshalb hier auskommentiert, damit das Skript durchläuft:
# ggplot(penguins, aes(x = body_mass_g))
#   + geom_histogram(binwidth = 250)
# richtig:
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 250)

# -------------------------------------------------------------
# 4. Eigene Frage: Hängt die Schnabellänge mit der Körpermasse zusammen?
# -------------------------------------------------------------
p_eigen <- ggplot(penguins, aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth() +
  labs(x = "Schnabellänge (mm)", y = "Körpermasse (g)")
p_eigen
# Pinguine mit längerem Schnabel sind im Schnitt schwerer.
# Der Trend steigt klar, die Punkte streuen aber deutlich.

# Plots als Bilddateien speichern (Beleg im Repo)
ggsave("sa01_zielplot.png", p_ziel, width = 7, height = 5)
ggsave("sa01_eigene_frage.png", p_eigen, width = 7, height = 5)

# -------------------------------------------------------------
# 5. Kapitel-Check (Kap. 2 Workflow: basics)
# -------------------------------------------------------------
# + am Zeilenende: sagt R, dass der Befehl weitergeht. Am Zeilenanfang
#   ist der Befehl davor schon fertig -> Fehler.
# <- im Skript: Werte sind gespeichert und jederzeit reproduzierbar;
#   Console-Eingaben sind nach dem Schließen weg.
