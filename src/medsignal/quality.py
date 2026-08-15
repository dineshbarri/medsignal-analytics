"""Data-contract checks for the adverse-event analytical extract."""

from __future__ import annotations

import pandas as pd

REQUIRED_COLUMNS = {
    "drug_name",
    "serious_label",
    "seriousnessdeath",
    "seriousnesshospitalisation",
    "receive_date",
    "reporter_country",
    "patient_age",
    "sex_label",
}


def validate_reports(frame: pd.DataFrame) -> dict[str, object]:
    """Validate schema and return a small, serializable quality report."""
    missing = sorted(REQUIRED_COLUMNS - set(frame.columns))
    if missing:
        raise ValueError(f"Missing required columns: {', '.join(missing)}")
    if frame.empty:
        raise ValueError("The report dataset is empty")

    duplicates = int(frame.duplicated().sum())
    null_rates = frame[sorted(REQUIRED_COLUMNS)].isna().mean().round(4).to_dict()
    return {
        "rows": len(frame),
        "columns": len(frame.columns),
        "duplicate_rows": duplicates,
        "null_rates": null_rates,
    }
