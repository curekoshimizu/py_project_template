#!/usr/bin/env python

from pathlib import Path

import click

_NAME_DEFAULT = "curekoshimizu"
_EMAIL_DEFAULT = "45332899+curekoshimizu@users.noreply.github.com"


_ASSET_DIR = Path(__file__).parents[1] / "assets"

assert _ASSET_DIR.is_dir(), f"Asset directory '{_ASSET_DIR}' does not exist"


def _copy_file(src: Path, dest: Path, project_name: str, author: str, email: str) -> None:
    assert src.exists(), f"Source file '{src}' does not exist"
    with open(src) as src_file, open(dest, mode="w") as dst_file:
        for line in src_file:
            line = line.replace("__PROJECT_NAME__", project_name)
            line = line.replace("__AUTHOR_NAME__", author)
            line = line.replace("__AUTHOR_EMAIL__", email)
            dst_file.write(line)


def create_project(project_name: str, author: str, email: str, project_root: Path) -> None:
    """
    Create a new project with the given name and author.
    """
    if not project_root.exists():
        project_root.mkdir(parents=True)

    # copy files
    _copy_file(_ASSET_DIR / "setup.cfg", project_root / "setup.cfg", project_name, author, email)
    _copy_file(_ASSET_DIR / "pyproject.toml", project_root / "pyproject.toml", project_name, author, email)
    _copy_file(_ASSET_DIR / "Taskfile.yaml", project_root / "Taskfile.yaml", project_name, author, email)

    # create package directory
    target_dir = project_root / project_name
    if not target_dir.exists():
        target_dir.mkdir(parents=True)
    (target_dir / "__init__.py").touch()
    (target_dir / "py.typed").touch()


@click.command()
@click.option("--project_name", prompt=True, help="Project name")
@click.option("--author", prompt=True, default=_NAME_DEFAULT, help="Author name")
@click.option("--email", prompt=True, default=_EMAIL_DEFAULT, help="Author email")
@click.option("--path", prompt=True, default=Path.cwd(), type=Path, help="Project directory path")
def main(project_name: str, author: str, email: str, path: Path) -> None:
    path = path.absolute()
    click.echo(f"Creating project '{project_name}' by '{author}' ('{email}') in '{path}'")
    create_project(project_name, author, email, path / project_name)
    click.echo("Done.")


if __name__ in "__main__":
    main()
