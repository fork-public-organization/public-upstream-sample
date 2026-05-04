# 0-prep: Run the commands below line by line; do not execute this file as a script.
# Copy each command into your terminal in order, and verify the output before moving on.

# 0-1. Install GH CLI (Confirm that the version is 2.4.0 or higher)
# See https://github.com/cli/cli/blob/trunk/docs/install_linux.md for other distros.
sudo apt-get install -y wget
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
sudo apt-get update
sudo apt-get install -y gh

# Verify gh version is >= 2.4.0
gh --version

# 0-2. Install jq for JSON parsing
sudo apt-get install -y jq

# Verify jq is installed
jq --version
