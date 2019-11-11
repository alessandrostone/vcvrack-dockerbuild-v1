#!/bin/bash

# exit on errors
#set -e

WORKDIR=`dirname $0`
cd $WORKDIR
# make in an absolute path
WORKDIR=`pwd`

MYARCH=`uname -m`
MYUNAME=`uname`

if [ "$MYUNAME" = "Darwin" ]; then
  MYARCH="macos"
else
  MYOS=`uname -o`
  if [ "$MYOS" = "Msys" ]; then
    if [ "$MSYSTEM_CARCH" = "x86_64" ]; then
      MYARCH="win64"
    else
      MYARCH="win32"
    fi
  fi
fi

cd compile
cp ../build-modules.sh-proto build-modules.sh
cd library/repos
git submodule update --init --recursive

# arch specific patching if needed

for i in * ; do
  echo ""
  echo "===> $i"
  echo ""
  cd $i
  if [ -f ../../../../${i}.$MYARCH.patch ]; then
    patch -p1 < ../../../../${i}.$MYARCH.patch
  fi
  cd ..
done

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# some special handling:

# squinkylabs-plug1
echo ""
echo "===> squinkylabs-plug1 extra steps"
echo ""
cd squinkylabs-plug1
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# Valley
echo ""
echo "===> Valley extra steps"
echo ""
cd Valley
find * -type f -exec ../../../../simde-ify.sh {} \;
# this file gets accidently simde-ified :)
git checkout -- TopographImg.png
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# ML_modules
echo ""
echo "===> ML_modules extra steps"
echo ""
cd ML_modules
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# # FrozenWasteland
# echo ""
# echo "===> FrozenWasteland extra steps"
# echo ""
# cd FrozenWasteland
# # workaround some compile error by disabling one module on macos
# if [ "$MYARCH" = "macos" ]; then
#   mv src/PortlandWeather.cpp src/PortlandWeather.cpp.off 
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# # Bidoo
# echo ""
# echo "===> Bidoo extra steps"
# echo ""
# cd Bidoo
# # workaround some compile errors by disabling some modules on macos
# if [ "$MYARCH" = "macos" ]; then
#   mv src/CANARD.cpp src/CANARD.cpp.off
#   mv src/LIMONADE.cpp src/LIMONADE.cpp.off
#   mv src/OUAIVE.cpp src/OUAIVE.cpp.off
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# some extra plugins

cd ${WORKDIR}
mkdir -p compile/plugins
cd compile/plugins

# Fundamental
echo ""
echo "===> Fundamental extra plugin"
echo ""
git clone https://github.com/VCVRack/Fundamental.git
cd Fundamental
git checkout v1
# # this is the version i used this script last with
# git checkout 6b12618ac454a781c3f61ac2ded25474a4645d28
git submodule update --init --recursive
if [ -f ../../../Fundamental.$MYARCH.patch ]; then
  patch -p1 < ../../../Fundamental.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# LRTRack
echo ""
echo "===> LRTRack extra plugin"
echo ""
git clone https://github.com/lindenbergresearch/LRTRack
cd LRTRack
git checkout master
# # this is the version i used this script last with
# git checkout 6b12618ac454a781c3f61ac2ded25474a4645d28
git submodule update --init --recursive
if [ -f ../../../LRTRack.$MYARCH.patch ]; then
  patch -p1 < ../../../LRTRack.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# surge-rack
echo ""
echo "===> surge-rack extra plugin"
echo ""
git clone https://github.com/surge-synthesizer/surge-rack
cd surge-rack
git checkout release/1.beta1.1
git submodule update --init --recursive
if [ -f ../../../surge-rack.$MYARCH.patch ]; then
  patch -p1 < ../../../surge-rack.$MYARCH.patch
fi
# special patching for surge-rack in the surge subdir
cd surge
if [ -f ../../../../surge-rack-surge.$MYARCH.patch ]; then
  patch -p1 < ../../../../surge-rack-surge.$MYARCH.patch
fi
cd ..
find * -type f -exec ../../../simde-ify.sh {} \;
cd ..

# go back to a defined point
cd ${WORKDIR}
