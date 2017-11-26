import logging
import shutil
import os
import time
import sys

from pathlib2 import Path

logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

HOME_DIR = os.environ['HOME']
BACKUP_DIR = HOME_DIR + '/.backup_dotfiles'


def get_dotfiles_in_repo():
    p = Path(sys.argv[0])
    ignore_files = ['.git', '.gitignore', '.ropeproject', 'install.py']
    return [x for x in p.parent.iterdir()
            if x.is_file() and x.name not in ignore_files]


def backup_existing_dotfile(dotfile_in_home):
    dotile_backup = Path(
        BACKUP_DIR + '/' + dotfile_in_home.name + '.' + str(int(time.time()))
    )
    if dotfile_in_home.is_file() and not dotfile_in_home.is_symlink():
        logging.info(
            "Copying %s from %s to %s",
            dotfile_in_home.name, HOME_DIR, BACKUP_DIR
        )
        shutil.copyfile(
            dotfile_in_home.absolute(), dotile_backup.absolute()
        )
    else:
        logging.warning(
            "%s does not seem to be a regular file and will not be backed up",
            dotfile_in_home.absolute()
        )


def create_backup_directory():
    p = Path(BACKUP_DIR)
    if not p.exists():
        logging.warning(
            " %s does not exist in home directory. Creating it.", p.name
        )
        p.mkdir()
    else:
        logging.info("Found %s in home directory", p.name)

def remove_dotfile_in_home(dotfile_in_home):
    if dotfile_in_home.is_file():
        logging.warning(
            "Removing %s from %s", dotfile_in_home.name, HOME_DIR
        )
        dotfile_in_home.unlink()
    else:
        logging.error(
            "%s is not a regular file, can not delete it",
            dotfile_in_home.absolute()
        )

def link_dotfile(dotfile_in_home, dotfile):
    dotfile_in_home.symlink_to(dotfile.absolute())
    logging.info(
        "Linking %s in home directory to %s",
        dotfile_in_home.absolute(), dotfile.absolute()
    )

def main():
    create_backup_directory()
    for dotfile_in_repo in get_dotfiles_in_repo():
        dotfile_in_home = Path(HOME_DIR + '/' + dotfile_in_repo.name)
        if dotfile_in_home.exists():
            backup_existing_dotfile(dotfile_in_home)
            remove_dotfile_in_home(dotfile_in_home)
        link_dotfile(dotfile_in_home, dotfile_in_repo)


if __name__ == "__main__":
    main()
