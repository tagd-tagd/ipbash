#!/bin/bash
D2B=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
function _PREPAREIP(){ #separate ip octets and mask by space 
  local K=${1//./ }
  K=${K/\// }
  set -- $K 32
  echo $1 $2 $3 $4 $5
}
function IP2LONG(){ #convert ip to decimal number
  set -- $(_PREPAREIP $@)
  echo $(($1*16777216+$2*65536+$3*256+$4))
}
function IP2HEX(){ #convert ip to hexadecimal number
  printf "%08X\n" $(IP2LONG $1)
}
function IP2BIN(){ #convert ip to binary number
  set -- $(_PREPAREIP $@)
  echo ${D2B[$1]}${D2B[$2]}${D2B[$3]}${D2B[$4]}
}
function LONG2IP(){ # convert decimal number to ip
  local i x=$1
  for i in {0..3};do
    x=$(($1/(256**i)))
    ip[$i]=$((x &= 255))
  done
  echo "${ip[3]}.${ip[2]}.${ip[1]}.${ip[0]}"
}
function ONLYIP(){ # return ip without mask
  set -- $(_PREPAREIP $@)
  echo $1.$2.$3.$4
}
function IPWITHMASK(){ # return ip with mask (default 32)
  set -- $(_PREPAREIP $@)
  echo $1.$2.$3.$4/$5
}
function ONLYMASK(){ # return ip mask (default 32)
  set -- $(_PREPAREIP $@)
  echo $5
}
function FIRSTIPLONG(){ # first subnet ip as number
  local N=$(IP2LONG $1)
  local M=$((32-$(ONLYMASK $1)))
  ((N>>=M));echo $((N<<=M ))
}
function FIRSTIP(){ # first subnet ip
  LONG2IP $(FIRSTIPLONG $1)
}
function LASTIPLONG(){ # last subnet ip as number
  local N=$(IP2LONG $1)
  local M=$((32-$(ONLYMASK $1)))
  if [[ M -eq 0 ]];then
    echo $N
  else
    echo $((N|=$((2**M-1))))
  fi
}
function LASTIP(){ # last subnet ip
  LONG2IP $(LASTIPLONG $1)
}
function SUBNET(){ # subnet of ip
  echo $(FIRSTIP $1)'/'$(ONLYMASK $1)
}
function ENTRYIP() { # entrance one subnet diapazone  into another
  local -i M1=$(ONLYMASK $1)
  local -i M2=$(ONLYMASK $2)
  local -i IPL1=$(IP2LONG $1)
  local -i IPL2=$(IP2LONG $2)
  local M E
  if [[ M1 -lt M2 ]];then
    M=M1;E="<"
  elif [[ M1 -gt M2 ]];then
    M=M2;E=">"
  else
    M=M2;E="="
  fi
  M=32-$M
  if [[ $((IPL1>>=$M)) != $((IPL2>>=$M)) ]];then
    E="!"
  fi
  echo $E
}
function MERGESUBNETS(){ # merge equal neighbor subnets
  local -i M1=$(ONLYMASK $1)
  local -i M2=$(ONLYMASK $2)
  if [[ $M1 -ne $M2 ]];then
    return 1
  fi
  local -i FIPL1=$(FIRSTIPLONG $(ONLYIP $1)/$M1)
  local -i FIPL2=$(FIRSTIPLONG $(ONLYIP $2)/$M2)
  if [[ $FIPL1 -eq $FIPL2 ]];then
    return 2
  fi 
  M1=$M1-1
  FIPL1=$(FIRSTIPLONG $(ONLYIP $1)/$M1)
  FIPL2=$(FIRSTIPLONG $(ONLYIP $2)/$M1)
  if [[ $FIPL1 -eq $FIPL2 ]];then
    echo $(LONG2IP $FIPL1)/$M1
  fi
}
function CHECKIP(){ # minimal check ip by octet and subnet values
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
