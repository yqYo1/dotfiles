DOTDIR=$(cd $(dirname $0)/../;pwd)
ln -sfnv $DOTDIR/git-hook/post-merge $DOTDIR/.git/hooks/post-merge
if [ $(uname -o) = "GNU/Linux" ]; then
  $DOTDIR/setupScripts/setup.sh
elif [ $(uname -o) = "Msys" ]; then
  $DOTDIR/aquaproj-aqua/update.sh
fi
