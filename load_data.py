from sqlalchemy import create_engine
import pandas as pd
import os
import re
from utils import logger_init, env_init, database_uri


logger = logger_init(__name__)
env_init()


def get_table_columns(df_cols: list[str], existing_cols: set[str] = set()):
    sanitized_cols = []
    for col in df_cols:
        # Replace whitespace with a single underscore and remove non-alphanumeric characters except underscores
        col = re.sub(r"\W+", "_", col.lower())

        # Remove leading and trailing underscores
        col = re.sub(r"^_|_$", "", col)

        # Add underscore prefix if the column starts with a number
        col = re.sub(r"^(\d)", r"_\1", col)

        # Add suffix if the column already exists
        suffix = 1
        new_col = col
        while new_col in existing_cols:
            new_col = f"{col}_{suffix}"
            suffix += 1

        sanitized_cols.append(new_col)
        existing_cols.add(new_col)

    return sanitized_cols


def load_data(csv_filename: str = "yt_comments_data.csv"):
    tablename = os.path.splitext(csv_filename)[0]
    df = pd.read_csv(os.path.join("data", csv_filename))
    logger.info(f"Loaded {csv_filename=} into a Dataframe:")
    logger.info(df.info())
    df.columns = get_table_columns(df.columns)
    logger.info(f"Renamed columns to: {[c for c in df]}")
    db = create_engine(database_uri())
    logger.info(f"Loading {csv_filename=} into the database...")
    with db.connect() as conn:
        logger.info("Connected to the DB.")
        df.to_sql(tablename, conn, if_exists="replace", method="multi")
    logger.info(f"Successfully loaded {csv_filename=} into {tablename=}")


def get_csv_files():
    data_dir = "data"
    csv_files = [f for f in os.listdir(data_dir) if f.endswith(".csv")]
    return csv_files


def display_csv_files(csv_files):
    available_files_msg = "Available CSV files:"
    ascii_line = len(available_files_msg) * "-"
    print(ascii_line)
    print(available_files_msg)
    print(ascii_line)
    for i, file in enumerate(csv_files, start=1):
        print(f"[{i}] {file}")
    print()


def get_user_choice(csv_files):
    while True:
        try:
            choice = int(input("Enter the number of the file to load: "))
            if 1 <= choice <= len(csv_files):
                return csv_files[choice - 1]
            else:
                print("Invalid choice. Please try again.")
        except ValueError:
            print("Invalid input. Please enter a valid number.")


if __name__ == "__main__":
    csv_files = get_csv_files()
    display_csv_files(csv_files)
    selected_file = get_user_choice(csv_files)
    load_data(selected_file)
