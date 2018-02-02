
setenv I_MPI_ROOT /opt/compilers/intelPS2017/compilers_and_libraries_2017.2.174/linux/mpi

if !($?PATH) then
    setenv PATH ${I_MPI_ROOT}/intel64/bin
else
    setenv PATH ${I_MPI_ROOT}/intel64/bin:${PATH}
endif

if !($?CLASSPATH) then
    setenv CLASSPATH ${I_MPI_ROOT}/intel64/lib/mpi.jar
else
    set noglob
    setenv CLASSPATH ${I_MPI_ROOT}/intel64/lib/mpi.jar:${CLASSPATH}
    unset noglob
endif

if !($?LD_LIBRARY_PATH) then
    setenv LD_LIBRARY_PATH ${I_MPI_ROOT}/intel64/lib:${I_MPI_ROOT}/mic/lib
else
    setenv LD_LIBRARY_PATH ${I_MPI_ROOT}/intel64/lib:${I_MPI_ROOT}/mic/lib:${LD_LIBRARY_PATH}
endif

if !($?MANPATH) then
    if ( `uname -m` == "k1om" ) then
        setenv MANPATH ${I_MPI_ROOT}/man
    else
        setenv MANPATH ${I_MPI_ROOT}/man:`manpath`
    endif
else
    setenv MANPATH ${I_MPI_ROOT}/man:${MANPATH}
endif

set library_kind=""
if ($#argv > 0) then
    set library_kind=$argv[1]
else if ($?I_MPI_LIBRARY_KIND) then
    set library_kind=$I_MPI_LIBRARY_KIND
endif

switch ($library_kind)
    case debug:
    case debug_mt:
    case release:
    case release_mt:
        setenv LD_LIBRARY_PATH ${I_MPI_ROOT}/intel64/lib/${library_kind}:${I_MPI_ROOT}/mic/lib/${library_kind}:${LD_LIBRARY_PATH}
        breaksw
    case --help:
    case -h:
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
        breaksw
endsw
