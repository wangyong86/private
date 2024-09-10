#!/bin/env bash

# Create a named pipe (FIFO) if it doesn't exist
[ -e ./fd1 ] || mkfifo ./fd1
exec 50<> ./fd1   # Open the named pipe for read/write
rm -rf ./fd1      # Clean up the FIFO file after opening it

# Initialize the pipe with tokens (for 10 parallel jobs)
for i in $(seq 1 10); do
    echo >&50
done

# Read SQL file line by line
cat ${sqlfile} | while read line; do
    # Take a token from the pipe to limit concurrency
    read -u 50
    {
        # Execute SSH command on the server
        ssh $server date

        # Check if the SSH command succeeded
        if [ $? -eq 0 ]; then
            echo "success"
        else
            echo "failed"
        fi

        # Return the token to the pipe
        echo >&50
    } &
done

# Wait for all background processes to finish
wait

# Close the file descriptor
exec 50>&-
