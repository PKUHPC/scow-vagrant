#!/bin/sh

\cp -r /vagrant/scow/scow-deployment/config/* /root/scow/scow-deployment/config/
\cp -r /vagrant/scow/export-jobs/* /root/scow/export-jobs/
chmod 777 /root/scow/scow-deployment/compose.sh
chmod 777 /root/scow/scow-deployment/db.sh
/root/scow/scow-deployment/compose.sh up -d
