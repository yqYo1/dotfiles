DOTDIR=$(cd $(dirname $0)/../;pwd)
read -p "Do you want to update environment? [y/N] " yn
case "yn" in
  [Yy]|[Yy][Ee][Ss])
    echo "Updating environment..."
    if [ $(uname -o) = "GNU/Linux" ]; then
      $DOTDIR/setupScripts/setup.sh
    elif [ $(uname -o) = "Msys" ]; then
      # Linuxはsetup.shでリンクする為不要
      ln -sfnv $DOTDIR/git-hook/post-merge $DOTDIR/.git/hooks/post-merge
      $DOTDIR/aquaproj-aqua/update.sh
    fi
    ;;
  [Nn]|[Nn][Oo]|"")
    echo "Skipping environment update."
    ;;
  *)
    echo "Invalid input."
    ;;
esac
