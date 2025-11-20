# Cline Agent Rules for Project Setup

This file contains the rules and instructions to ensure consistent setup and management of the `healthcare_provider_dbt` project using the cline agent.

## Project Root Structure

- The root of the project is `healthcare_provider_dbt`.
- All dbt-related files and directories should reside under the `provider_example` subdirectory within the project root.
- No files should be placed arbitrarily outside these directories without proper documentation.

## Installation and Setup

1. **Repository Checkout**:
   - The repository should be cloned into the `healthcare_provider_dbt` directory.

2. **Environment Setup**:
   - Use `uv` as the package manager for all python environments and dependencies.
   - Installation methods for `uv` should align with the official Astral.sh documentation to ensure accuracy and compatibility.

3. **Virtual Environment Management**:
   - Environment initialization and dependency installations should strictly use `uv` to maintain consistency and reproducibility.

4. **Configurations**:
   - Ensure all project configuration files such as `dbt_project.yml` and `profiles.yml` are properly set up before running dbt commands.

5. **DBT Commands Execution**:
   - Perform `dbt seed` to load seed files before executing `dbt run`.

## Maintenance Guidelines

- Regularly update dependencies using `uv` to keep the project current.
- Track all configuration changes in version control for auditing and rollback purposes.

## Development Rules

1. Seed File Format Checks:
   - Before running dbt seed, check if any seed files (e.g., CSVs in the seeds/ directory) have changed in format, such as added/removed columns, changed data types, or modified headers.
   - To detect format changes:
      - Use version control (e.g., Git) to compare the current seed files with the previous commit: Run git diff HEAD~1 -- seeds/*.csv and inspect for header or structural changes.
      - Alternatively, use Python scripts (via uv run) to parse CSV headers and compare against a stored schema (e.g., in a seed_schemas.yml file).

   - If format changes are detected (e.g., mismatched columns), use dbt seed --full-refresh to drop and recreate the tables, ensuring schema consistency.
   - If no format changes, use the standard dbt seed command for efficiency.

2. Automation Integration:
   - Integrate these checks into CI/CD pipelines or pre-commit hooks to automate detection.
   - Document any detected changes and resolutions in the project logs or issues.

## Rules for Writing dbt Tests

Purpose: Ensure consistent, high-quality, and maintainable test coverage across the project. These rules apply to all models under provider_example/.

1) Placement and structure
- Schema tests: co-locate in schema.yml next to the models they validate (e.g., provider_example/models/stage/schema.yml, provider_example/models/core/schema.yml).
- Singular tests: place in provider_example/tests/ and keep one assertion per test file.
- Generic/custom tests: place Jinja tests in provider_example/macros/tests/ as reusable macros (test_<behavior>.sql).

2) Test types and when to use them
- Built-in schema tests: use not_null, unique, relationships, accepted_values for structural and referential integrity.
- Generic tests: use when the same assertion applies to 2+ models/columns (e.g., non_negative_amount, valid_date_range).
- Singular tests: use for complex logic that cannot be expressed as schema/generic tests (e.g., cross-model business rules, aggregate assertions).

3) Naming conventions
- Schema files: schema.yml co-located with models they test.
- Generic tests: provider_example/macros/tests/test_<short_behavior>.sql (e.g., test_non_negative_amount.sql).
- Singular tests: provider_example/tests/<model>__<behavior>.sql (e.g., member_claims_summary__no_negative_paid_amount.sql).
- Use clear descriptions (business-oriented) for every test.

4) Minimum coverage by layer
- Stage models (provider_example/models/stage/*):
  - Primary/business keys: not_null and unique where appropriate (e.g., member_id in stg_members if source guarantees uniqueness).
  - Foreign keys: relationships to parent tables (claims.member_id -> members.member_id; claims.provider_id -> providers.provider_id; claims.plan_id -> plans.plan_id).
  - Enumerations: accepted_values for known finite sets (e.g., plan_type, status).
- Core models (provider_example/models/core/*):
  - Preserve upstream constraints (keys, relationships).
  - Add business integrity checks (derived fields not null, non-negative aggregates, valid date ranges, deduplicated keys where required).

5) Authoring standards
- Prefer schema tests first; promote to generic test once used in multiple places.
- Keep singular tests focused: 1 assertion per file, select only the columns needed.
- Use tags and severity to control behavior by environment (dev warn, CI/prod error).

6) Severity and environment policy
- Default: critical integrity tests are severity: error; exploratory checks can be severity: warn in dev.
- You may parameterize severity via Jinja by environment, for example:

```
severity: "{{ 'warn' if target.name == 'dev' else 'error' }}"
```

7) Performance guidelines
- Avoid SELECT * in tests; project only required columns.
- Reuse ref() models and stable keys; use CTEs to minimize scanned data for singular tests.

8) Execution and CI
- Local development: prefer `dbt build` to run both models and tests; or `dbt test` for tests only.
- PR/CI scope: `dbt test --select state:modified+` to focus on impacted nodes.
- Fail-fast in CI: `dbt build --fail-fast`.
- Store failures: `tests: +store_failures: true` when adapter supports it.
- When seed format changes are detected (see Seed File Format Checks above), run: `dbt seed --full-refresh` then `dbt build` to ensure tests run against fresh schemas.

9) Change management
- New models must include schema.yml with key and relationship tests before merge.
- When modifying columns referenced by tests, update or deprecate tests in the same PR; document intentional exclusions with justification in schema.yml.

10) Examples
- Example schema.yml snippet (adjust model/column names as needed to match your models):

```yml
models:
  - name: stg_members
    description: Staged members
    tests: []
    columns:
      - name: member_id
        description: Primary key for members
        tests:
          - not_null
          - unique

  - name: stg_claims
    description: Staged claims
    columns:
      - name: claim_id
        tests: [not_null, unique]
      - name: member_id
        tests:
          - not_null
          - relationships:
              to: ref('stg_members')
              field: member_id
      - name: provider_id
        tests:
          - relationships:
              to: ref('stg_providers')
              field: provider_id
      - name: plan_id
        tests:
          - relationships:
              to: ref('stg_plans')
              field: plan_id
      - name: claim_status
        tests:
          - accepted_values:
              values: ["open", "closed", "denied"]
```

- Example singular test (provider_example/tests/member_claims_summary__no_negative_paid_amount.sql):

```sql
with invalid as (
    select claim_id, paid_amount
    from {{ ref('member_claims_summary') }}
    where paid_amount < 0
)
select count(*) as failures from invalid
```

- Example generic test macro (provider_example/macros/tests/test_non_negative_amount.sql):

```sql
{% test non_negative_amount(model, column_name) %}
select {{ column_name }}
from {{ model }}
where {{ column_name }} < 0
{% endtest %}
```

Usage in schema.yml:

```yml
columns:
  - name: paid_amount
    tests:
      - non_negative_amount
```

Notes
- All paths and references must live under provider_example/ to match this repository’s structure.
- For DuckDB and other adapters, adapter-specific behaviors (e.g., store_failures) may vary; prefer `dbt build` in CI for deterministic results.

## Additional Notes

- Always follow best practices for directory structures and naming conventions.
- Document any deviations or custom setups in the project documentation.

This clinerule file serves as a guideline for maintaining the setup standards and ensuring smooth project operation.
