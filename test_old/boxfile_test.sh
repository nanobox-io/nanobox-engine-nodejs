echo running tests for nodejs
UUID=$(cat /proc/sys/kernel/random/uuid)

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/build-nodejs sleep 365d

defer docker kill $UUID

pass "unable to create code folder" docker exec $UUID bash -c "cd /opt/engines/nodejs/bin; ./boxfile '$(payload default-boxfile)'"
