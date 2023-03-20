all: reg cs1660-whoami

reg: reg.c
	gcc -Wall reg.c -o reg
	chown registrar:registrar reg
	chmod 751 reg
	chmod u+s reg

cs1660-whoami:
	gcc -Wall cs1660_whoami.c -o cs1660_whoami

clean:
	rm -rfv reg
