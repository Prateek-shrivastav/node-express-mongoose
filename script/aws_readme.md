```
********************************************
*     Steps for run bash script            *
*                                          *
********************************************
```
```
*********************************************
Before run sript you must install all these
*********************************************

1.  Install terraform terraform_0.11.14
            
2.  Install ansible 3.0

3.  Install python 3.0

4.  Install pip3Script will run using following command:-
```
```sh
5.cd script 
```
```sh
2.bash aws_script.sh  -a <aws_access_key> -s <aws_secret_key> -l <ssh_key_name_in_aws_account> -r <region> -p < private_key >
```

```sh

Note:- It required 'private_key' key to access bastion instance in the following path(name fixed):-  ~/.ssh/private_key
```
