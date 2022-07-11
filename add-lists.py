#!/usr/bin/env python3

"""
    Adds list in adlist.txt to pihole
"""

import subprocess
import logging
import sys

ADLIST_FILE = "adlist.txt"
PIHOLE_CONTAINER = "pihole-01"
READ_MODE = "r"
adlist_arr1 = []

logging.basicConfig(level=logging.INFO, format='[ %(levelname)s ] %(message)s')

print(f"Adding adlists to {PIHOLE_CONTAINER}...")

class Adlist:
    """
    Creates an array from entries in adlists.txt
    Injects array into DB
    """
    def __init__(self, adfile: str, mode: str, arr: list):
        self.adfile = adfile
        self.mode = mode
        self.arr = arr

    def ad_list(self) -> list:
        with open(self.adfile, self.mode) as f:
            for i in f:
                self.arr.append(i.strip("\n"))
        return self.arr

    @staticmethod
    def add_to_pihole(new_adlists: list, container: str) -> str:
        for adlist in new_adlists:
            sql_insert = f'INSERT INTO adlist (address, enabled, comment) VALUES ("{adlist}", 1, "python <3");'

            # Populate sqllite3 db with lists from adlist.txt
            inject = subprocess.Popen(
                [
                    "docker",
                    "exec",
                    "-it",
                    container,
                    "sqlite3",
                    "/etc/pihole/gravity.db",
                    sql_insert
                ],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )

            if inject.wait() != 0 and inject.wait() != 19:
                logging.error(f'could not inject to DB - {adlist}')
                logging.error(inject.stderr.read())
                sys.exit(inject.returncode)
            else:
                logging.info(f'added entry to DB - {adlist}')

        # Update Gravity to pull down the lists 
        update = subprocess.run(
            [
                "docker", 
                "exec", 
                "-it", 
                container, 
                "pihole",
                "-g"
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )

        if update.returncode != 0:
            logging.error(f'could not update Gravity - err code: {update.returncode}')
            logging.error(update.stderr)
        else:
            logging.info(f'updated Gravity')
        
        
def main():
    l1 = Adlist(ADLIST_FILE, READ_MODE, adlist_arr1)
    new_list = l1.ad_list()
    Adlist.add_to_pihole(new_list, PIHOLE_CONTAINER)

if __name__ == "__main__":
    try:
        main()
    except Exception as err:
        logging.error(err)
