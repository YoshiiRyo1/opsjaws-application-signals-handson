#!/usr/bin/env bash

for i in {1..1000}
do
  curl http://localhost:8080/rolldice?rolls=12 > /dev/null 2>&1
done

exit 0