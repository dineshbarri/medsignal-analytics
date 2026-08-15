import pandas as pd
import pytest

from medsignal.analysis import outcome_summary, reporting_odds_ratio
from medsignal.quality import validate_reports


def sample_reports() -> pd.DataFrame:
    return pd.DataFrame(
        {
            "drug_name": ["A", "A", "B"],
            "serious_label": ["Serious", "Non-Serious", "Serious"],
            "seriousnessdeath": ["1", "2", "2"],
            "seriousnesshospitalisation": ["2", "1", "1"],
            "receive_date": ["2024-01-01"] * 3,
            "reporter_country": ["US"] * 3,
            "patient_age": [40, 50, 60],
            "sex_label": ["Female", "Male", "Female"],
        }
    )


def test_outcome_summary_calculates_percentages() -> None:
    summary = outcome_summary(sample_reports()).set_index("drug_name")
    assert summary.loc["A", "serious_rate"] == 50.0
    assert summary.loc["A", "death_rate"] == 50.0
    assert summary.loc["B", "hospitalisation_rate"] == 100.0


def test_reporting_odds_ratio_and_interval() -> None:
    result = reporting_odds_ratio(20, 80, 10, 90)
    assert result["ror"] == pytest.approx(2.25)
    assert result["ci_low"] < result["ror"] < result["ci_high"]


def test_quality_report_rejects_missing_schema() -> None:
    with pytest.raises(ValueError, match="Missing required columns"):
        validate_reports(pd.DataFrame({"drug_name": ["A"]}))
