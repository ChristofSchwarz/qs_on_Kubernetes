echo 'executing "docker.sh"'

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -qq -y update 
sudo apt-get -qq -y install docker-ce=18.06.0~ce~3-0~ubuntu 

curl -s -L https://github.com/docker/compose/releases/download/1.23.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo 'Installing Docker Machine'
curl -s -L https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

echo 'Installing socat'
sudo apt-get -q install socat -y 

sudo usermod -aG docker vagrant
sudo gpasswd -a vagrant docker
