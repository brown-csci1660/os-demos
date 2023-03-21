#!/bin/bash

cd /home/registrar && make
chown -R registrar:registrar /home/registrar
chmod 751 /home/registrar/{reg,reg.sh}
chmod 751 /home/registrar
chmod u+s /home/registrar/reg

cp /home/registrar/bin/is_admin /usr/local/bin
cp /home/registrar/cs1660_whoami /usr/local/bin
ln -sv /home/registrar/reg /usr/local/bin/reg

