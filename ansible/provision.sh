SCRIPT_DIR=$(dirname "$0")
cd $SCRIPT_DIR
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
ansible-galaxy install -r requirements.yml
ansible-playbook -v -K -i hosts playbook.yml
