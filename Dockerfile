FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade
RUN DEBIAN_FRONTEND="noninteractive" apt-get install build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 git libtool -y

RUN apt-get install -y cabal-install
RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0.tar.gz
RUN tar -xf cabal-install-3.2.0.0.tar.gz 
RUN cd cabal-install-3.2.0.0/ && cabal update && cabal install
RUN rm /usr/bin/cabal
RUN ln -s /root/.cabal/bin/cabal /usr/bin/cabal
RUN rm -f cabal-install-3.2.0.0.tar.gz
RUN rm -Rf cabal-install-3.2.0.0

RUN git clone https://github.com/input-output-hk/libsodium
RUN cd libsodium && git checkout 66f017f1 && ./autogen.sh && ./configure && make && make install
RUN rm -Rf libsodium
RUN echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> /root/.bashrc

RUN git clone https://github.com/input-output-hk/cardano-node.git
RUN cd cardano-node/ && git fetch --all --tags && git checkout tags/1.14.2 && LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" /usr/bin/cabal install cardano-node cardano-cli --installdir=/root/.cabal/bin
RUN rm -Rf cardano-node
RUN echo "export PATH=/root/.cabal/bin:$PATH" >> /root/.bashrc

