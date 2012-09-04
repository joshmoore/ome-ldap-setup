SLAPD?=$(shell brew --prefix openldap)/libexec/slapd
HOST?=ldap://localhost:1389
BASE?=dc=ome,dc=local
ROOTDN?=cn=Manager,dc=ome,dc=local
PASSWD?=secret

##
## Functions
##
LOAD_FILE = ldapadd -H "$(HOST)" -x -D "$(ROOTDN)" -w "$(PASSWD)" -f "$(1)"

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
	"$(SLAPD)" -f conf/slapd.conf -d 255 -h "$(HOST)"

load:
	$(call LOAD_FILE,ldif/people.ldif)

test:
	ldapsearch -H "$(HOST)" -x -D uid=ome01,ou=people,dc=ome,dc=local -w ome01 -b 'dc=ome,dc=local' ldapcount
clean:
	rm -rf var

.PHONY: start stop test load clean
