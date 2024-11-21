
```
ssh-keygen -t rsa -b 4096
```
ENTER ENTER

The key is in C:\Users\jacka\.ssh\id_rsa.pub , copy it.

```
ssh giacomo@192.168.1.10
```
Again in Doilua
```
mkdir -p ~/.ssh
chmod 700 ~/.ssh
vim ~/.ssh/authorized_keys
```
paste the key
```
chmod 600 ~/.ssh/authorized_keys
```