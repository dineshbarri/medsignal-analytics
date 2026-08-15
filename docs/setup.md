# Complete setup guide

The repository includes the processed dataset, executed notebook, SQL scripts, Power BI file and PDF.
You can review the project without requesting new data.

## Python environment

```powershell
git clone https://github.com/dineshbarri/medsignal-analytics.git
cd medsignal-analytics
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -e ".[analysis,dev]"
```

On macOS/Linux, activate with `source .venv/bin/activate`.

## Quality checks and notebook

```powershell
ruff check src tests
pytest -q
jupyter lab notebooks/01_signal_exploration.ipynb
```

In JupyterLab, select **Kernel → Restart Kernel and Run All Cells** only when you intentionally want to
re-execute the analysis. The committed outputs are already available for portfolio review.

## Optional environment configuration

Copy `.env.example` to `.env` and add your own values only when refreshing API or PostgreSQL work:

```powershell
Copy-Item .env.example .env
```

Never commit `.env`. An openFDA API key is optional for reviewing the included extract.

## PostgreSQL

1. Install PostgreSQL 14 or newer.
2. Create a database named `fda_pharmacovigilance`.
3. Use the notebook database-load section to load the processed CSV.
4. Execute `sql/pharmacovigilance_analysis.sql` for the full investigation set.
5. Execute `sql/portfolio_queries.sql` for the curated analyst-facing queries.

Command-line example:

```powershell
createdb fda_pharmacovigilance
psql -d fda_pharmacovigilance -f sql/pharmacovigilance_analysis.sql
```

## Power BI

1. Install Microsoft Power BI Desktop.
2. Open `bi/medsignal_dashboard.pbix`.
3. If Power BI requests a source path, select **Transform data → Data source settings → Change Source**.
4. Point the source to `data/processed/adverse_event_reports.csv`.
5. Select **Close & Apply**, then review all three pages.
6. The repository PDF can be opened without Power BI Desktop.

The committed PBIX and PDF represent the portfolio dashboard version included with this release. See
[`powerbi_model.md`](powerbi_model.md) for its reporting structure and measure guidance.
