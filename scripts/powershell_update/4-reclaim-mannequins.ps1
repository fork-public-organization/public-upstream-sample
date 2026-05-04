# 4-1. Generate a CSV file containing the list of mannequins to be reclaimed, along with their corresponding target users. 
$env:DESTINATION="DESTINATION_ORG_NAME"
gh gei generate-mannequin-csv `
    --github-target-org $env:DESTINATION `
    --output mannequins.csv


# 4-2. Reclaim mannequins in bulk using the generated CSV file, or individually by specifying the mannequin login and target user.
$env:DESTINATION="DESTINATION_ORG_NAME"
gh gei reclaim-mannequin `
    --github-target-org $env:DESTINATION `
    --csv mannequins.csv `
    # --skip-invitation # if you want to skip sending invitation to target users, as they might already have access to the repositories after migration.

# 4-3. reclaim a single mannequin by specifying the mannequin login and target user
$env:DESTINATION="DESTINATION_ORG_NAME"
$env:MANNEQUIN_LOGIN="MANNEQUIN_LOGIN"
 $env:USERNAME="TARGET_USER_LOGIN"
gh gei reclaim-mannequin `
    --github-target-org $env:DESTINATION `
    --mannequin-user $env:MANNEQUIN_LOGIN `
    --target-user $env:USERNAME