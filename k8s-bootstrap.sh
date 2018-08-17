#!/bin/bash
cat <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.190.10 master1.internal master1
192.168.190.20 node1.internal node1
192.168.190.30 node2.internal node2
EOF
