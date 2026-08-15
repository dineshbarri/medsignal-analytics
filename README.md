# MedSignal Analytics

![MedSignal Analytics](assets/medsignal-hero.png)

[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB)](https://www.python.org/)
[![Tests](https://img.shields.io/badge/tests-pytest-0A9EDC)](tests/)
[![License](https://img.shields.io/badge/license-MIT-2EA44F)](LICENSE)

An end-to-end pharmacovigilance portfolio project that turns 6,000 public adverse-event reports into reproducible drug-safety metrics, SQL analyses, signal-screening outputs, and a three-page Power BI report.

> This project supports exploratory analytics—not causal inference, clinical decisions, or a claim that a medicine caused an event.

## What this demonstrates

- A maintainable Python analytics package instead of notebook-only logic
- Data-quality checks and reusable KPI calculations for serious outcomes
- Disproportionality screening with Reporting Odds Ratio (ROR)
- Analyst-ready SQL, Power BI assets, automated tests, and CI
- Clear communication of limitations in spontaneous-reporting data

## Snapshot

| Scope | Value |
|---|---:|
| Reports | 6,000 |
| Products | 5 |
| Coverage | Jan 2022–Apr 2025 |
| BI pages | 3 |

The portfolio dataset contains reports for aspirin, ibuprofen, paracetamol, metformin, and atorvastatin. Missing demographics, reporting concentration, duplicates, co-medications, notoriety bias, and lack of exposure denominators can materially affect interpretation.

## Quick start

```bash
git clone https://github.com/dineshbarri/medsignal-analytics.git
cd medsignal-analytics
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -e ".[dev]"
medsignal profile data/processed/adverse_event_reports.csv
pytest
```

## Repository map

```text
medsignal-analytics/
├── src/medsignal/       # validation, KPIs, signal metrics, CLI
├── tests/               # unit tests for analytical logic
├── data/processed/      # portfolio-ready analytical extract
├── notebooks/           # exploratory narrative and charts
├── sql/                 # PostgreSQL analyst queries
├── bi/                  # Power BI source and PDF export
├── assets/              # original hero and dashboard previews
├── docs/                # methods, data dictionary, portfolio notes
└── .github/workflows/   # automated quality checks
```

## Dashboard

![Executive summary](assets/dashboard-executive-summary.png)

Additional pages: [drug safety](assets/dashboard-drug-safety.png) · [demographics and signals](assets/dashboard-demographics.png) · [PDF report](bi/medsignal_dashboard.pdf)

## Method

The package validates the analytical extract, calculates outcome rates, and provides a generic ROR function for 2×2 drug–event contingency tables. An ROR above 1 indicates disproportionate reporting, not causality; interpretation should consider confidence intervals, case quality, confounding, duplicates, and exposure.

See [methodology](docs/methodology.md), [data dictionary](docs/data_dictionary.md), and [portfolio talking points](docs/portfolio_notes.md).

## Author

Built by [Dinesh Barri](https://github.com/dineshbarri) as a data analytics and business intelligence portfolio project.

Data attribution: public FDA adverse-event reports accessed through [openFDA](https://open.fda.gov/apis/drug/event/). Licensed under [MIT](LICENSE).
