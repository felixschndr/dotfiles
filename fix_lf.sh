for file in $(dirname $"0") -maxdepth 1 -type f 2>/dev/null); do
    echo $file
done