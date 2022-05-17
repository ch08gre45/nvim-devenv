#!/bin/bash

THIS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cp -f ${THIS_DIR}/vimrc ~/.vimrc
