# 3-1. Install GHE extension
gh extension install github/gh-gei

# 3-2. Get PAT from source and target environments (You can only use a personal access token (classic), not a fine-grained personal access token.)
# 3-3.Set PAT as environment variable (DO NOT CHANGE ENV NAME)
$env:GH_PAT="TOKEN"
$env:GH_SOURCE_PAT="TOKEN"

# 3-4. To migrate an organization, use the gh gei migrate-org command.
$env:SOURCE="SOURCE_ORG_NAME"
$env:DESTINATION="DESTINATION_ORG_NAME"
$env:ENTERPRISE="TARGET_ENTERPRISE_NAME"
gh gei migrate-org `
    --github-source-org $env:SOURCE `
    --github-target-org $env:DESTINATION `
    --github-target-enterprise $env:ENTERPRISE


# 3-5. To migrate repositories
$env:SOURCE="SOURCE_ORG_NAME"
$env:DESTINATION="DESTINATION_ORG_NAME"
$env:SOURCE_REPO="SOURCE_REPO_NAME"
$env:TARGET_REPO="TARGET_REPO_NAME"
gh gei migrate-repo `
    --github-source-org $env:SOURCE `
    --source-repo $env:SOURCE_REPO `
    --github-target-org $env:DESTINATION `
    --target-repo $env:TARGET_REPO `

## 3-6. To generate a migration script, run the gh gei generate-script command.
$env:SOURCE="SOURCE_ORG_NAME"
$env:DESTINATION="DESTINATION_ORG_NAME"
$env:FILENAME="migration-script.sh"
gh gei generate-script `
    --github-source-org $env:SOURCE `
    --github-target-org $env:DESTINATION `
    --output $env:FILENAME
