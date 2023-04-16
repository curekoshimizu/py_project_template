#!/bin/bash


DIR=$(cd $(dirname "$0"); cd ..; pwd)

pushd ${DIR} && poetry run python ./scripts/py_project_template.py $@ && popd
