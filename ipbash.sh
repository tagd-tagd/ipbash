#!/bin/bash
D2B=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
#_PREPAREIP 192.168.1.7/24
#192 168 1 7 24
#_PREPAREIP 192.168.1.7
#192.168.1.7 32
function _PREPAREIP(){ #separate ip octets and mask by space 
  local K=${1//./ }
  K=${K/\// }
  set -- $K 32
  echo $1 $2 $3 $4 $5
}
#IP2LONG 192.168.1.7/24
#3232235783
#IP2LONG 192.168.1.7
#3232235783
function IP2LONG(){ #convert ip to decimal number
  set -- $(_PREPAREIP $@)
  echo $(($1*16777216+$2*65536+$3*256+$4))
}
#IP2HEX 192.168.1.7
#C0A80107
function IP2HEX(){ #convert ip to hexadecimal number
  printf "%08X\n" $(IP2LONG $1)
}
#IP2BIN 192.168.1.7
#11000000101010000000000100000111
function IP2BIN(){ #convert ip to binary number
  set -- $(_PREPAREIP $@)
  echo ${D2B[$1]}${D2B[$2]}${D2B[$3]}${D2B[$4]}
}
#LONG2IP 3232235783
#192.168.1.7
function LONG2IP(){ # convert decimal number to ip
  local i x=$1
  for i in {0..3};do
    x=$(($1/(256**i)))
    ip[$i]=$((x &= 255))
  done
  echo "${ip[3]}.${ip[2]}.${ip[1]}.${ip[0]}"
}
#ONLYIP 192.168.1.7/24
#192.168.1.7
#ONLYIP 192.168.1.7
#192.168.1.7
function ONLYIP(){ # return ip without mask
  set -- $(_PREPAREIP $@)
  echo $1.$2.$3.$4
}
#IPWITHMASK 192.168.1.7/24
#192.168.1.7/24
#IPWITHMASK 192.168.1.7
#192.168.1.7/32
function IPWITHMASK(){ # return ip with mask (default 32)
  set -- $(_PREPAREIP $@)
  echo $1.$2.$3.$4/$5
}
#ONLYMASK 192.168.1.7/24
#24
#ONLYMASK 192.168.1.7
#32
function ONLYMASK(){ # return ip mask (default 32)
  set -- $(_PREPAREIP $@)
  echo $5
}
#FIRSTIPLONG 192.168.1.7
#3232235783
#FIRSTIPLONG 192.168.1.7/24
#3232235776
#FIRSTIPLONG 192.168.1.7/16
#3232235520
function FIRSTIPLONG(){ # first subnet ip as number
  local N=$(IP2LONG $1)
  local M=$((32-$(ONLYMASK $1)))
  ((N>>=M));echo $((N<<=M ))
}
#FIRSTIP 192.168.1.7
#192.168.1.7
#FIRSTIP 192.168.1.7/24
#192.168.1.0
#FIRSTIP 192.168.1.7/16
#192.168.0.0
function FIRSTIP(){ # first subnet ip
  LONG2IP $(FIRSTIPLONG $1)
}
#LASTIPLONG 192.168.1.7
#3232235783
#LASTIPLONG 192.168.1.7/24
#3232236031
#LASTIPLONG 192.168.1.7/16
#3232301055
function LASTIPLONG(){ # last subnet ip as number
  local N=$(IP2LONG $1)
  local M=$((32-$(ONLYMASK $1)))
  if [[ M -eq 0 ]];then
    echo $N
  else
    echo $((N|=$((2**M-1))))
  fi
}
#LASTIP 192.168.1.7
#192.168.1.7
#LASTIP 192.168.1.7/24
#192.168.1.255
#LASTIP 192.168.1.7/16
#192.168.255.255
function LASTIP(){ # last subnet ip
  LONG2IP $(LASTIPLONG $1)
}
#SUBNET 192.168.1.7
#192.168.1.7/32
#SUBNET 192.168.1.7/24
#192.168.1.0/24
function SUBNET(){ # subnet of ip
  echo $(FIRSTIP $1)'/'$(ONLYMASK $1)
}
#ENTRYIP 192.168.1.7 192.168.1.5/24
#->
#ENTRYIP 192.168.1.7/16 192.168.1.5/20
#<-
#ENTRYIP 192.168.1.7/24 192.168.1.5/24
#==
#ENTRYIP 192.168.7.1/24 192.168.5.1/24
#!=
function ENTRYIP() { # entrance one subnet diapazone  into another
  local -i M1=$(ONLYMASK $1)
  local -i M2=$(ONLYMASK $2)
  local -i IPL1=$(IP2LONG $1)
  local -i IPL2=$(IP2LONG $2)
  local M E
  if [[ M1 -lt M2 ]];then
    M=M1;E="<-"
  elif [[ M1 -gt M2 ]];then
    M=M2;E="->"
  else
    M=M2;E="=="
  fi
  M=32-$M
  if [[ $((IPL1>>=$M)) != $((IPL2>>=$M)) ]];then
    E="!="
  fi
  echo $E
}
#MERGESUBNETS 192.168.2.5/24 192.168.1.7/16;echo $?
#""; $?=1 (mask not equal)
#MERGESUBNETS 192.168.1.5/24 192.168.1.7/24;echo $?
#"";$?=2 (mask equal, but subnet not neighbor)
#MERGESUBNETS 192.168.0.5/24 192.168.1.7/24;echo $?
#192.168.0.0/23;$?=0 (All OK)
function MERGESUBNETS(){ # merge EQUAL neighbor subnets
  local -i M1=$(ONLYMASK $1)
  if [[ $M1 -ne $(ONLYMASK $2) ]];then #mask not equal
    return 1
  fi
  local -i FIPL1=$(FIRSTIPLONG $(ONLYIP $1)/$M1)
  local -i FIPL2=$(FIRSTIPLONG $(ONLYIP $2)/$M1)
  if [[ $FIPL1 -eq $FIPL2 ]];then #one subnet
    return 2
  fi 
  M1=$M1-1
  FIPL1=$(FIRSTIPLONG $(ONLYIP $1)/$M1)
  FIPL2=$(FIRSTIPLONG $(ONLYIP $2)/$M1)
  if [[ $FIPL1 -eq $FIPL2 ]];then
    echo $(LONG2IP $FIPL1)/$M1
  fi
}
#$?=1 - wrong ip value
#$?=2 - wrong subnet value
#?=0 - OK
function CHECKIP(){ # minimal check ip by octet and subnet values, NOT FORMAT
  set -- $(_PREPAREIP $@)
  local i
  for i in {1..4};do
    if [[ $1 -lt 0 || $1 -gt 255 ]];then
     return 1
    fi
    shift || return 1
  done
  if [[ $1 -lt 0 || $1 -gt 32 ]];then
    return 2
  fi
}
