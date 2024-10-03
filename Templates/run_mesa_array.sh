#!/bin/bash
#
#----------------------------------------------------------------
# running a multiple independent jobs
#----------------------------------------------------------------
#


#  Defining options for slurm how to run
#----------------------------------------------------------------
#
#SBATCH --job-name=arraymesa
#SBATCH --output=array_%A_mesa_%a.log 
#        %A and %a are placeholders for the jobid and taskid, resp.
#
#Number of CPU cores to use within one node

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#
#Define the number of hours the job should run. 
#Maximum runtime is limited to 10 days, ie. 240 hours
#SBATCH --time=5:00:00
#
#Define the amount of RAM used by your job in GigaBytes
#In shared memory applications this is shared among multiple CPUs
#SBATCH --mem-per-cpu=8G
#
#Send emails when a job starts, it is finished or it exits
#SBATCH --mail-user=YourEmail@ist.ac.at
#SBATCH --mail-type=ALL
#
#Do not requeue the job in the case it fails.
#SBATCH --no-requeue
#
#Do not export the local environment to the compute nodes
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV
#
#Set the number of threads to the SLURM internal variable
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# load the respective software module(s) you intend to use
#----------------------------------------------------------------
module purge
module load mesastar/23.05.1

# define sequence of jobs to run as you would do in a BASH script
# use variable $SLURM_ARRAY_TASK_ID to address individual 
# behaviour in different iteration of the script execution
#----------------------------------------------------------------
# FILL IN THE BLANKS __________ !!!

# Path to this working directory. All array-tasks will be put 
# into the ./tasks/ directory
#
# !!!Always put the absolute path here to be completely certain 
# everything works!!!
WORK_DIR=__________
# BASE template directory on which to build the MESA run
# If you have a personal template you can also give the absolute 
# path there as well.
BASE_MESA_DIR=__________ # e.g. $MESA_DIR/star/work


# Pre-setup of the run
# for each array task a directory in tasks/task_N will be created 
# as a copy of BASE_MESA_DIR.
#----------------------------------------------------------------
# Setup the directory specific for the array-task
TASK_NAME=task_$SLURM_ARRAY_TASK_ID
TASK_DIR=$WORK_DIR/tasks/$TASK_NAME

# Create the specific task directory in ./tasks/ as a copy of the 
# chosen MESA template.
cp -a $BASE_MESA_DIR/. $TASK_DIR

cd $TASK_DIR

mkdir $TASK_DIR/caches
export MESA_CACHES_DIR=$TASK_DIR/caches

# Any additional work needed before running MESA goes here
#----------------------------------------------------------------
# e.g. adjusting profile_columns.list or history_columns.list



# This starts the MESA run
#----------------------------------------------------------------
srun --cpu_bind=verbose ./clean && ./mk && ./rn > screenlog.log