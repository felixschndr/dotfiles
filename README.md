# bashrc
These are my personal bash aliases and functions I use on a daily basis


## Installation

1. Pull the git repository

2. Add this to `.bash_profile` or `.bashrc`
```bash
repo_location="/home/.../bashrc/" #Change this accordingly

# Iterate over all files and source them
# `sed` is used in cased the path contains a space
for file in $(find "$repo_location"/{default,$(hostname)} -type f 2>/dev/null | sed 's/ /}/g'); do
    file=$(echo $file | sed 's/}/ /g')
    source "$file"
done
```

3. Add this to your `crontab` with `crontab -e`
```bash
*/10 * * * * cd /home/$USER/bashrc/ && git pull || echo -e "There was a problem with the update of the bashrc repo!"

@reboot cd /home/$USER/bashrc/ && git pull || echo -e "There was a problem with the update of the bashrc repo!"
```

4. Get the git command prompt if it is not present
```bash
curl -o ~/.git-prompt.sh "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
echo "source ~/.git-prompt.sh" >> ~/.bashrc
```

5. **Enjoy**