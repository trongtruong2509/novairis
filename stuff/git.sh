# view global config
git config --global --list

git config --global user.email "your_email@abc.example"
git config --global user.name "your name"

# set vim as default editor
git config core.editor "vim"

# Run the following command to change the author and email for the most recent commit:
git commit --amend --author="New Author Name <new.email@example.com>"