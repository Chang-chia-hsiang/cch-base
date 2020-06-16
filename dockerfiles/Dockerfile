# Author: Yuting Shih
# Date: 2020-06-13 Sat.
# Desc: build base image for HPC applications

FROM ubuntu:16.04
SHELL ["/bin/bash", "-c"]
WORKDIR /root

RUN apt update && apt install -y \
	vim tmux locate environment-modules tcl python3 python3-pip \
	git wget curl ssh net-tools \
	gcc g++ gfortran make cmake autoconf automake \
	libgtk2.*common libpango-1* libasound2* xserver-xorg cpio

ENV TOPDIR=/root WORK_DIR=/root
ENV SCRIPT_DIR=${TOPDIR}/scripts \
	MODULE_DIR=${TOPDIR}/modules \
	SOURCE_DIR=${TOPDIR}/sources \
	SET_SCRIPT='for file in $(ls ${SCRIPT_DIR}/*.sh); do source $file; done' \
	SET_MODULE='source /etc/profile.d/modules.sh'

COPY scripts ${SCRIPT_DIR}
COPY modules ${MODULE_DIR}
COPY sources ${SOURCE_DIR}
COPY temp /root/temp

RUN echo ${SET_SCRIPT} >> ~/.bashrc

###################

RUN eval ${SET_SCRIPT} && build_gcc 8 4 0 && build_hpcx; \
    eval ${SET_MODULE} && module load gcc/8.4.0 && \
    source /root/temp/fftw_gcc.sh

###################
CMD source /etc/profile.d/modules.sh && module use ${MODULE_DIR}; bash
