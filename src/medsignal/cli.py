"""Command-line entry point for analyst-friendly profiling."""

from __future__ import annotations

import argparse
import json

import pandas as pd

from .analysis import outcome_summary
from .quality import validate_reports


def main() -> None:
    parser = argparse.ArgumentParser(prog="medsignal")
    subparsers = parser.add_subparsers(dest="command", required=True)
    profile = subparsers.add_parser("profile", help="validate and summarize a CSV extract")
    profile.add_argument("csv_path")
    args = parser.parse_args()

    frame = pd.read_csv(args.csv_path)
    print(json.dumps(validate_reports(frame), indent=2))
    print("\nOutcome summary (%)")
    print(outcome_summary(frame).to_string(index=False))


if __name__ == "__main__":
    main()
