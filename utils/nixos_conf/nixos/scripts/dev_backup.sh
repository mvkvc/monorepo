cd $HOME/dev
for f in *; do
    if [ -d "$f" ]; then
        echo $f
        cd $f
        git add -A && git commit -m "Auto-save" && git push
        cd ..
    fi
done
