SLAPD?=$(shell brew --prefix openldap)/libexec/slapd
HOST?=ldap://localhost:1389
BASE?=dc=ome,dc=local
ROOTDN?=cn=Manager,dc=ome,dc=local
PASSWD?=secret

##
## Functions
##
LOAD_FILE = ldapadd -H "$(HOST)" -x -D "$(ROOTDN)" -w "$(PASSWD)" -f "ldif/$(1)"
#LOAD_FILE = ldapadd -Y EXTERNAL -H "$(HOST)" -f "ldif/$(1)"

##
## Targets
##
help:
	"$(SLAPD)" -h

var/openldap-data: conf/DB_CONFIG
	mkdir -p $@
	cp conf/DB_CONFIG $@

var/run:
	mkdir -p $@

start: var/openldap-data var/run
	"$(SLAPD)" -f conf/slapd.conf -d 10 -h "$(HOST)"

load:
	$(call LOAD_FILE,memberof.ldif)
	$(call LOAD_FILE,memberof02.ldif)
	$(call LOAD_FILE,people.ldif)

clean:
	rm -rf var

.PHONY: start stop clean
