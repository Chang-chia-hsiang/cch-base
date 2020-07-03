wget http://www.fftw.org/fftw-3.3.8.tar.gz  -O $HOME/fftw-3.3.8.tar.gz

CODE_NAME=fftw \
CODE_TAG=3.3.8 \
CODE_BASE_DIR=$HOME/ \
CODE_DIR=$CODE_BASE_DIR/$CODE_NAME-$CODE_TAG \
INSTALL_DIR=$HOME/fftw \
CMAKE_PATH=/usr/bin/cmake \
ICC_PATH=/opt/intel/compilers_and_libraries_2020.0.166/linux/bin/intel64/icc \
ICC_FLAGS='"-xBROADWELL -axBROADWELL,CORE-AVX2,SSE4.2 -O3 -DNDEBUG"' \

CMD_REBUILD_CODE_DIR="rm -fr $CODE_DIR \
&& tar xf $HOME/$CODE_NAME-$CODE_TAG.tar.gz -C $CODE_BASE_DIR"

### To build shared library (single precision) with Intel C Compiler
BUILD_LABEL=$CODE_TAG-shared-icc20-avx2-broadwell \
CMD_BUILD_SHARED_ICC=" \
mkdir $CODE_DIR/build-$BUILD_LABEL; \
cd $CODE_DIR/build-$BUILD_LABEL \
&& $CMAKE_PATH .. \
-DBUILD_SHARED_LIBS=ON -DENABLE_FLOAT=ON \
-DENABLE_OPENMP=OFF -DENABLE_THREADS=OFF \
-DCMAKE_C_COMPILER=$ICC_PATH -DCMAKE_CXX_COMPILER=$ICC_PATH \
-DENABLE_AVX2=ON -DENABLE_AVX=ON \
-DENABLE_SSE2=ON -DENABLE_SSE=ON \
-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/$BUILD_LABEL \
-DCMAKE_C_FLAGS_RELEASE=$ICC_FLAGS \
-DCMAKE_CXX_FLAGS_RELEASE=$ICC_FLAGS \
&& time -p make VERBOSE=1 V=1 install -j \
&& cd $INSTALL_DIR/$BUILD_LABEL && ln -s lib64 lib | tee $BUILD_LABEL.log "

eval $CMD_REBUILD_CODE_DIR;
eval $CMD_BUILD_SHARED_ICC &
wait
echo $CMD_REBUILD_CODE_DIR;
echo $CMD_BUILD_SHARED_ICC