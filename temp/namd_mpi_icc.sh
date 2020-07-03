git clone --bare https://charm.cs.illinois.edu/gerrit/namd.git $HOME/github/namd.git
CODE_NAME=namd \
CODE_GIT_TAG=FETCH_HEAD \
GIT_DIR=$HOME/github/$CODE_NAME.git \
GIT_WORK_TREE=$HOME \
CODE_DIR=$GIT_WORK_TREE/$CODE_NAME-$CODE_GIT_TAG \

git --bare --git-dir=$GIT_DIR fetch --all --prune;
git --bare --git-dir=$GIT_DIR --work-tree=$GIT_WORK_TREE reset --mixed $CODE_GIT_TAG;
git --bare --git-dir=$GIT_DIR --work-tree=$CODE_DIR clean -fxdn;
git --bare --git-dir=$GIT_DIR --work-tree=$GIT_WORK_TREE checkout-index --force --all --prefix=$CODE_DIR/

CHARM_ARCH_MPI_ICC=mpi-linux-x86_64-ifort-icc \
CODE_NAME=charm \
CODE_GIT_TAG=FETCH_HEAD \
CODE_GIT_TAG=v6.10.1 \
GIT_WORK_TREE=$HOME \
CHARM_CODE_DIR=$GIT_WORK_TREE/$CODE_NAME-$CODE_GIT_TAG \
CHARM_BASE=$CHARM_CODE_DIR/built \
HPCX_FILES_DIR=/root/sources/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-ubuntu16.04-x86_64 \
GXX_PATH='"$GCC_DIR/bin/g++ -std=c++0x"' \
CODE_NAME=namd \
CODE_GIT_TAG=FETCH_HEAD \
GIT_DIR=$HOME/github/$CODE_NAME.git \
GIT_WORK_TREE=$HOME \
NAMD_CODE_DIR=$GIT_WORK_TREE/$CODE_NAME-$CODE_GIT_TAG \
NAMD_DIR=$NAMD_CODE_DIR \
INTEL_COMPILER_DIR=/opt/intel/compilers_and_libraries_2020.0.166/linux/bin \
ICC_FFTW3_LIB_DIR=/root/fftw/3.3.8-shared-icc20-avx2-broadwell \
ICC_PATH=/opt/intel/compilers_and_libraries_2020.0.166/linux/bin/intel64/icc \
ICPC_PATH=$INTEL_COMPILER_DIR/intel64/icpc -std=c++11 \
ICC_FLAGS='"-static-intel -xBROADWELL -axBROADWELL,CORE-AVX2,SSE4.2 -O3 -DNDEBUG"' \

URL=https://www.ks.uiuc.edu/Research/namd/libraries/tcl8.5.9-linux-x86_64.tar.gz
TARFILE=tcl8.5.9-linux-x86_64.tar.gz
LIBDIR=$HOME/tcl8.5.9-linux-x86_64
wget $URL -O $TARFILE --no-check-certificate && tar -zxvf $TARFILE

cd $NAMD_DIR;
### To build NAMD with Charm++ HPC-X OpenMPI + ICC20u1 + FFTW3
CMD_BUILD_MPI_NAMD_ICC_FFTW3="
. $INTEL_COMPILER_DIR/compilervars.sh -arch intel64 -platform linux \
&& . $HPCX_FILES_DIR/hpcx-mt-init-ompi.sh && hpcx_load \
&& ./config Linux-x86_64-icc --with-memopt \
--tcl-prefix $LIBDIR --charm-base $CHARM_BASE --charm-arch $CHARM_ARCH_MPI_ICC \
--with-fftw3 --fftw-prefix $ICC_FFTW3_LIB_DIR \
--cc $ICC_PATH --cc-opts $ICC_FLAGS \
--cxx $ICPC_PATH --cxx-opts $ICC_FLAGS \
&& cd Linux-x86_64-icc && time -p make -j \
&& cd $NAMD_DIR && mv Linux-x86_64-icc Linux-x86_64-icc-mpi-fftw3 \
&& hpcx_unload"

eval $CMD_BUILD_MPI_NAMD_ICC_FFTW3; wait
