#!/bin/bash -xe
if [ "$1" = "" ]; then
    echo "Please specify a version number (e.g. 0.0.1) as the first argument"
    exit 1
fi

# create releases

latest_scope=$(ls releases/weave-scope-release/releases/weave-scope/ |sort --version-sort --field-separator=- --key=3,3 |tail -n 1)
bosh-cli create-release --dir releases/weave-scope-release --tarball releases/weave-scope.tgz \
    releases/weave-scope-release/releases/weave-scope/$latest_scope

latest_runtime_configurator=$(ls releases/runtime-configurator-release/releases/runtime-configurator/ |sort --version-sort --field-separator=- --key=3,3 |tail -n 1)
bosh-cli create-release --dir releases/runtime-configurator-release --tarball releases/runtime-configurator.tgz \
    releases/runtime-configurator-release/releases/runtime-configurator/$latest_runtime_configurator

latest_uaa_proxy=$(ls releases/uaa-proxy-release/releases/uaa-proxy/ |sort --version-sort --field-separator=- --key=3,3 |tail -n 1)
bosh-cli create-release --dir releases/uaa-proxy-release --tarball releases/uaa-proxy.tgz \
    releases/uaa-proxy-release/releases/uaa-proxy/$latest_uaa_proxy

# download releases
curl -sSL -o releases/cf-routing.tgz "https://bosh.io/d/github.com/cloudfoundry-incubator/cf-routing-release?v=0.156.0"
curl -sSL -o releases/consul.tgz "https://bosh.io/d/github.com/cloudfoundry-incubator/consul-release?v=170"

# create tile
/usr/local/bundle/bin/hangar -n weave-cloud -r /work/releases -m /work/metadata/p-weave.yml -c /work/content_migrations/p-weave.yml -g /work/migrations -v $1 -s 3363