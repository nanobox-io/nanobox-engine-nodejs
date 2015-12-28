echo running tests for nodejs
UUID=$(cat /proc/sys/kernel/random/uuid)

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/build-nodejs sleep 365d

defer docker kill $UUID

pass "unable to create code folder" docker exec $UUID mkdir -p /opt/code

fail "Detected something when there shouldn't be anything" docker exec $UUID bash -c "cd /opt/engines/nodejs/bin; ./sniff /opt/code"

pass "Failed to inject package.json file" docker exec $UUID bash -c "echo -e \"{\n  \\\"name\\\": \\\"simple-nodejs\\\",\n  \\\"version\\\": \\\"1.0.0\\\",\n  \\\"description\\\": \\\"simple nodejs test\\\",\n  \\\"main\\\": \\\"server.js\\\",\n  \\\"scripts\\\": {\n    \\\"test\\\": \\\"test\\\"\n  },\n  \\\"author\\\": \\\"braxton\\\",\n  \\\"license\\\": \\\"MPL-2.0\\\",\n  \\\"dependencies\\\": {\n    \\\"express\\\": \\\"^4.13.3\\\"\n  }\n}\" > /opt/code/package.json"

pass "Failed to detect NodeJS" docker exec $UUID bash -c "cd /opt/engines/nodejs/bin; ./sniff /opt/code"