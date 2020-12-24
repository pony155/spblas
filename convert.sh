#!/bin/sh

SRCS=`find . -name "*.c"`
SRCS_CXX=`find . -name "*.cpp"`
SRCS_H=`find . -name "*.h"`

for SRC in $SRCS
do
    dos2unix $SRC
    chmod +rw $SRC
    sed -i 's/[ \t]*$//' $SRC
done

for SRC in $SRCS_CXX
do
    dos2unix $SRC
    chmod +rw $SRC
    sed -i 's/[ \t]*$//' $SRC
done

for SRC in $SRCS_H
do
    dos2unix $SRC
    chmod +rw $SRC
    sed -i 's/[ \t]*$//' $SRC
done

