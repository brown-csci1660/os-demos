#!/bin/bash

BASE=$(dirname $(realpath $0))

mount -o bind /home/deemer/Development/csci1660 ${BASE}/csci1660
