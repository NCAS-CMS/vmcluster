#!/bin/bash
#SBATCH --image=dmjacobsen/mpitest:latest
#SBATCH -N 2
#SBATCH -n 4
#SBTACH -o /vagrant/test.out
srun --mpi=pmi2 /opt/shifter-16.08.3/bin/shifter /app/hello

