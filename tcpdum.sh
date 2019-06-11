#!/bin/bash

tcpdump ! arp -i ens33 -nnAt and port ! 22 and ! 8125
