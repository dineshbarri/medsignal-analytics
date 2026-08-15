# Data dictionary

| Field | Meaning |
|---|---|
| `drug_name` | Normalized product used for the portfolio comparison |
| `serious_label` | Serious/non-serious report classification |
| `seriousnessdeath` | FAERS death outcome flag (`1` yes, `2` no) |
| `seriousnesshospitalisation` | Hospitalisation outcome flag |
| `seriousnessdisabling` | Disability outcome flag |
| `seriousnesslifethreatening` | Life-threatening outcome flag |
| `receive_date` | Date the report was received |
| `reporter_country` | Reporter country code when present |
| `patient_age` | Normalized patient age when present |
| `sex_label` | Normalized sex label |
| `age_group` | Derived age band |
| `year`, `month`, `quarter` | Calendar fields derived from receive date |

The included CSV is a portfolio analytical extract. Raw API responses are intentionally excluded to keep the repository focused and lightweight.
