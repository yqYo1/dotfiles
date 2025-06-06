DOTDIR=$(cd $(dirname $0)/../;pwd)
if [ $(uname -o) = "GNU/Linux" ]; then
  $DOTDIR/setupScripts/setup.sh
elif [ $(uname -o) = "Msys" ]; then
  # Linuxはsetup.shでリンクする為不要
  ln -sfnv $DOTDIR/git-hook/post-merge $DOTDIR/.git/hooks/post-merge
  $DOTDIR/aquaproj-aqua/update.sh
fi
