#!/bin/bash
if [[ "$TRAVIS_PULL_REQUEST" != "false" || "$TRAVIS_BRANCH" != "master" ]]; then
    exit 0
fi
set -e

openssl aes-256-cbc -K $encrypted_2a680a2fe767_key -iv $encrypted_2a680a2fe767_iv -in deploy/id_rsa_deploy.enc -out deploy/id_rsa_deploy -d
chmod 600 deploy/id_rsa_deploy

SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -B -i deploy/id_rsa_deploy -P $SSHPORT"

# Transfer the validate first so anyone who get's the new zip will also get the new validation
scp $SSH_OPTIONS validate64.json xmldata@nppxmldev.bruderste.in:/data/dev/content/validate

# Transfer the zip next so we don't break anyone downloading the new md5 and old zip
scp $SSH_OPTIONS plugins64.zip xmldata@nppxmldev.bruderste.in:/data/dev/content/xml

scp $SSH_OPTIONS plugins64.md5.txt xmldata@nppxmldev.bruderste.in:/data/dev/content/xml

# New server (transferring to both for transition)
# Transfer the validate first so anyone who get's the new zip will also get the new validation
scp $SSH_OPTIONS validate64.json xmldata@server2.bruderste.in:/data/dev/content/validate

# Transfer the zip next so we don't break anyone downloading the new md5 and old zip
scp $SSH_OPTIONS plugins64.zip xmldata@server2.bruderste.in:/data/dev/content/xml

scp $SSH_OPTIONS plugins64.md5.txt xmldata@server2.bruderste.in:/data/dev/content/xml
