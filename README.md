# cch-base
build namd in hpc base  
  
latest update:  
(1)rm sources gcc-8.4.0.tar.gz openmpi-4.0.3.tar.gz parallel_studio_xe_2020_cluster_edition.tgz  
(2)#mv hpcx /root  
(3). fftw.sh  
(4)charm.sh work_dir=/root 、 git check 、 ../build charm++ 、#HPCX_DIR  
(5). charm.sh  
(6). namd.sh  
(7)apt-get install libfftw3-single3  
(8)mv ~/fftw-build/3.3.8-shared-gcc840-avx2-broadwell/lib/libfftw3f.so.3.5.7 /usr/lib/x86_64-linux-gnu/  
(9)~/namd-FETCH_HEAD/Linux-x86_64-g++-mpi-fftw3/namd2 --version  
