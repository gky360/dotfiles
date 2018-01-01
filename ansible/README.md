# dotfiles ansible

## Usage

```
cd ~/dotfiles/ansible
curl https://raw.githubusercontent.com/gky360/dotfiles/master/ansible/init.sh | sh
HOMEBREW_CASK_OPTS="--appdir=/Applications" ansible-playbook -vK -i inventory playbook.yml
```
