# Hausaufgabe UE 1 — Daten visualisieren

Name: Florian Benes &nbsp;&nbsp;&nbsp; Abgabe: _____________

**Lektüre:** R4DS 2e, [Kap. 1 Data visualization](https://r4ds.hadley.nz/data-visualize.html)
und [Kap. 2 Workflow: basics](https://r4ds.hadley.nz/workflow-basics.html) —
lies sie zuerst, die Aufgaben bauen darauf auf.

**Skript:** Der gesamte Code dieser Hausaufgabe steht in [`sa01_ggplot.R`](sa01_ggplot.R) (läuft von oben nach unten durch, Source-Button).

---

## 1. Setup + erstes Ritual

Installiere `tidyverse` und `palmerpenguins` (falls noch nicht geschehen) und
führe aus:

```r
library(tidyverse)
library(palmerpenguins)

glimpse(penguins)
```

- Wie viele Zeilen (Pinguine)? 344 &nbsp; Wie viele Spalten? 8
- Welchen Typ hat `species`? factor &nbsp; `body_mass_g`? integer

---

## 2. Die Einstiegsfrage nachbauen

Baue im **Skript** (nicht in der Konsole!) das Ziel-Bild aus der Stunde nach:

```r
ggplot(penguins,
       aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  labs(x = "Flossengröße (mm)", y = "Körpermasse (g)")
```
![Zielplot: Flossengröße vs. Körpermasse nach Art](Screenshot%202026-10-12%20140219.png)
- Steigt die Körpermasse mit der Flossengröße für **alle drei Arten**? Körpermasse steigt mit Flossengröße
- Welche Art ist am schwersten? Gentoo

---

## 3. Vorhersagen (ohne R — erst hinschreiben!)

**a)** Was unterscheidet diese beiden Zeilen im Ergebnis?

```r
ggplot(penguins, aes(x = species, y = body_mass_g)) + geom_point(color = "red")
ggplot(penguins, aes(x = species, y = body_mass_g, color = species)) + geom_point()
```

Vorhersage: erste Zeile alles rot(colour=rot), zweite nach species eingefärbt(color=species)

<br>R-Ergebnis (ausführen und vergleichen): Alle Punkte sind rot.  
![Alle Punkte rot (color = "red" in geom_point)](Screenshot%202026-10-13%20001856.png)

**b)** Was passiert, wenn du das `+` an den Zeilenanfang stellst?

```r
ggplot(penguins, aes(x = body_mass_g))
  + geom_histogram(binwidth = 250)
```

Vorhersage: funktioniert nicht

<br>R-Ergebnis: Hat tatsächlich nicht funktioniert ---> Fehler

---

## 4. Eine eigene Frage finden

Wähle zwei Zahlen-Spalten der Pinguine, die dich interessieren, und baue ein
Streudiagramm mit sinnvollen `labs()`-Achsentiteln. Ergänze `geom_smooth()`.

- Deine Frage (in einem Satz): Hängt die Schnabellänge der Pinguine mit ihrer Körpermasse zusammen?
- Was zeigt der Plot? (2 Sätze): Pinguine mit längerem Schnabel sind im Durchschnitt schwerer. Der Trend ist klar steigend, auch wenn die Punkte etwas streuen.
![Schnabellänge vs. Körpermasse mit geom_smooth](Screenshot%202026-10-13%20003341.png)

---

## 5. Kapitel-Check (Kap. 2 — Workflow: basics)

Antworte in eigenen Worten (1–2 Sätze je Frage):

- Warum steht das `+` in `ggplot2` **immer am Zeilenende** — was würde auch
  technisch passieren, wenn du es ans Zeilenanfang stellst? Wie meldet sich R?

  Das + zeigt R, dass der Befehl weitergeht und noch eine nächste Zeile dazugehört.
Wenn du das + an den Anfang stellst, denkt R, dass ein neuer Befehl beginnt, und meldet einen Fehler

- Warum speichert man Werte mit `<-` in einem Skript, statt sie in der
  Konsole direkt auszurechnen?

  Im Skript bleiben deine Berechnungen dauerhaft gespeichert, sodass du sie jederzeit wieder ausführen kannst.
In der Konsole verschwinden alle Ergebnisse, sobald du R schließt — im Skript ist alles nachvollziehbar und wiederholbar.
