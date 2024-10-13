# ipbash  - functions for work with IP on clear bash

It's slow, but it works!

## function list: 

### ENTRYIP IP1[/mask1] IP2[/mask2]

entrance one subnet diapazone into another. Result:
* "->"  IP1[/mask1] into IP2[/mask2]
* "<-"  IP2[/mask2] into IP1[/mask1]
* "==" subnet IP1[/mask1] and subnet IP2[/mask2] equal
* "!=" else variants

### MERGESUBNETS IP1[/mask1] into IP2[/mask2]
merge equal neighbor subnets. Result:
* "IP/(mask-1)"
* ""

Errorlevel:
* 0 - all OK
* 1 - subnets not equal
* 2 - both ip in one subnet  

### IP2LONG IP[/mask]

convert ip to decimal number. Result:
* IP in decimal notation

### IP2HEX IP[/mask]
convert ip to hexadecimal number. Result:
* IP in hexadecimal notation

### IP2BIN  IP[/mask]
convert ip to binary number. Result
* IP in binary notation

### LONG2IP NUM
convert decimal number to ip. Result
* IP

### ONLYIP IP[/mask]
return ip without mask
* IP

function IPWITHMASK(){ # return ip with mask (default 32)

function ONLYMASK(){ # return ip mask (default 32)

function FIRSTIPLONG(){ # first subnet ip as number

function FIRSTIP(){ # first subnet ip

function LASTIPLONG(){ # last subnet ip as number

function LASTIP(){ # last subnet ip

function SUBNET(){ # subnet of ip

function CHECKIP(){ # minimal check ip by octet and subnet values

function _PREPAREIP(){ #separate ip octets and mask by space

## Test usage:

download ipbash.sh and test_ipbash.sh into one folder

**chmod +x test_ipbash.sh**

**./test_ipbash.sh**
