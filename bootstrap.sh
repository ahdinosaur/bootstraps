echo "installing git if not already installed"
aptitude install -y git

echo "cloning bootstrap repo"
git clone https://github.com/ahdinosaur/bootstraps

echo "executing install.sh"
cd "bootstraps"
chmod +x install.sh
./install.sh
