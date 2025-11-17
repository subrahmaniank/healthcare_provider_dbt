<file_path>
healthcare_provider_dbt\README.md
</file_path>

<edit_description>
Update README.md with project details and setup instructions
</edit_description>

# Healthcare Provider DBT Project Structure

This is a dbt (Data Build Tool) project designed to manage the ETL workflow for healthcare provider data analysis.

## Project Overview

The project focuses on transforming and modeling healthcare datasets using dbt. The setup utilizes `dbt-core` along with `dbt-duckdb` for processing.

## Project Structure

- **healthcare_provider_dbt/**: Root directory containing all project files.
  - **provider_example/**: Main dbt project folder encompassing:
    - **analyses**: Custom analyses scripts.
    - **logs**: Log files generated during dbt runs.
    - **macros**: Reusable macros for dbt.
    - **models**: Core dbt models for data transformation.
    - **seeds**: Static data seeds for tests and samples.
    - **snapshots**: Data snapshots for historical compliance.
    - **target**: Compiled project files.
    - **tests**: Tests ensuring data quality and accuracy.
  - Additional configuration and environment setup files.

## Prerequisites

- Python 3.12 or later
- dbt-core >= 1.10.15
- dbt-duckdb >= 1.10.0

## Installation and Setup

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd healthcare_provider_dbt
   ```

2. **Setup Environment with `uv` in the Root Directory**:
   Ensure you have `uv` installed on your system. If not, you can install it using one of the following methods:
   ```bash
   # Using standalone installer:
   On macOS and Linux, use `curl`:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

   Or use `wget`:
   ```bash
   wget -qO- https://astral.sh/uv/install.sh | sh
   ```

   On Windows, use PowerShell:
   ```bash
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
   ```

   # Alternative methods:
   - **PyPI**: For isolated environments, we recommend:
     ```bash
     pipx install uv
     ```
     Or use `pip` directly:
     ```bash
     pip install uv
     ```
        Make sure `dbt` and `duckdb` stay within the same root to maintain organization and isolation.

   - **Homebrew**:
     ```bash
     brew install uv
     ```
   
   - **WinGet**:
     ```bash
     winget install --id=astral-sh.uv -e
     ```

   - **Scoop**:
     ```bash
     scoop install main/uv
     ```

   # Note
   `uv` ships with prebuilt distributions for many platforms; if unavailable, it'll require building from source with a Rust toolchain.
   ```

3. **Use `uv` to Create Environment and Install Dependencies**:
   Run the following command to initialize your environment and install dependencies as specified in `pyproject.toml`:
   ```bash
   uv new
   ```

4. **Ensure Configuration**:
   - Update the `profile` settings in `dbt_project.yml` within the `provider_example` directory.
   - Ensure that your `profiles.yml` in the `.dbt` directory is correctly configured to reflect your environment settings.

5. **Seed the Data**:
   Use the following command to seed the data from the specified seed files:
   ```bash
   dbt seed
   ```

6. **Run dbt**:
   ```bash
   dbt run
   ```

## Adding Data to Seed Files

1. **Locate the Seeds Directory**:
   - Navigate to the `seeds` directory within your dbt project. For this project, it is located at:
     ```
     healthcare_provider_dbt/provider_example/seeds
     ```

2. **Create or Edit CSV Files**:
   - Seed files are typically CSV files. You can create new CSV files or edit existing ones to include the data you want to seed. 

3. **Format Your CSV Files**:
   - Ensure your CSV files are well-structured:
     - The first row should contain the column headers.
     - Subsequent rows should contain the data entries corresponding to each column header.

4. **Example**:
   Suppose you have a seed file named `patients.csv`. It should be structured as follows:
   ```csv
   id,name,age,gender,condition
   1,John Doe,45,M,Hypertension
   2,Jane Smith,37,F,Diabetes
   ```

5. **Save the Seed Files**:
   - After adding or updating the data, make sure to save the CSV files in the `seeds` directory.

6. **Run dbt Seed**:
   - Once your seed files are ready and saved, execute the `dbt seed` command to load the data into your database tables:
     ```bash
     dbt seed
     ```

### Additional Tips

- **Column Types**: Be mindful of the data types for each column to ensure consistency and avoid loading errors.
- **Version Control**: Track changes in your seed files using version control to maintain data integrity and history.
- **Review Data**: Before running the seed command, review your data for any inconsistencies or missing entries.

## Additional Information

- **Project Configuration**: The dbt project is named `provider_example` and is versioned at 1.0.0.
- **Profiles**: Ensure a `profiles.yml` is available in your `.dbt` directory reflecting the configuration as specified.

## Contribution

Feel free to open issues or create pull requests with suggested improvements or fixes.

---

This README.md serves as an entry point for understanding and operating the dbt setup within the healthcare provider data analysis project.