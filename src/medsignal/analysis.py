"""Reusable pharmacovigilance metrics."""

from __future__ import annotations

import math

import pandas as pd


def _flag(series: pd.Series) -> pd.Series:
    """Normalize common FAERS outcome encodings to a boolean flag."""
    return series.astype(str).str.strip().eq("1")


def outcome_summary(frame: pd.DataFrame) -> pd.DataFrame:
    """Return report counts and serious-outcome rates by product."""
    working = frame.copy()
    working["is_serious"] = working["serious_label"].str.casefold().eq("serious")
    working["is_death"] = _flag(working["seriousnessdeath"])
    working["is_hospitalised"] = _flag(working["seriousnesshospitalisation"])
    result = working.groupby("drug_name", dropna=False).agg(
        reports=("drug_name", "size"),
        serious_rate=("is_serious", "mean"),
        death_rate=("is_death", "mean"),
        hospitalisation_rate=("is_hospitalised", "mean"),
    )
    rate_columns = ["serious_rate", "death_rate", "hospitalisation_rate"]
    result[rate_columns] = (result[rate_columns] * 100).round(2)
    return result.sort_values("reports", ascending=False).reset_index()


def reporting_odds_ratio(a: int, b: int, c: int, d: int) -> dict[str, float]:
    """Calculate ROR and a Wald 95% CI from a 2×2 table.

    Cells are: target drug/event (a), target drug/other events (b),
    other drugs/event (c), and other drugs/other events (d).
    A 0.5 continuity correction is applied when any cell is zero.
    """
    cells = [float(value) for value in (a, b, c, d)]
    if any(value < 0 for value in cells):
        raise ValueError("Contingency-table counts must be non-negative")
    if any(value == 0 for value in cells):
        cells = [value + 0.5 for value in cells]
    a_value, b_value, c_value, d_value = cells
    ror = (a_value * d_value) / (b_value * c_value)
    standard_error = math.sqrt(sum(1 / value for value in cells))
    return {
        "ror": round(ror, 4),
        "ci_low": round(math.exp(math.log(ror) - 1.96 * standard_error), 4),
        "ci_high": round(math.exp(math.log(ror) + 1.96 * standard_error), 4),
    }
