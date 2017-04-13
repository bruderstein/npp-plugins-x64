#!/bin/bash

set -e

# Transfer the zip first so we don't break anyone downloading the new md5 and old zip
scp -i deploy/id_rsa_deploy -P $SSHPORT plugins64.zip xmldata@nppxmldev.bruderste.in:/data/dev/content/xml

scp -i deploy/id_rsa_deploy -P $SSHPORT plugins64.md5.txt xmldata@nppxmldev.bruderste.in:/data/dev/content/xml
