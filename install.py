import logging
import shutil
import os
import time
import sys

from pathlib import Path

logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

HOME_DIR = os.environ['HOME']
BACKUP_DIR = HOME_DIR + '/.backup_dotfiles'
IGNORE_FILES = ['.git', '.gitignore', '.ropeproject', '.pyre', 'install.py',
                '.mypy_cache', 'PipFile', 'Pipfile.lock', 'README.md']


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
        logging.info(
            "%s does not seem to be a regular file and will not be backed up",
            dotfile.absolute()
        )


def create(directory):
    p = Path(directory)
    if not p.exists():
        logging.info(
            " %s does not exist. Creating it.", p
        )
        p.mkdir()
    else:
        logging.info("Found %s in home directory", p.name)


def remove(dotfile):
    if dotfile.is_file():
        logging.info(
            "Removing %s from %s", dotfile.name, dotfile.parent
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


def get_dotfiles_in_repo(path, dotfiles_in_repo=[]):
    p = Path(path)
    for dotfile in p.iterdir():
        if dotfile.name not in IGNORE_FILES:
            if dotfile.is_file():
                dotfiles_in_repo.append(dotfile)
            elif dotfile.is_dir():
                get_dotfiles_in_repo(dotfile)
    return dotfiles_in_repo


def main():
    create(BACKUP_DIR)
    p = Path(sys.argv[0])
    repo_absolute_path = p.parent.absolute()
    for dotfile_in_repo in get_dotfiles_in_repo(repo_absolute_path):
        dotfile_in_home = Path(
            str(dotfile_in_repo).replace(str(repo_absolute_path), HOME_DIR)
        )
        if dotfile_in_home.exists():
            backup(dotfile_in_home)
            remove(dotfile_in_home)
        elif not dotfile_in_home.parent.exists():
            create(dotfile_in_home.parent)
        link(dotfile_in_home, dotfile_in_repo)


if __name__ == "__main__":
    main()
