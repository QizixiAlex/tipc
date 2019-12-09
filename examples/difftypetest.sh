#!/bin/sh
if [ $# -lt 1 ]; then
  echo "$0: you must provide a .tip file"
  exit 0;
fi

bname=`basename $1 .tip`

# create a per user tmp directory for storing diff files
if [ ! -d ~/tmp ]; then
  mkdir ~/tmp
fi

# compile and run the test through tipc 
#    we suppress warnings while linking because of a target triple mismatch
../build/tipc -t $1 >~/tmp/$bname.tipc-out
cp ~/tmp/$bname.tipc-out ~/isolate/$bname.tipc-out
stty echo
cd - >/dev/null
# clang-7 -w -static $1.bc ../intrinsics/tip_intrinsics.bc -o $bname
# ./$bname >/tmp/$USER/$bname.tipc-out

# create a tipc directory for storing source to run TIP Scala
if [ ! -d ~/TIP/tipc ]; then
  mkdir ~/TIP/tipc
fi

# run the test through TIP Scala 
#   must execute in its build directory
#   reenable stty echo when finished
cd ~/tipc/examples
cp $1 ~/TIP/tipc/
cd ~/TIP
./tip -types tipc/$1
cp out/$bname.tip__types.ttip ~/tmp/$bname.tipscala-out
cp ~/tmp/$bname.tipscala-out ~/isolate/$bname.tipscala-out
stty echo
cd - >/dev/null


# We are only interested in differences related to computed outputs
# and errors. If the diff contains none, then the test passes
# We have to transform the scala output to remove specific unprintable
# chars prior to diffing.
sed 's/\[\(0\|1\|31\)m//g' ~/tmp/$bname.tipc-out >~/tmp/tc
cp ~/tmp/tc ~/tmp/$bname.tipc-out

sed 's/\[\(0\|1\|31\)m//g' ~/tmp/$bname.tipscala-out >~/tmp/tsc
# sed -i -e 's/α<\d+>/α/g' ~/tmp/tsc
sed -i -e 's/α<4>/α/g' ~/tmp/tsc
sed -i -e 's/α<3>/α/g' ~/tmp/tsc
sed -i -e 's/α<2>/α/g' ~/tmp/tsc
sed -i -e 's/α<7>/α/g' ~/tmp/tsc
sed -i -e 's/α<5>/α/g' ~/tmp/tsc
sed -i -e 's/α<9>/α/g' ~/tmp/tsc
sed -i -e 's/α<10>/α/g' ~/tmp/tsc
sed -i -e 's/α<15>/α/g' ~/tmp/tsc
sed -i -e 's/α<19>/α/g' ~/tmp/tsc
sed -i -e 's/α<21>/α/g' ~/tmp/tsc
sed -i -e 's/α<18>/α/g' ~/tmp/tsc
sed -i -e 's/α<32>/α/g' ~/tmp/tsc
sed -i -e 's/α<22>/α/g' ~/tmp/tsc
sed -i -e 's/α<46>/α/g' ~/tmp/tsc
sed -i -e 's/α<53>/α/g' ~/tmp/tsc
cp ~/tmp/tsc ~/tmp/$bname.tipscala-out

if diff ~/tmp/$bname.tipc-out ~/tmp/$bname.tipscala-out | grep -e ": "; then
  echo "$bname failed"
else
  echo "$bname passed"
fi