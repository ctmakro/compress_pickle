#!/usr/bin/env bash

set -ex # fail on first error, print commands

while test $# -gt 0
do
    case "$1" in
        --global)
            GLOBAL=1
            ;;
        --no-setup)
            NO_SETUP=1
            ;;
    esac
    shift
done

command -v conda >/dev/null 2>&1 || {
  echo "Requires conda but it is not installed.  Run install_miniconda.sh." >&2;
  exit 1;
}

ENVNAME="${ENVNAME:-testenv}" # if no ENVNAME is specified, use testenv
PYTHON_VERSION=${PYTHON_VERSION:-3.6} # if no python specified, use 3.6

if [ -z ${GLOBAL} ]
then
    if conda env list | grep -q ${ENVNAME}
    then
      echo "Environment ${ENVNAME} already exists, keeping up to date"
    else
      conda create -n ${ENVNAME} --yes pip python=${PYTHON_VERSION}
    fi
    source activate ${ENVNAME}
fi
pip install --upgrade pip
pip install -r requirements.txt

if [ ! -z ${TEST_STYLE} ] || [ ! -z ${TEST_DOCS} ]
then
    pip install -r requirements-dev.txt
else
    pip install pytest pytest-cov pytest-html
fi

pip install -e .
