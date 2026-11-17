# 2026-11-17 Selbststudium t-Test – Aufgabe KM7-01

Name: Florian Benes · 4AHWIT (x) · Abgabe: 17.11.2026

Angabe: [GRG-PMM/unterricht/KM7-01-mittelwertsvergleich-t-test/aufgabe.md](https://github.com/georgernstgraf/GRG-PMM/blob/main/unterricht/KM7-01-mittelwertsvergleich-t-test/aufgabe.md)
Lektüre: Navarro, *Learning Statistics with R*, Kap. 13 (t-Tests)

## Dateien

| Datei | Inhalt |
|---|---|
| `2026-11-17_selbststudium_t_test.Rproj` | RStudio-Projekt (der Ordner ist der Projektordner) |
| `analyse.R` | gesamter Code der Aufgabe, Antworten als Kommentare |
| `daten/betriebsdaten.csv` | Betriebsdaten (aus `assets/`) |
| `konsolenausgabe.txt` | vollständige RStudio-Konsolenausgabe eines Durchlaufs |
| `eingaben_konsole.Rhistory` | die Befehle, die ich in der Console eingegeben habe |

## 1. Vorhersagen

**a)** M1 37 · M2 39 · M3 40 (je 40, minus 3 fehlende bei M1 und 1 bei M2) → bestätigt.

**b)** M3 – Mittelwert 10,063 mm, also ca. **6 Hundertstel** (0,0627 mm) über dem Sollmaß. Zum Vergleich: M1 liegt nur 0,0005 mm, M2 0,023 mm daneben.

**c)** M1 gegen M3 fällt leichter durch. Dort ist die Differenz (0,062 mm) fast so groß wie die größere Streuung, bei M1 gegen M2 ist die Differenz (0,024 mm) kleiner als beide Streuungen – der Effekt geht im Rauschen eher unter.

## 2. Ungepaarter Vergleich M1 gegen M3

- H0: M1 und M3 haben denselben Mittelwert (Differenz = 0)
- H1: M1 und M3 haben unterschiedliche Mittelwerte (Differenz ≠ 0)
- t = −5,1132 · df = 55,272 · p = 4,092 · 10⁻⁶
- 95-%-KI der Differenz (M1 − M3): −0,0866 bis −0,0378 mm

M3 liegt mit 95 % Sicherheit **mindestens 0,038 mm** und **höchstens 0,087 mm** über M1. Das ganze Intervall passt deutlich in die Toleranz von ± 0,15 mm – der Unterschied ist echt, aber klein.

## 3. Gepaarter Vergleich (10 Chargen)

**a)** Positiv: 10 · negativ: 0 – M3 ist in jeder Charge größer als M1.

**b)** t = 5,9822 · df = 9 · p = 0,000207

**c)** Der gepaarte Test arbeitet nicht mit den 37 bzw. 40 Einzelmessungen, sondern mit den **10 Differenzen der Chargenmittel**. Bei n = 10 Differenzen ergeben sich n − 1 = 9 Freiheitsgrade.

**d)**
- t über die Differenzen: 5,982 (= R, gepaarter Test)
- t über die Messwerte: 5,113 (= Betrag des Welch-t aus Aufgabe 2)

Der Wert über die **Differenzen** stimmt mit R überein; der über die Messwerte ist der Welch-Wert aus Aufgabe 2. Die gepaarte Formel nimmt die Streuung der Differenzen – die Schwankung zwischen den Chargen fällt heraus, das Rauschen wird kleiner, der t-Wert größer.

## 4. Kapitel-Check (Navarro Kap. 13)

**a)** In der Praxis kennt man σ der Grundgesamtheit nie, man hat nur die Stichprobe und schätzt daraus s. Der t-Test berücksichtigt, dass diese Schätzung selbst unsicher ist: Er verwendet die t-Verteilung, die (vor allem bei wenigen Freiheitsgraden) breitere Ränder als die Normalverteilung hat. Der z-Test tut so, als wäre σ exakt bekannt, und wäre dadurch zu optimistisch.

**b)** Nein. p = 0,42 heißt nur: H0 kann nicht verworfen werden, ein Unterschied ist mit diesen Daten **nicht nachweisbar**. Gleichheit ist damit nicht bewiesen – es kann sein, dass ein echter Unterschied existiert, der Test ihn aber nicht findet (**Fehler 2. Art**, β). Der Fehler 1. Art (α) wäre umgekehrt, H0 zu verwerfen, obwohl sie stimmt.

**c)**
1. Dieselben Teile **vor und nach** einem Bearbeitungsschritt messen (z. B. Wärmebehandlung) – jedes Teil ist sein eigener Vergleich.
2. **Zwei Messgeräte** (oder zwei Prüfer) messen dieselben Teile – die Paare gehören zum selben Teil.
3. Zwei Maschinen fertigen **dieselben Chargen** wie hier M1 und M3 – gleiches Rohmaterial je Charge, die Chargenschwankung fällt beim Paaren heraus.

## 5. Die Frage hinter der Aufgabe

**a)** Nein. 0,024 mm sind nur rund 16 % der Toleranz von ± 0,15 mm, beide Maschinen liegen klar innerhalb. Der p-Wert sagt nur, dass der Unterschied sehr wahrscheinlich kein Zufall ist – nicht, ob er für die Qualität wichtig ist. Eine Prozessänderung würde Geld kosten, ohne dass ein Teil dadurch besser wird.

**b)** „Signifikant“ ist eine Aussage über **Zufall**: Der Unterschied ist echt. „Wirtschaftlich nicht relevant“ ist eine Aussage über die **Größe**: Der Unterschied ist zu klein, um etwas zu ändern. Die Stärke des Tests ist, auch kleine echte Unterschiede sicher zu erkennen; seine Grenze ist, dass er nichts über deren Bedeutung sagt – mit genug Daten wird fast jeder Unterschied signifikant.

**c)** Mehr Messungen verkleinern den Standardfehler (Wurzel aus n im Nenner), damit wird ein kleiner Effekt leichter nachweisbar. Wirksamer ist es, **mehr Chargen** zu messen statt mehr Teile pro Charge: Teile aus derselben Charge ähneln sich und liefern kaum neue Information, jede neue Charge ist dagegen eine wirklich unabhängige Beobachtung.

## Feedback zur Lektion

- **Gut:** Dass die ganze Lektion mit einem einzigen Datensatz (den Betriebsdaten) arbeitet, hat mir geholfen – man kennt die Zahlen schon und kann sich auf den Test konzentrieren. Der Satz „Effekt gegen Rauschen“ hat für mich am meisten erklärt, was der t-Test eigentlich macht.
- **Gut:** Die Quizfragen zwischendurch sind praktisch, weil man sofort merkt, ob man es verstanden hat – besonders die Frage zu p = 0,42.
- **Schwieriger:** Der Unterschied zwischen gepaart und ungepaart war am Anfang nicht sofort klar, vor allem warum plötzlich nur 9 Freiheitsgrade. Erst beim Nachrechnen über die Differenzen hat es Sinn ergeben.
- **Verbesserung:** Die Pflichtlektüre ist auf Englisch und recht lang – eine kurze deutsche Zusammenfassung der wichtigsten Begriffe (H0/H1, p-Wert, Fehler 1./2. Art, Konfidenzintervall) am Ende der Lektion wäre zum Lernen hilfreich.
- **Am interessantesten:** Aufgabe 5 – dass „signifikant“ nicht automatisch „wichtig“ heißt. Das ist für die Praxis die wichtigste Erkenntnis.
