#!/bin/bash
if [[ "$TRAVIS_PULL_REQUEST" != "false" || "$TRAVIS_BRANCH" != "master" ]]; then
    exit 0
fi
set -e

chmod 600 deploy/id_rsa_deploy

SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -B -i deploy/id_rsa_deploy -P $SSHPORT"

# Transfer the validate first so anyone who get's the new zip will also get the new validation
scp $SSH_OPTIONS validate64.json xmldata@nppxmldev.bruderste.in:/data/dev/content/validate

# Transfer the zip next so we don't break anyone downloading the new md5 and old zip
scp $SSH_OPTIONS plugins64.zip xmldata@nppxmldev.bruderste.in:/data/dev/content/xml

scp $SSH_OPTIONS plugins64.md5.txt xmldata@nppxmldev.bruderste.in:/data/dev/content/xml
