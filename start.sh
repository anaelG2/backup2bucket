#!/bin/sh

# Check preconditions
[ -z "$SOURCE_DATABASE" ] && echo "SOURCE_DATABASE not set!" && exit 1;
[ -z "$BACKUP_DATABASE" ] && echo "BACKUP_DATABASE not set!" && exit 1;
SOURCE_DIR=$(dirname "$SOURCE_DATABASE")
BACKUP_DIR=$(dirname "$BACKUP_DATABASE")
[ ! -d "$SOURCE_DIR" ] && echo "SOURCE_DATABASE folder not mounted ($SOURCE_DIR)!" && exit 1;
[ ! -d "$BACKUP_DIR" ] && echo "BACKUP_DATABASE folder not mounted ($BACKUP_DIR)!" && exit 1;

# Generate timestamp and timestamp file
TIMESTAMP=$(date '+%F-%H%M%S')
if [ $TIMESTAMP_BACKUP = true ]; then
  BACKUP_DATABASE="$(echo '$BACKUP_DATABASE')_$TIMESTAMP"
fi

if [ -z $TIMESTAMP_FILE ]; then
  echo "$TIMESTAMP" > $TIMESTAMP_FILE
fi

# Shoot the backup
/usr/bin/sqlite3 $SOURCE_DATABASE ".backup $BACKUP_DATABASE"

# Print status
if [ $? -eq 0 ]; then
  echo "$TIMESTAMP - OK"
else
  echo "$TIMESTAMP - FAIL"
fi
