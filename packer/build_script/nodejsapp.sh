echo "install package"
apt -y update
apt -y upgrade
apt -y install bash
echo "Go to application folder"
cd /nodejsapp
echo "install application dependency"
npm install