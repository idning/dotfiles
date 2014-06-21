ps -eal | awk '{ if ($2 == "Z") {print $4}}' | xargs sudo kill -9
