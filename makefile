CMP = $(shell which docker-compose)
DCKR = $(shell which docker)
PY = $(shell which python3)
SLP = $(shell which sleep)
PICON = "pihole-01"

add:
	@echo "[ Adding adlists ]"
	@echo
	${PY} add-lists.py

chpw:
	@echo "[ Changing pw to pihole UI ]"
	@echo
	${DCKR} exec -it ${PICON} pihole -a -p

down:
	@echo "[ Spinning down Pihole ]"
	@echo
	${CMP} down

dvol: down
	@echo "[ Deleting Pihole volumes ]"
	@echo
	-${DCKR} volume rm pihole-data
	-${DCKR} volume rm pihole-dnsmasqd

up: 
	@echo "[ Spinning up Pihole ]"
	@echo 
	${CMP} up -d
# 	sleep is needed to give the pihole container time to initialize before adding adlists to DB
	${SLP} 15
	${PY} add-lists.py
