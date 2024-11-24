## Install brew and k9s
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

 echo >> /home/giacomo/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/giacomo/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew install gcc
brew install derailed/k9s/k9s
sudo apt install clang
brew install --build-from-source k9s

microk8s config
(copy output)

cd
cd .kube/
vim config
(paste output)