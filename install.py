import logging
import shutil
import os
import time

from pathlib2 import Path

logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

HOME_DIR = os.environ['HOME']
BACKUP_DIR = HOME_DIR + '/.backup_dotfiles'


def get_dotfiles():
    p = Path('.')
    ignore_files = ['.git', '.gitignore', '.ropeproject', 'install.py']
    return [x for x in p.iterdir()
            if x.is_file() and x.name not in ignore_files]


def backup_existing_dotfile(file_name):
    dotfile_in_home = Path(HOME_DIR + '/' + file_name)
    dotile_backup = Path(
        BACKUP_DIR + '/' + file_name + '.' + str(int(time.time()))
    )
    if dotfile_in_home.exists():
        if dotfile_in_home.is_symlink():
            logging.warning("Removing %s from %s", file_name, HOME_DIR)
            dotfile_in_home.unlink()
        else:
            logging.info(
                "Moving %s from %s to %s", file_name, HOME_DIR, BACKUP_DIR
            )
            shutil.move(
                str(dotfile_in_home.absolute()), str(dotile_backup.absolute())
            )
    else:
        logging.warning("%s does not exist", file_name)


def create_backup_directory():
    p = Path(BACKUP_DIR)
    if not p.exists():
        logging.warning(
            " %s does not exist in home directory. Creating it.", p.name
        )
        p.mkdir()
    else:
        logging.info("Found %s in home directory", p.name)


def link_dotfile():
    pass


def main():
    create_backup_directory()
    for dotfile in get_dotfiles():
        backup_existing_dotfile(dotfile.name)
        link_dotfile()


if __name__ == "__main__":
    main()
