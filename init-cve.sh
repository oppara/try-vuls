#!/bin/bash

for i in `seq 2002 $(date +"%Y")`; do docker-compose run --rm cve fetchnvd -years $i; done
for i in `seq 1998 $(date +"%Y")`; do docker-compose run --rm cve fetchjvn -years $i; done
