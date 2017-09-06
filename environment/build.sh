#!/usr/bin/env bash

pushd ix
BUILD_PATH=$(pwd)
echo $BUILD_PATH

# CAFFE_PATH=/opt/caffe/build/install # GPU version
CAFFE_PATH=/opt/caffe/build_cpu/install  # CPU version


export PATH=~/local/bin:$PATH
export PATH=~/.local/bin:$PATH

set -ex



# Build caffe wrapper
pushd wrapper
if [ -e caffe ]; then
	rm caffe
fi
ln -s $CAFFE_PATH caffe

# ugh! temporary
if [ ! -d caffe/lib/x86_64-linux-gnu ]; then
	ln -s $CAFFE_PATH/lib $CAFFE_PATH/lib/x86_64-linux-gnu
fi
mkdir -p build
pushd build
cmake ..
make -j"$(nproc)"
popd
popd


# Build elm
pushd front
make 
cp -r icons ../server/static/
popd


# Build server
pushd server
if [ ! -d .stack-work ]; then
	stack setup
	stack install yesod-bin cabal-install
	stack init --solver --resolver lts-8.8 --install-ghc
fi
ln -sf $CAFFE_PATH/lib/libcaffe.so
ln -sf $CAFFE_PATH/lib/libcaffe.so.1.0.0
ln -sf $BUILD_PATH/wrapper/build/libwrapper.so
EXTRA_LIBS="$CAFFE_PATH/lib,$BUILD_PATH/wrapper/build"
sed -i.bak -e "s%# extra-lib-dirs: \[.*\]%extra-lib-dirs: [$EXTRA_LIBS]%g" ./stack.yaml
FLAGS=
stack build $FLAGS
popd

popd

