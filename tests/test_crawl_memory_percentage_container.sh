#!/bin/bash

# Tests the memory:memory-util-percentage feature
# Returns 1 if success, 0 otherwise

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

docker rm -f test_crawl_memory_container_1 2> /dev/null > /dev/null
docker run -d --name test_crawl_memory_container_1 ubuntu sleep 60 2> /dev/null > /dev/null
ID=`docker inspect -f '{{ .Id }}' test_crawl_memory_container_1`

python2.7 ../config_and_metrics_crawler/crawler.py --crawlmode OUTCONTAINER \
	--features=memory --crawlContainers $ID --format graphite | \
	grep memory-util-percentage | awk '{print (0 <= $2 <= 100)}'

docker rm -f test_crawl_memory_container_1 > /dev/null
