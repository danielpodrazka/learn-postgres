from dotenv import load_dotenv
import os
import logging
import shutil


def logger_init(name):
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)

    if not logger.handlers:
        handler = logging.StreamHandler()
        handler.setLevel(logging.INFO)
        logger.addHandler(handler)

    return logger


logger = logger_init(__name__)


def env_init():
    load_dotenv(".env")
    if "DBUSER" not in os.environ:
        logger.info("Creating .env file using .env.devcontainer file")
        shutil.copy(".env.devcontainer", ".env")
        load_dotenv(".env")


def database_uri():
    dbuser = os.environ["DBUSER"]
    dbpass = os.environ["DBPASS"]
    dbhost = os.environ["DBHOST"]
    dbname = os.environ["DBNAME"]
    database_uri = f"postgresql://{dbuser}:{dbpass}@{dbhost}/{dbname}"
    return database_uri
