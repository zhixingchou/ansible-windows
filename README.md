![ansible](https://github.com/qwsj/ansible-windows/blob/master/files/ans-logo.png?raw=true)

#### Ansible playbooks for windows

More info about ansible for windows: [Ansible windows modules list](http://docs.ansible.com/ansible/latest/list_of_windows_modules.html)


##### # Tested on:
Ansible: ansible 2.4.0.0 with winrm module

Client: Windows Server 2012 R2

##### # WinRM module for ansible:
```
pip install https://github.com/diyan/pywinrm/archive/master.zip#egg=pywinrm
```
##### # Activate WinRM module in Windows: 
```
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://github.com/ansible/ansible/raw/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))"
```



##### # How to use:
```
ansible-playbook -i inventory [playbook] --ask-pass
```
