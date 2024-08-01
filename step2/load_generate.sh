#!/usr/bin/env bash

for i in {1..10}
do
  curl http://localhost:8080/rolldice?rolls=12
  sleep 1
done

exit 0