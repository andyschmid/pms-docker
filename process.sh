#!/bin/bash

LOCKFILE=/tmp/dvrProcessing.lock
ORIGFILE=$1
MKVFILE=${ORIGFILE%.*}.mkv
TMPFILE=${ORIGFILE%.*}.tmp
LOG=/var/log/plex/dvrProcessing.log


# Error if invalid argument
if [ -z "$1" ] ; then
    echo 'Input file not specified'
    exit 1
fi

# Check for lockfile and wait
while [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; do
    sleep 10
done

# make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}


# Mark commercials and convert to MKV
echo "[$(date)] Marking commercials for '$ORIGFILE'" | tee -a $LOG
nice -10 /usr/local/bin/comchap --comskip=/opt/Comskip/comskip --lockfile=/tmp/comchap.lock "$ORIGFILE" "$MKVFILE"

if [ $? -ne 0 ]; then
    echo "ERROR Marking commercials" | tee -a $LOG
    
    # Cleanup
    rm -f $MKVFILE
    
    exit 1
fi

# Move MKV to temp location to re-encode
mv -f "$MKVFILE" "$TMPFILE"

#Encode file to H.264 with mkv container
echo "[$(date)] Re-encoding '$ORIGFILE' to H.264" | tee -a $LOG
nice -10 /usr/bin/ffmpeg -i "$TMPFILE" -acodec copy -scodec copy -c:v libx264 -preset medium -profile:v high -level 4.0 -deinterlace -crf 21 "$MKVFILE"

if [ $? -ne 0 ]; then
    echo "ERROR transcoding" | tee -a $LOG
    
    # Cleanup
    rm -f $MKVFILE $ORIGFILE

    # restore temp file
    mv -f "$TMPFILE" "$MKVFILE"
    exit 1
fi

# Cleanup original and temporary files
rm -f "$ORIGFILE" "$TMPFILE"

echo "[$(date)] Done processing '${MKVFILE}'" | tee -a $LOG

exit 0
