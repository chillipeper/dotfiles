import logging
import shutil
import os
import time
import sys

from pathlib2 import Path

logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

HOME_DIR = os.environ['HOME']
BACKUP_DIR = HOME_DIR + '/.backup_dotfiles'


def get_dotfiles():
    p = Path(sys.argv[0])
    ignore_files = ['.git', '.gitignore', '.ropeproject', 'install.py']
    return [x for x in p.parent.iterdir()
            if x.is_file() and x.name not in ignore_files]


def backup_existing_dotfile(dotfile_in_home):
    dotile_backup = Path(
        BACKUP_DIR + '/' + dotfile_in_home.name + '.' + str(int(time.time()))
    )
    if dotfile_in_home.exists():
        if dotfile_in_home.is_symlink():
            logging.warning("Removing %s from %s", dotfile_in_home.name, HOME_DIR)
            dotfile_in_home.unlink()
        else:
            logging.info(
                "Moving %s from %s to %s", dotfile_in_home.name, HOME_DIR, BACKUP_DIR
            )
            shutil.move(
                str(dotfile_in_home.absolute()), str(dotile_backup.absolute())
            )
    else:
        logging.warning("%s does not exist", dotfile_in_home.name)


def create_backup_directory():
    p = Path(BACKUP_DIR)
    if not p.exists():
        logging.warning(
            " %s does not exist in home directory. Creating it.", p.name
        )
        p.mkdir()
    else:
        logging.info("Found %s in home directory", p.name)


def link_dotfile(dotfile_in_home, dotfile):
    dotfile_in_home.symlink_to(dotfile.absolute())
    logging.info(
        "Linking %s in home directory to %s",
        dotfile_in_home.absolute(), dotfile.absolute()
    )

def main():
    create_backup_directory()
    for dotfile in get_dotfiles():
        dotfile_in_home = Path(HOME_DIR + '/' + dotfile.name)
        backup_existing_dotfile(dotfile_in_home)
        link_dotfile(dotfile_in_home, dotfile)


if __name__ == "__main__":
    main()
