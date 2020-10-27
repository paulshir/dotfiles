#!/bin/zsh
set -euo pipefail

DIR=$(pwd)
docker build -t dft1 ../../ -f ${DIR}/dft1.Dockerfile
docker build -t dft2 ../../ -f ${DIR}/dft2.Dockerfile
docker build -t dft3 ../../ -f ${DIR}/dft3.Dockerfile
docker build -t dft4 ../../ -f ${DIR}/dft4.Dockerfile
docker build -t dft5 ../../ -f ${DIR}/dft5.Dockerfile
