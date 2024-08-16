# #!/bin/bash
#
# DIR=$(cd $(dirname "$0"); cd ..; pwd)
#
# pushd ${DIR} && poetry run python ./scripts/py_project_template.py ${@:1} && popd
#
#
#!/bin/bash

NAME_DEFAULT="curekoshimizu"
EMAIL_DEFAULT="45332899+curekoshimizu@users.noreply.github.com"

ASSET_DIR="$(dirname "$(dirname "$0")")/assets"

if [ ! -d "$ASSET_DIR" ]; then
    echo "Asset directory '$ASSET_DIR' does not exist"
    exit 1
fi

copy_file() {
    local src="$1"
    local dest="$2"
    local project_name="$3"
    local author="$4"
    local email="$5"

    if [ ! -f "$src" ]; then
        echo "Source file '$src' does not exist"
        exit 1
    fi

    sed -e "s/__PROJECT_NAME__/$project_name/g" \
        -e "s/__AUTHOR_NAME__/$author/g" \
        -e "s/__AUTHOR_EMAIL__/$email/g" \
        "$src" > "$dest"
}

create_project() {
    local project_name="$1"
    local author="$2"
    local email="$3"
    local project_root="$4"

    if [ ! -d "$project_root" ]; then
        mkdir -p "$project_root"
    fi

    # Copy files
    copy_file "$ASSET_DIR/setup.cfg" "$project_root/setup.cfg" "$project_name" "$author" "$email"
    copy_file "$ASSET_DIR/pyproject.toml" "$project_root/pyproject.toml" "$project_name" "$author" "$email"
    copy_file "$ASSET_DIR/Taskfile.yaml" "$project_root/Taskfile.yaml" "$project_name" "$author" "$email"
    copy_file "$ASSET_DIR/.gitignore" "$project_root/.gitignore" "$project_name" "$author" "$email"

    # Create package directory
    local target_dir="$project_root/$project_name"
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
    fi
    touch "$target_dir/__init__.py"
    touch "$target_dir/py.typed"
}

# Main
read -p "Enter the project path: " proj_path
read -p "Author name [$NAME_DEFAULT]: " author
read -p "Author email [$EMAIL_DEFAULT]: " email

author=${author:-$NAME_DEFAULT}
email=${email:-$EMAIL_DEFAULT}

project_path=$(realpath "$proj_path")
root=$(dirname "$project_path")
project_name=$(basename "$project_path")

echo "Target path: $root"
echo "Creating project '$project_name' by '$author' ('$email') in '$root/$project_name'"

create_project "$project_name" "$author" "$email" "$root/$project_name"

echo "Done."
