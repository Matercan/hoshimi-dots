# --- Configuration ---
# Your dotfiles repository root (where stow is run from)
DOTFILES_ROOT="$HOME/.mater_dotfiles"
# The common subdirectory inside a package that mirrors ~/.config
# For example, if you want symlinks like ~/.config/hypr -> ~/.mater_dotfiles/hypr/.config/hypr
CONFIG_SUBDIR=".config"


# --- Argument Parsing ---
if [ -z "$1" ]; then
    echo "Usage: $0 <package_name>"
    echo "Example: $0 hypr"
    echo "This script reorganizes a dotfile package from '$DOTFILES_ROOT/<package_name>/'"
    echo "to '$DOTFILES_ROOT/<package_name>/$CONFIG_SUBDIR/<package_name>/'."
    exit 1
fi

PACKAGE_NAME="$1"
PACKAGE_DIR="$DOTFILES_ROOT/$PACKAGE_NAME"
STOW_TARGET_DIR="$PACKAGE_DIR/$CONFIG_SUBDIR/$PACKAGE_NAME"

# --- Pre-checks ---
if [ ! -d "$PACKAGE_DIR" ]; then
    echo "Error: Package directory '$PACKAGE_DIR' does not exist."
    exit 1
fi

# Check if the target structure already exists and if the source is already organized
if [ -d "$STOW_TARGET_DIR" ] && [ "$(ls -A "$STOW_TARGET_DIR" | wc -l)" -gt 0 ]; then
    echo "Warning: Target directory '$STOW_TARGET_DIR' already exists and is not empty."
    echo "It seems like this package might already be organized, or contains files."
    echo "Please check manually before proceeding. If you proceed, existing files might be overwritten."
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# --- Reorganization Logic ---
echo "Reorganizing '$PACKAGE_NAME' dotfile package..."
echo "Source: $PACKAGE_DIR/"
echo "Target structure: $STOW_TARGET_DIR/"

# Create the full nested target directory structure if it doesn't exist
mkdir -p "$STOW_TARGET_DIR" || { echo "Error: Failed to create target directory '$STOW_TARGET_DIR'. Check permissions."; exit 1; }

# Navigate to the package directory to perform the move
cd "$PACKAGE_DIR" || { echo "Error: Failed to change directory to '$PACKAGE_DIR'. Exiting."; exit 1; }

# Move all files and subdirectories (except the .config directory itself)
# into the .config/<package_name>/ subdirectory
for item in *; do
    # Skip the .config directory as it's part of the new structure
    # Also skip if the item is the target_subdir itself to avoid moving it into itself if script is re-run
    if [ "$item" != "$CONFIG_SUBDIR" ] && [ "$item" != "$PACKAGE_NAME" ]; then
        echo "Moving '$item' to '$STOW_TARGET_DIR/'"
        mv "$item" "$STOW_TARGET_DIR/" || { echo "Warning: Failed to move '$item'. Skipping."; }
    fi
done

echo "Reorganization complete for '$PACKAGE_NAME'."
echo "You can now run 'cd $DOTFILES_ROOT && stow $PACKAGE_NAME/'"
