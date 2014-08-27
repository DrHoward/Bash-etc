#!/bin/bash
# Sar summary - finds load/mem spikes for the week 
# Usage: sarsum [-q|-r|-u] 

# Default (no options): Load
if [[ $@ == "" || $@ == "-q" ]]; then
  type="load"; opt="-q";
  extra=$(grep extracpu /var/cpanel/cpanel.config | cut -d= -f2);
  cores=$(grep processor /proc/cpuinfo | wc -l);
  var=$(($cores+$extra));
  echo "Suggested load limit: $var";
  read -p "Enter desired load limit: " var; 
fi;

# Memory
if [[ $@ == "-r" ]]; 
then
  type="memory"; opt="-r";
  var="90"; 
fi;

# I/O
if [[ $@ == "-u" ]]; then
  type="I/O"; opt="-u";
  var="30"; 
fi; 

echo "Searching for $type spikes..."; sleep 1; 
find /var/log/sa |egrep sa[0-9]|sort| while read i; do
  echo "== "$i" ==";
  sar $opt -f $i | egrep -v "Linux|Average|memused|ldavg|iowait" | sed '/^$/d' 2>/dev/null; 
done > /root/out.txt; 

case "$opt" in 
-q) cat /root/out.txt | while read i;
      do echo $i | grep "=="; echo $i | grep RESTART;
      echo -n "$var "$i | awk '{if ($6 >= $1) print $2, $3, $6}';
    done; rm -rf /root/out.txt;
    ;; 
-r) cat /root/out.txt | while read i;
      do echo $i | grep "=="; echo $i | grep RESTART;
      echo -n "$var "$i | awk '{if ($6 >= $1) print $2, $3, $6}';
    done; rm -rf /root/out.txt;
    ;; 
-u) cat /root/out.txt | while read i;
      do echo $i | grep "=="; echo $i | grep RESTART;
      echo -n "$var "$i | awk '{if ($8 >= $1) print $2, $3, $8}';
    done; rm -rf /root/out.txt;
    ;; 
*) echo "Error: Bad input";
    ;;
esac
