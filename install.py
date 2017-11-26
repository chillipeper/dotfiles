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


def backup(dotfile):
    dotile_backup = Path(
        BACKUP_DIR + '/' + dotfile.name + '.' + str(int(time.time()))
    )
    if dotfile.is_file() and not dotfile.is_symlink():
        logging.info(
            "Copying %s from %s to %s",
            dotfile.name, HOME_DIR, BACKUP_DIR
        )
        shutil.copyfile(
            dotfile.absolute(), dotile_backup.absolute()
        )
    else:
        logging.warning(
            "%s does not seem to be a regular file and will not be backed up",
            dotfile.absolute()
        )


def create(directory):
    p = Path(directory)
    if not p.exists():
        logging.warning(
            " %s does not exist in home directory. Creating it.", p.name
        )
        p.mkdir()
    else:
        logging.info("Found %s in home directory", p.name)


def remove(dotfile):
    if dotfile.is_file():
        logging.warning(
            "Removing %s from %s", dotfile.name, HOME_DIR
        )
        dotfile.unlink()
    else:
        logging.error(
            "%s is not a regular file, can not delete it",
            dotfile.absolute()
        )


def link(target, source):
    target.symlink_to(source.absolute())
    logging.info(
        "Linking %s in home directory to %s",
        target.absolute(), source.absolute()
    )


def main():
    create(BACKUP_DIR)
    for dotfile_in_repo in get_dotfiles_in_repo():
        dotfile_in_home = Path(HOME_DIR + '/' + dotfile_in_repo.name)
        if dotfile_in_home.exists():
            backup(dotfile_in_home)
            remove(dotfile_in_home)
        link(dotfile_in_home, dotfile_in_repo)


if __name__ == "__main__":
    main()
