#!/bin/bash

if [ "${DOCKER_BUILD}" == "1" ]; then
    DEPS_PATH=$PWD/deps

    if [ ! -e ${DEPS_PATH} ]; then
        mkdir ${DEPS_PATH}
    fi


    for crate in pico_bsp rp2040_hal; do
        if [ ! -e ${DEPS_PATH}/${crate} ]; then
            git clone --depth=1 https://github.com/JeremyGrosser/${crate} ${DEPS_PATH}/${crate}
        fi
        alr -n -f pin ${crate} --use=${DEPS_PATH}/${crate}
    done

    alr build
else
    docker run --rm -t -i -v $PWD:/build --env DOCKER_BUILD=1 synack/ada-builder ./build.sh
fi
