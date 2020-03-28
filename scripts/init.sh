#!/bin/bash

# Process fstab if file exist
if [ -f $MOUNT_FILE ]; then
    mount --fstab $MOUNT_FILE -a
fi

# Launch sia
siad -d $SIA_DATA_DIR -M $SIA_MODULES
