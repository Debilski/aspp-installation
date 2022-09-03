#!/bin/bash
set -ex

dd if=/dev/sda of=/dev/nvme0n1 bs=4096 status=progress
sync
