#!/bin/bash

docker run -itd --name jmeet-base doudou/jmeet-base:v1.0.0

docker exec -it jmeet-base /bin/bash