# Pihole in a Docker Container

## Requirements
- Linux host
- Docker
- Docker-compose
- python3
- make

## Getting Started
*Creating pihole container*
```
make up
```
This will use docker-compose to create a pihole container with the name `pihole-01`.


*Destroying pihole container*
```
make down
```

*Destroying pihole volumes*

2 docker volumes are created as part of spinning up the pihole container. These are not deleted by default when spinning down pihole which allows data to persist.

If you would like to delete all data from the previous pihole container, run the following command. 

**This will permanently delete your data!**
```
make dvol
```
*Adding to adlist*

This step is already included with `make up`, but it tends to be flakey. If you need to add to the adlist without recreating the pihole container, run the following.
```
make add
```
*Updating password*
```
make chpw
```
