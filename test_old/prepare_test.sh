echo running tests for nodejs
UUID=$(cat /proc/sys/kernel/random/uuid)

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/build-nodejs sleep 365d

defer docker kill $UUID

pass "create db dir for pkgsrc" docker exec $UUID mkdir -p /data/var/db

pass "create dir for environment variables" docker exec $UUID mkdir -p /data/etc/env.d 

pass "Failed to update pkgsrc" docker exec $UUID /data/bin/pkgin up -y

pass "unable to create code folder" docker exec $UUID mkdir -p /opt/code

pass "Failed to inject package.json file" docker exec $UUID bash -c "echo -e \"{\n  \\\"name\\\": \\\"simple-nodejs\\\",\n  \\\"version\\\": \\\"1.0.0\\\",\n  \\\"description\\\": \\\"simple nodejs test\\\",\n  \\\"main\\\": \\\"server.js\\\",\n  \\\"scripts\\\": {\n    \\\"test\\\": \\\"test\\\"\n  },\n  \\\"author\\\": \\\"braxton\\\",\n  \\\"license\\\": \\\"MPL-2.0\\\",\n  \\\"dependencies\\\": {\n    \\\"express\\\": \\\"^4.13.3\\\"\n  }\n}\" > /opt/code/package.json"

pass "Failed to run prepare script" docker exec $UUID bash -c "cd /opt/engines/nodejs/bin; PATH=/data/sbin:/data/bin:\$PATH ./prepare '$(payload default-prepare)'"