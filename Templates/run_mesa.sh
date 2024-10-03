#!/bin/bash
#
#-------------------------------------------------------------
#example script for running a single-CPU serial job via SLURM
#-------------------------------------------------------------
#
#SBATCH --job-name=mesa
#SBATCH --output=mesa-%j.log   
#            %j is a placeholder for the jobid
#
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#
#Define the number of hours the job should run. 
#Maximum runtime is limited to 10 days, ie. 240 hours
#SBATCH --time=36:00:00
#
#Define the amount of RAM used by your job in GigaBytes
#SBATCH --mem=2G
#
#Send emails when a job starts, it is finished or it exits
#SBATCH --mail-user=YourEmail@ist.ac.at
#SBATCH --mail-type=ALL
#
#Pick whether you prefer requeue or not. If you use the --requeue
#option, the requeued job script will start from the beginning, 
#potentially overwriting your previous progress, so be careful.
#For some people the --requeue option might be desired if their
#application will continue from the last state.
#Do not requeue the job in the case it fails.
#SBATCH --no-requeue
#
#Do not export the local environment to the compute nodes
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV
#
#for single-CPU jobs make sure that they use a single thread
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
#
#load the respective software module you intend to use
#----------------------------------------------------------------
module purge
module load mesastar/23.05.1

# FILL IN THE BLANKS __________ !!!

# Path to this working directory. All files from the MESA run 
# will then be in WORK_DIR/task/
#
# !!!Always put the absolute path here to be completely certain 
# everything works!!!
WORK_DIR=__________
# BASE template directory on which to build the MESA run
# If you have a personal template you can also give the absolute 
# path there as well.
BASE_MESA_DIR=__________ # e.g. $MESA_DIR/star/work


#
# Pre-setup of the run
#----------------------------------------------------------------
# Setup the directory for the MESA run
TASK_DIR=$WORK_DIR/task

# Create the specific task directory as a copy of the chosen MESA 
# template
cp -a $BASE_MESA_DIR/. $TASK_DIR
# Create a custom directory for the caches and set the 
# corresponding MESA flag to the path.
mkdir $TASK_DIR/caches
export MESA_CACHES_DIR=$TASK_DIR/caches

cd $TASK_DIR

#
# Any additional manipulation that might be needed goes below here
#----------------------------------------------------------------
# e.g. adjusting profile_columns.list or history_columns.list

#
# This starts the MESA run
#----------------------------------------------------------------
srun --cpu_bind=verbose ./clean && ./mk && ./rn > screenlog.log