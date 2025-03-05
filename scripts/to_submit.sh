#!/bin/bash

universe = vanilla

environment = "JOBID=$(Cluster).$(Process)"


# Specifica lo script Bash che avvia lo script Python
executable = /lustrehome/emanueleamato/ETH_Dataset/CBIM-Medical-Image-Segmentation/CHANGEME

# Passiamo i parametri nello stile argparse
arguments = "--dataset eth_lax --dimension 2d --batch_size 32 --model medformer"


log = /lustrehome/emanueleamato/ETH_Dataset/CBIM-Medical-Image-Segmentation/CHANGEME.log
error = /lustrehome/emanueleamato/ETH_Dataset/CBIM-Medical-Image-Segmentation/CHANGEME.err
output = /lustrehome/emanueleamato/ETH_Dataset/CBIM-Medical-Image-Segmentation/CHANGEME.out

request_cpus = 16
request_memory = 256G
request_gpus = 1

queue 


