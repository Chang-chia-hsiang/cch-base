git clone --bare https://charm.cs.illinois.edu/gerrit/namd.git $HOME/github/namd.git

CODE_NAME=namd \
CODE_GIT_TAG=FETCH_HEAD \
GIT_DIR=$HOME/github/$CODE_NAME.git \
GIT_WORK_TREE=$HOME \
CODE_DIR=$GIT_WORK_TREE/$CODE_NAME-$CODE_GIT_TAG \

mkdir -p $GIT_WORK_TREE $CODE_DIR
git --bare --git-dir=$GIT_DIR fetch --all --prune;
git --bare --git-dir=$GIT_DIR --work-tree=$GIT_WORK_TREE reset --mixed $CODE_GIT_TAG;
git --bare --git-dir=$GIT_DIR --work-tree=$CODE_DIR clean -fxdn;
git --bare --git-dir=$GIT_DIR --work-tree=$GIT_WORK_TREE checkout-index --force --all --prefix=$CODE_DIR/

CHARM_ARCH_MPI_GCC=mpi-linux-x86_64-gfortran-gcc \
CODE_NAME=charm \
CODE_GIT_TAG=FETCH_HEAD \
CODE_GIT_TAG=v6.10.1 \
GIT_WORK_TREE=$HOME \
CHARM_CODE_DIR=$GIT_WORK_TREE/$CODE_NAME-$CODE_GIT_TAG \
CHARM_BASE=$CHARM_CODE_DIR/built \
GCC_FFTW3_LIB_DIR=/root/fftw-build/3.3.8-shared-gcc840-avx2-broadwell \
HPCX_FILES_DIR=/root/sources/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-ubuntu16.04-x86_64 \
GCC_DIR=/usr/local/gcc-8.4.0 \
GCC_PATH='"$GCC_DIR/bin/gcc "' \
GXX_PATH='"$GCC_DIR/bin/g++ -std=c++0x"' \
NATIVE_GCC_FLAGS='"-static-libstdc++ -static-libgcc -march=native -mtune=native -mavx2 -msse4.2 -O3 -DNDEBUG"' \
GCC_FLAGS='"-static-libstdc++ -static-libgcc -march=broadwell -mtune=broadwell -mavx2 -msse4.2 -O3 -DNDEBUG"' \
CODE_NAME=namd \
CODE_GIT_TAG=FETCH_HEAD \
GIT_DIR=$HOME/github/$CODE_NAME.git \
GIT_WORK_TREE=$HOME \
NAMD_CODE_DIR=$GIT_WORK_TREE/$CODE_NAME-$CODE_GIT_TAG \
NAMD_DIR=$NAMD_CODE_DIR \

URL=https://www.ks.uiuc.edu/Research/namd/libraries/tcl8.5.9-linux-x86_64.tar.gz
TARFILE=tcl8.5.9-linux-x86_64.tar.gz
LIBDIR=$HOME/tcl8.5.9-linux-x86_64

wget $URL -O $TARFILE --no-check-certificate && tar -zxvf $TARFILE

cd $NAMD_DIR;
 
### To build NAMD with Charm++ HPC-X OpenMPI + GCC8.4.0 + FFTW3
CMD_BUILD_MPI_NAMD_GCC_FFTW3="
. $HPCX_FILES_DIR/hpcx-mt-init-ompi.sh && hpcx_load \
&& PATH=$GCC_DIR/bin:$PATH \
./config Linux-x86_64-g++ --with-memopt \
--tcl-prefix $LIBDIR --charm-base $CHARM_BASE --charm-arch $CHARM_ARCH_MPI_GCC \
--with-fftw3 --fftw-prefix $GCC_FFTW3_LIB_DIR \
--cc $GCC_PATH --cc-opts $GCC_FLAGS \
--cxx $GXX_PATH --cxx-opts $GCC_FLAGS \
&& cd Linux-x86_64-g++ && time -p make -j \
&& cd $NAMD_DIR && mv Linux-x86_64-g++ Linux-x86_64-g++-mpi-fftw3 \
&& hpcx_unload "

eval $CMD_BUILD_MPI_NAMD_GCC_FFTW3; wait

