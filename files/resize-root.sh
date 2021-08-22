#!/bin/bash

if sfdisk -d /dev/sda | grep -q '/dev/sda5.*22751954,'; then

    sfdisk -d /dev/sda | sed -r 's|(/dev/sda5.*size=\s*)22751954,|\1 487859201|' | sudo sfdisk --force /dev/sda
    partprobe
    resize2fs /dev/sda5
fi

touch /etc/.root-resized
