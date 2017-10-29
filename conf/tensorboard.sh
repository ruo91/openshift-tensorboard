#!/bin/bash
export PATH=$PATH:$HOME/venvs/tensorboard/bin
source $HOME/venvs/tensorboard/bin/activate

tensorboard --logdir=/opt/notebooks
