# 4-1. Generate a CSV file containing the list of mannequins to be reclaimed, along with their corresponding target users.
export DESTINATION="DESTINATION_ORG_NAME"
gh gei generate-mannequin-csv \
    --github-target-org "$DESTINATION" \
    --output mannequins.csv

# 4-2. Reclaim mannequins in bulk using the generated CSV file, or individually by specifying the mannequin login and target user.
export DESTINATION="DESTINATION_ORG_NAME"
gh gei reclaim-mannequin \
    --github-target-org "$DESTINATION" \
    --csv mannequins.csv
    # --skip-invitation # if you want to skip sending invitation to target users, as they might already have access to the repositories after migration.

# 4-3. Reclaim a single mannequin by specifying the mannequin login and target user
export DESTINATION="DESTINATION_ORG_NAME"
export MANNEQUIN_LOGIN="MANNEQUIN_LOGIN"
export USERNAME="TARGET_USER_LOGIN"
gh gei reclaim-mannequin \
    --github-target-org "$DESTINATION" \
    --mannequin-user "$MANNEQUIN_LOGIN" \
    --target-user "$USERNAME"
