# CV

LaTeX-kilde til CV-en min, tilgjengelig på norsk og engelsk.

## Bygge PDF

CV-en bruker **lualatex**.

```bash
latexmk -lualatex -interaction=nonstopmode CV_Fredrik_Carsten_Hansteen_En.tex
latexmk -lualatex -interaction=nonstopmode CV_Fredrik_Carsten_Hansteen_Nb.tex
```

Uten `latexmk`:

```bash
lualatex CV_Fredrik_Carsten_Hansteen_En.tex
lualatex CV_Fredrik_Carsten_Hansteen_Nb.tex
```

Resultatet legges som `CV_Fredrik_Carsten_Hansteen_En.pdf` / `…_Nb.pdf`.

De to inngangsfilene gjør bare to ting: setter `\cvlang` og inputter `main.tex`.

```
CV_Fredrik_Carsten_Hansteen_En.tex   ┐
CV_Fredrik_Carsten_Hansteen_Nb.tex   ┴─►  main.tex  ─►  style/  +  content/
```

`main.tex` laster `style/main.sty` (som igjen drar inn alle delpakker i riktig rekkefølge) og inputter innholdsfilene under `content/` i ønsket rekkefølge.

## Mappestruktur

```
├── CV_Fredrik_Carsten_Hansteen_En.tex   Inngang — engelsk
├── CV_Fredrik_Carsten_Hansteen_Nb.tex   Inngang — norsk
├── main.tex                             Felles dokumentkropp
├── README.md
├── style/
│   ├── main.sty                         Paraplypakke — laster alt under
│   ├── colors.sty                       Fargepalett
│   ├── fonts.sty                        Typografi (Arial fra fonts/)
│   ├── lang.sty                         \cvlang, \enor, \lblXxx
│   ├── layout.sty                       Geometri, hyperref, lister
│   └── components.sty                   Gjenbrukbare komponenter
├── content/
│   ├── header.tex                       Navn, foto, kontaktlinje
│   ├── skills.tex                       Tekniske ferdigheter
│   ├── education/
│   │   ├── _section.tex
│   │   ├── master.tex
│   │   └── bachelor.tex
│   ├── experience/
│   │   ├── _section.tex
│   │   ├── rif.tex
│   │   ├── maritime-optima.tex
│   │   ├── ntnu.tex                     Flere roller samme sted
│   │   └── nat.tex
│   ├── selected/                        Utvalgt erfaring
│   │   ├── _section.tex
│   │   ├── application-committee.tex
│   │   ├── online-opptak.tex
│   │   ├── rif-website.tex
│   │   └── online-events.tex
│   └── other/                           Annen erfaring
│       ├── _section.tex
│       ├── welcome-committee.tex
│       ├── finance-committee.tex
│       └── excursion-committee.tex
├── fonts/                               Arial .TTF
└── images/
    └── fredrik_carsten_hansteen.png
```

## Komponent-API

Innholdsfilene under `content/` kaller utelukkende det offentlige API-et fra `style/components.sty`:

| Makro                                        | Bruk                                                                                              |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `\cvheader{navn}{kontakt}{foto}`             | Topptekst: rundt portrett til venstre, navn + kontaktlinje vertikalt sentrert til høyre.          |
| `\cvcontactsep`                              | Visuell separator (•) brukt mellom elementer i kontaktlinjen.                                     |
| `\cvsection{tittel}`                         | Avsnittsoverskrift (uppercased) med tynn linje *over* (mellom seksjoner).                         |
| `\cventry{rolle}{org}{sted}{datoer}`         | Jobb-oppføring på én linje: rolle \| org \| sted, med høyrejustert dato. Tom `datoer` er gyldig.  |
| `\cveduentry{tittel}{org}{sted}{datoer}`     | Utdanningsoppføring på to linjer (tittel + dato, deretter org \| sted) — for lengre titler.       |
| `\cvsubentry{tekst}{datoer}`                 | Underoppføring under `\cventry` (f.eks. flere roller hos samme arbeidsgiver).                     |
| `\begin{cvbullets} … \end{cvbullets}`        | Punktliste under en oppføring.                                                                    |
| `\cvselected{tittel}{undertittel}{datoer}`   | Oppføring i «Utvalgt erfaring» (én linje, dato høyrejustert).                                     |
| `\cvtech{stack}`                             | Innrykket teknologilinje rett under `\cvselected`.                                                |
| `\cvother{tittel}{org}{datoer}{beskrivelse}` | Kompakt oppføring i «Annen erfaring».                                                             |
| `\cvskillline{etikett}{kommadelt liste}`     | Linje med fet etikett og en kommadelt liste — ATS-vennlig ren tekst.                              |

## Tospråklighet

Aktivt språk ligger i `\cvlang` (`en` eller `nb`). To verktøy bruker det:

- `\enor{english}{norsk}` — inline tekst som har én verdi per språk.
- `\lbleducation`, `\lblexperience`, `\lblselected`, `\lblskills`, `\lblother`, `\lblprogramming`, `\lblframeworks`, `\lblothertech`, `\lblpresent` — forhåndsdefinerte etiketter.

Eksempel:

```latex
\cventry
  {\enor{Developer}{Utvikler}}
  {\enor{Council of Norwegian Consulting Engineers (RIF)}%
        {Rådgivende Ingeniørers Forening (RIF)}}
  {\enor{Oslo / Remote, Norway}{Oslo / Remote, Norge}}
  {Aug 2024 -- \lblpresent}
```

Samme fil produserer begge språk

## Flere roller samme sted

For en arbeidsgiver med flere roller, kombiner `\cventry` (tom `datoer`-argument) med `\cvsubentry`:

```latex
\cventry{Læringsassistent}{NTNU}{Trondheim, Norge}{}
\cvsubentry{Læringsassistent i IT2901 -- Informatikk prosjektarbeid II}
           {Januar 2025 -- Juni 2025}
\cvsubentry{Læringsassistent i KJ2095 -- Eksperter i Teams}
           {Januar 2025 -- Juni 2025}
```

## Fonter

CV-en bruker **Arial**. `style/fonts.sty` laster Arial direkte fra `fonts/`:

```
fonts/
├── ARIAL.TTF
├── ARIALBD.TTF
├── ARIALI.TTF
└── ARIALBI.TTF
```

## Avhengigheter

- TeX Live 2023+ (eller MiKTeX) med `lualatex`
- Pakker: `polyglossia`, `fontspec`, `geometry`, `tabularx`, `enumitem`,
  `tikz`, `hyperref`, `fancyhdr`, `graphicx`, `microtype`, `xcolor`,
  `etoolbox`
