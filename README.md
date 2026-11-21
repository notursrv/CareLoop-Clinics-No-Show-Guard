# CareLoop Clinics – No-Show Guard

A data analytics and machine-learning project that examines missed clinic appointments, analyses clinic-level patterns, scores appointment no-show risk, and explores patient follow-up notes with a GenAI workflow.

## Project status

The supplied project archive contains the processed datasets, SQL scripts, rejected-row log, test risk scores, and GenAI notes output. **The source notebooks and original raw input files were not present in the uploaded archive**, so they are not fabricated or represented as completed files here. See [Repository completeness](#repository-completeness).

## Verified results

The following values were calculated from the files included in this repository:

| Measure | Verified result |
|---|---:|
| Cleaned appointments | 990 |
| Clinics | 8 |
| No-show appointments | 218 |
| Overall no-show rate | 22.02% |
| Test risk-score records | 198 |
| Test ROC-AUC from `test_risk_scores.csv` | 0.789 |
| Test recall at the saved flag threshold | 0.571 |
| Flagged test records | 49 |

The project run previously recorded Logistic Regression as the selected model and a classification threshold of **0.35**. The AUC and recall above are independently recomputed from the supplied test-score file.

### GenAI output quality warning

`notes_analysed.csv` contains 10 note records. Its saved validation statuses are:

- `invalid`: 9
- `skipped_blank`: 1

The supplied output therefore does **not** contain validated root-cause classifications for the nonblank notes. Do not present those notes as successful GenAI findings. Re-run the GenAI analysis after checking the API/model response and Pydantic validation.

## Repository contents

| File | Purpose |
|---|---|
| `appointments_clean.csv` | Cleaned appointment dataset (990 rows) |
| `clinics_enriched.csv` | Clinic reference data with weather enrichment (8 rows) |
| `rejected_rows.json` | Rejected records from the ingestion/validation stage |
| `load_data.sql` | SQL data-loading script |
| `02_queries.sql` | SQL analytics queries |
| `test_risk_scores.csv` | Test-set labels, risk probabilities and flags |
| `notes_analysed.csv` | GenAI note-analysis output and validation status |
| `requirements.txt` | Python dependencies |
| `.gitignore` | Excludes local/runtime files and secrets |

## Repository completeness

The uploaded ZIP did not include these assignment/source files:

- `01_ingest_clean.ipynb`
- `03_model.ipynb`
- `04_genai.ipynb`
- Original raw input CSV files under `data/`
- `followup_notes.csv` as a separate raw input file
- `notes_appointments_merged.csv`

They are intentionally not replaced with empty or invented files. Add the actual completed notebooks and original input files from Google Drive/Colab before treating this as the complete assignment submission. If your assignment requires all notebooks at the repository root, keep the exact filenames listed above.

## Workflow overview

1. **Ingestion and cleaning:** validate source appointment rows, separate rejected records, clean missing/outlier values, and generate `appointments_clean.csv`.
2. **Clinic enrichment:** enrich clinic records with weather information and save `clinics_enriched.csv`.
3. **SQL analytics:** load clinic and appointment data using `load_data.sql`, then run the analyses in `02_queries.sql`.
4. **Machine learning:** train and evaluate no-show prediction models, then export test probabilities and risk flags to `test_risk_scores.csv`.
5. **GenAI analysis:** classify patient follow-up notes into operational root-cause categories, validate structured responses, and save `notes_analysed.csv`.

## Setup

Python 3.10 or newer is recommended.

```bash
python -m venv .venv
```

Activate the environment:

**Windows**
```bash
.venv\\Scripts\\activate
```

**macOS/Linux**
```bash
source .venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

The original notebooks are required to reproduce the full workflow and are not included in the uploaded source archive.

## SQL

`load_data.sql` is the supplied data-loading script. Run it against the database engine expected by your project setup. `02_queries.sql` contains the analysis queries. The duplicate-primary-key test is included as part of the SQL task workflow.

## GenAI API key safety

- Never commit API keys, `.env` files, credentials, or notebook outputs containing secrets.
- Read the Gemini API key at runtime or from an environment variable.
- If a key was ever exposed in a notebook or repository, revoke it and generate a new one.
- Review notebook outputs before publishing.

## Important interpretation limits

- The test metrics describe the supplied held-out test file, not guaranteed future clinic performance.
- The GenAI sample contains only 10 notes, and the supplied validation results show that nine were marked invalid.
- Observational appointment data can show associations; it does not by itself establish causes.

## License

No license has been specified. Add a license only after deciding how you want others to reuse this project.
