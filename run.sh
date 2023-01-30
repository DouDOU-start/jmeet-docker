#!/bin/bash

docker run -itd --name jmeet --net=host --restart=unless-stopped doudou/jmeet:v1.0.0

docker exec -it jmeet /bin/bash