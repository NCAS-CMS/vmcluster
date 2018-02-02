#!/bin/sh
#
# Copyright (C) 2003-2016 Intel Corporation.  All Rights Reserved.
# 
# The source code contained or described herein and all documents
# related to the source code ("Material") are owned by Intel Corporation
# or its suppliers or licensors.  Title to the Material remains with
# Intel Corporation or its suppliers and licensors.  The Material is
# protected by worldwide copyright and trade secret laws and treaty
# provisions.  No part of the Material may be used, copied, reproduced,
# modified, published, uploaded, posted, transmitted, distributed, or
# disclosed in any way without Intel's prior express written permission.
# 
# No license under any patent, copyright, trade secret or other
# intellectual property right is granted to or conferred upon you by
# disclosure or delivery of the Materials, either expressly, by
# implication, inducement, estoppel or otherwise.  Any license under
# such intellectual property rights must be express and approved by
# Intel in writing.
#

I_MPI_ROOT=/opt/compilers/intelPS2017/compilers_and_libraries_2017.2.174/linux/mpi; export I_MPI_ROOT

print_help()
{
    echo ""
    echo "Usage: mpivars.sh [i_mpi_library_kind]"
    echo ""
    echo "i_mpi_library_kind can be one of the following:"
    echo "      debug           "
    echo "      debug_mt        "
    echo "      release         "
    echo "      release_mt      "
    echo ""
    echo "If the arguments to the sourced script are ignored (consult docs"
    echo "for your shell) the alternative way to specify target is environment"
    echo "variable I_MPI_LIBRARY_KIND to pass"
    echo "i_mpi_library_kind  to the script."
    echo ""
}

if [ -z "${PATH}" ]
then
    PATH="${I_MPI_ROOT}/intel64/bin"; export PATH
else
    PATH="${I_MPI_ROOT}/intel64/bin:${PATH}"; export PATH
fi

if [ -z "${CLASSPATH}" ]
then
    CLASSPATH="${I_MPI_ROOT}/intel64/lib/mpi.jar"; export CLASSPATH
else
    CLASSPATH="${I_MPI_ROOT}/intel64/lib/mpi.jar:${CLASSPATH}"; export CLASSPATH
fi

if [ -z "${LD_LIBRARY_PATH}" ]
then
    LD_LIBRARY_PATH="${I_MPI_ROOT}/intel64/lib:${I_MPI_ROOT}/mic/lib"; export LD_LIBRARY_PATH
else
    LD_LIBRARY_PATH="${I_MPI_ROOT}/intel64/lib:${I_MPI_ROOT}/mic/lib:${LD_LIBRARY_PATH}"; export LD_LIBRARY_PATH
fi

if [ -z "${MANPATH}" ]
then
    if [ `uname -m` = "k1om" ]
    then
        MANPATH="${I_MPI_ROOT}/man"; export MANPATH
    else
        MANPATH="${I_MPI_ROOT}/man":`manpath 2>/dev/null`; export MANPATH
    fi
else
    MANPATH="${I_MPI_ROOT}/man:${MANPATH}"; export MANPATH
fi

library_kind=""
if [ $# -ne 0 ]
then
    library_kind=$1
else
    library_kind=$I_MPI_LIBRARY_KIND
fi
case "$library_kind" in
    debug|debug_mt|release|release_mt)
        LD_LIBRARY_PATH="${I_MPI_ROOT}/intel64/lib/${library_kind}:${I_MPI_ROOT}/mic/lib/${library_kind}:${LD_LIBRARY_PATH}"; export LD_LIBRARY_PATH
    ;;
    -h|--help)
        print_help
    ;;
esac
