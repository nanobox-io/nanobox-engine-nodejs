echo running tests for nodejs
UUID=$(cat /proc/sys/kernel/random/uuid)

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/build-nodejs sleep 365d

defer docker kill $UUID

pass "Failed to create /opt/code directory" docker exec $UUID mkdir -p /opt/code

pass "Failed to create /code directory" docker exec $UUID mkdir -p /code

pass "Failed to run build script" docker exec $UUID bash -c "cd /opt/engines/nodejs/bin; ./build '$(payload default-build)'"