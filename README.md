# ipbash  - functions for work with IP on clear bash

It's slow, but it works!

## Function list: 

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
* "IP" in decimal notation

### IP2HEX IP[/mask]
convert ip to hexadecimal number. Result:
* "IP" in hexadecimal notation

### IP2BIN  IP[/mask]
convert ip to binary number. Result:
* "IP" in binary notation

### LONG2IP NUM
convert decimal number to ip. Result:
* "IP"

### ONLYIP IP[/mask]
return ip without mask. Result:
* "IP"

### IPWITHMASK IP[/mask]
return ip with mask (default 32). Result:
* "IP/mask"

### ONLYMASK IP[/mask]
return mask of ip (default 32). Result:
* "mask"

### FIRSTIPLONG IP[/mask]
first SUBNET ip as number. Result:
* "IP" in decimal notation

### FIRSTIP  IP[/mask]
first SUBNET ip. Result:
* "IP"

### LASTIPLONG  IP[/mask]
last SUBNET ip as number. Result:
* "IP" in decimal notation

### LASTIP IP[/mask]
last SUBNET ip. Result:
* "IP"

### SUBNET IP[/mask]
subnet of ip. Result:
* "IP/mask"

### CHECKIP  IP[/mask]
minimal check ip by octet and subnet values (not format). Result:
Errorlevel:
* 0 - All Ok
* 1 - bad number in IP
* 2 - bad mask number

### _PREPAREIP aaa.bbb.ccc.ddd/mm
separate ip octets and mask by space. Return:
* "aaa bbb ccc ddd mm"

<HR>

## Test usage:

download ipbash.sh and test_ipbash.sh into one folder

**chmod +x test_ipbash.sh**

**./test_ipbash.sh**
