# CV

LaTeX-kilde til CV-en min, tilgjengelig på norsk og engelsk.

## Forhåndsvisning

| Side 1 | Side 2 |
|:------:|:------:|
| ![Side 1](images/preview-1.png) | ![Side 2](images/preview-2.png) |

## Bygge PDF

CV-en bruker **lualatex**.

Via `build.sh` (gir korrekte PDF-navn):

```bash
bash build.sh       # bygger begge
bash build.sh en    # bare engelsk
bash build.sh nb    # bare norsk
bash build.sh clean # rydder opp
```

Direkte med `latexmk` (`-jobname` setter PDF-filnavnet):

```bash
latexmk -lualatex -jobname=CV_Fredrik_Carsten_Hansteen_En English.tex
latexmk -lualatex -jobname=CV_Fredrik_Carsten_Hansteen_Nb Norsk.tex
```

Resultatet legges som `CV_Fredrik_Carsten_Hansteen_En.pdf` / `CV_Fredrik_Carsten_Hansteen_Nb.pdf`.

De to inngangsfilene gjør bare to ting: setter `\cvlang` og inputter `main.tex`.

```
English.tex   ┐
Norsk.tex     ┴─►  main.tex  ─►  style/  +  content/
```

`main.tex` laster `style/main.sty` (som igjen drar inn alle delpakker i riktig rekkefølge) og inputter innholdsfilene under `content/` i ønsket rekkefølge.

## Mappestruktur

```
├── English.tex                          Inngang — engelsk
├── Norsk.tex                            Inngang — norsk
├── main.tex                             Felles dokumentkropp
├── README.md
├── style/
│   ├── main.sty                         Paraplypakke — laster alt under
│   ├── constants.sty                    Fontstørrelser og kolonnbredder
│   ├── colors.sty                       Fargepalett
│   ├── fonts.sty                        Typografi (Arial fra fonts/)
│   ├── lang.sty                         \cvlang, \enor, \lblXxx
│   ├── layout.sty                       Geometri, hyperref, lister
│   └── components/
│       ├── index.sty                    Laster alle komponentene under
│       ├── utils.sty                    Delte primitiver: \cv@bar, \cvdate
│       ├── header.sty                   \cvheader
│       ├── section.sty                  \cvsection
│       ├── entry.sty                    \cventry, cvbullets
│       ├── subentry.sty                 \cvsubentry (flere roller, f.eks. NTNU)
│       ├── education.sty                \cveduentry
│       ├── selected.sty                 \cvselected, \cvtech
│       ├── other.sty                    \cvother
│       └── skills.sty                   \cvskillline
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
├── images/
│   ├── fredrik_carsten_hansteen.png
│   ├── preview-1.png
│   └── preview-2.png
└── build.sh                             Bygger PDFer med riktige filnavn
```

## Komponent-API

Innholdsfilene under `content/` kaller utelukkende det offentlige API-et fra `style/components.sty`:

| Makro                                            | Bruk                                                                                             |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| `\cvheader{navn}{kontakt}{foto}`                 | Topptekst: rundt portrett til venstre, navn + kontaktlinje vertikalt sentrert til høyre.         |
| `\cvcontactsep`                                  | Visuell separator (•) brukt mellom elementer i kontaktlinjen.                                    |
| `\cvsection{tittel}`                             | Avsnittsoverskrift (uppercased) med tynn linje _over_ (mellom seksjoner).                        |
| `\cventry{rolle}{org}{sted}{datoer}`             | Jobb-oppføring på én linje: rolle \| org \| sted, med høyrejustert dato. Tom `datoer` er gyldig. |
| `\cveduentry{tittel}{org}{sted}{datoer}`         | Utdanningsoppføring på to linjer (tittel + dato, deretter org \| sted) — for lengre titler.      |
| `\cvsubentry{rolle}{emne}{startdato}{sluttdato}` | Underoppføring under `\cventry` med justerte start/sluttdatoer og automatisk kulepunkt.          |
| `\begin{cvbullets} … \end{cvbullets}`            | Punktliste under en oppføring.                                                                   |
| `\cvselected{tittel}{undertittel}{datoer}`       | Oppføring i «Utvalgt erfaring» (én linje, dato høyrejustert).                                    |
| `\cvtech{stack}`                                 | Innrykket teknologilinje rett under `\cvselected`.                                               |
| `\cvother{tittel}{org}{datoer}{beskrivelse}`     | Kompakt oppføring i «Annen erfaring».                                                            |
| `\cvskillline{etikett}{kommadelt liste}`         | Linje med fet etikett og en kommadelt liste — ATS-vennlig ren tekst.                             |

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
\cvsubentry{Læringsassistent}{IT2901 - Informatikk prosjektarbeid II}
           {Januar 2025}{Juni 2025}
\cvsubentry{Læringsassistent}{KJ2095 - Eksperter i Teams}
           {Januar 2025}{Juni 2025}
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
  `etoolbox`, `needspace`, `lastpage`
