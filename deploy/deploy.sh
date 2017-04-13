#!/bin/bash

set -e

SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -B -i deploy/id_rsa_deploy -P $SSHPORT"
# Transfer the zip first so we don't break anyone downloading the new md5 and old zip
scp $SSH_OPTIONS plugins64.zip xmldata@nppxmldev.bruderste.in:/data/dev/content/xml

scp $SSH_OPTIONS plugins64.md5.txt xmldata@nppxmldev.bruderste.in:/data/dev/content/xml
