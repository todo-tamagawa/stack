# Build environment for IX
RSMC版IXのリリースビルド用スクリプト群

本来はIXのレポジトリに入れたいが、ライブラリのビルドなどが絡むので、現時点では独立したレポジトリとしている。

## Files

| file                 | description |
|:---------------------|:----------- |
| build.sh             | caffewrapper, elm, Yesodのビルドスクリプト |
| docker/Dockerfile    | ビルド用のDockerイメージ生成Dockerfile |

## Docker
Ubuntu 16.04ベースのDockerイメージ上でビルド、テストを実施する。
本Dockerイメージには、ixビルド用の環境がインストールされている他、以下のライブラリがビルドされた状態で同梱されている。

- OpenCV 3.2.0
- Caffe 1.0
  - GPUモード
  - ONLY_CPUモード

GPUを有効にして、Dockerを利用するためには [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) がインストールされている必要がある。



### Dockerイメージの作成
ビルド用Dockerイメージは以下のコマンドで作成可能。

```
$ cd docker
$ docker build -t ix:builder .
```

### Dockerの起動
GPUを有効にする場合
```
$ nvidia-docker run -it ix:builder bash
```

CPUのみで動作させる場合
```
$ docker run -it ix:builder bash
```

### その他のDocker起動設定
Dockerホスト側にcloneしたソースをDockerコンテナにマウントする場合は、 `-v` オプションでマウント箇所を指定する。

IXはWebのホスティングに53001ポートを利用する。コンテナの53001ポートをDockerのホスト側のポートにbindする場合には `-p` オプションを利用する。


## ソース取得
githubからソースを取得する

```
$ git clone https://github.com/XCompassIntelligence/ix ix
```

ixには、gitの submoduleとしてcaffeが含まれている。
前述のDockerイメージではにはすでにcaffeがビルドされているので、こちらを使えばよいがsubmoduleを使う場合には、
以下のようにsubmoduleを取得する。

```
cd ix
git submodule update --init
```

## ビルド
build.shはixのソースに対して、以下のモジュールのビルドを行う。

| module       | descriptions  |
|:-------------|:--------------|
| Caffe Wraper | caffe-haskell間のWrapper |
| elm          | HTML(js)静的コンテンツ |
| ix-server    | ixコア、Webホスティング |


### Caffe Wrapper
ビルド方法

```
cd wrapper
# export CAFFE_PATH=/opt/caffe/build/install
# or
# export CAFFE_PATH=../extlib/caffe/build/install
ln -s $CAFFE_PATH/install caffe
mkdir build
cd build
cmake ..
make -j
make install
```

CPU_ONLY版でビルドする際は、事前にwrapper/CMakeLists.txtの以下の行を有効にしておくこと

```
# ADD_DEFINITIONS(-DCPU_ONLY)
```

### elm

```
cd ix/front
make
```

### ix-server

#### prepare (only one time)

```
cd ix/server/
ln -s ../front/icons ./static/

# export CAFFE_PATH=/opt/caffe/build/install
# or
# export CAFFE_PATH=../extlib/caffe/build/install
ln -s ../wrapper/build/libwrapper.so
ln -s $CAFFE_PATH/lib/libcaffe.so
ln -s $CAFFE_PATH/lib/libcaffe.so.1.0.0

export LD_LIBRARY_PATH=.
export PATH=~/local/bin:$PATH
export PATH=~/.local/bin:$PATH

stack setup
stack install yesod-bin cabal-install
stack init --solver --resolver lts-8.8 --install-ghc
```

#### build


```
cd ix/server/
stack build
```



## 実行
postgresql のサービス

```
service postgresql start
```

IX serverの起動

```
cd ix/server/
stack exec -- ix
```

-> 53001 portでWebサーバが起動
