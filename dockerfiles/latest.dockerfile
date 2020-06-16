# Author: Yuting Shih, Chiahsiang Chang
# Date: 2020-06-16 Tue.
# Desc: image with GCC8, OMPI4, and PSXE20 preinstalled to test FFTW3 and NAMD2 scripts

FROM tings0802/hpc-base:0.4.1-all
SHELL ["/bin/bash", "-c"]
WORKDIR /root

COPY scripts ${SCRIPT_DIR}
COPY modules ${MODULE_DIR}
COPY sources ${SOURCE_DIR}
COPY temp /root

RUN eval ${SET_SCRIPT} && eval ${SET_MODULE} && module use ${MODULE_DIR} && \
	module load gcc/8.4.0 && printf "$(gcc --version)\n\n" >> version.txt && \
	module load ompi/4.0.3 && printf "$(mpirun -V)\n\n" >> version.txt && \
	module swap ompi impi && printf "$(mpirun -V)\n\n" >> version.txt

CMD eval ${SET_MODULE} && module use ${MODULE_DIR}; bash
