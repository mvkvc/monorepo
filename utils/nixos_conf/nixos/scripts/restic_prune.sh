export B2_ACCOUNT_ID=$B2_ACCOUNT_ID \
    B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY \
    RESTIC_REPOSITORY=$RESTIC_REPOSITORY \
    RESTIC_PASSWORD_FILE=$RESTIC_PASSWORD_FILE
restic unlock
restic forget --host nixos --keep-last 1 --keep-daily 3 --keep-weekly 2 --keep-monthly 2