WORK_DIR=/root
CODE_NAME=charm
GIT_DIR=${WORK_DIR}/github/${CODE_NAME}.git
git clone --bare https://github.com/UIUC-PPL/charm.git $HOME/github/charm.git

# Checkout Charm++ v6.10.1
GIT_TAG=v6.10.1
WORK_TREE=${WORK_DIR}
CODE_DIR=${WORK_TREE}/${CODE_NAME}-${GIT_TAG}
mkdir -p ${WORK_TREE} ${CODE_DIR}
git --bare --git-dir=${GIT_DIR} fetch --all --prune
git --bare --git-dir=${GIT_DIR} --work-tree=${WORK_TREE} reset --mixed ${GIT_TAG}
git --bare --git-dir=${GIT_DIR} --work-tree=${CODE_DIR} clean -fxdn
git --bare --git-dir=${GIT_DIR} --work-tree=${WORK_TREE} checkout-index --force --all --prefix=${CODE_DIR}/

# Build Charm++ v6.10.1
CHARM_DIR=${CODE_DIR} \
HPCX_DIR=${WORK_DIR}/sources/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-ubuntu16.04-x86_64 \
HPCX_MPI_DIR=$HPCX_DIR/ompi \
INTEL_COMPILER_DIR=/opt/intel/compilers_and_libraries_2020.0.166/linux/bin \
ICC_FLAGS="-static-intel -xBROADWELL -axBROADWELL,CORE-AVX2,SSE4.2 -O3 -DNDEBUG"

CMD_REBUILD_BUILD_DIR="rm -fr ${CHARM_DIR}/built && mkdir -p ${CHARM_DIR}/built;"
### To build MPI executables with HPC-X OpenMPI + ICC20u1
CMD_BUILD_MPI_CHARM_ICC="
. $INTEL_COMPILER_DIR/compilervars.sh -arch intel64 -platform linux \
&& . $HPCX_DIR/hpcx-mt-init-ompi.sh \
&& hpcx_load \
&& cd $CHARM_DIR/built \
&& time -p ../build charm++ mpi-linux-x86_64 -j --with-production --basedir=$HPCX_MPI_DIR \
icc ifort $ICC_FLAGS \
&& hpcx_unload;"
eval $CMD_REBUILD_BUILD_DIR;
eval $CMD_BUILD_MPI_CHARM_ICC &
wait
echo $CMD_REBUILD_BUILD_DIR;
echo $CMD_BUILD_MPI_CHARM_ICC;
