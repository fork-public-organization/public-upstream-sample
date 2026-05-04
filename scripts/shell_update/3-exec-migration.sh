# 3-1. Install GHE extension
gh extension install github/gh-gei

# 3-2. Get PAT from source and target environments (You can only use a personal access token (classic), not a fine-grained personal access token.)
# 3-3. Set PAT as environment variable (DO NOT CHANGE ENV NAME)
export GH_PAT="TOKEN"
export GH_SOURCE_PAT="TOKEN"

# 3-4. To migrate an organization, use the gh gei migrate-org command.
export SOURCE="SOURCE_ORG_NAME"
export DESTINATION="DESTINATION_ORG_NAME"
export ENTERPRISE="TARGET_ENTERPRISE_NAME"
gh gei migrate-org \
    --github-source-org "$SOURCE" \
    --github-target-org "$DESTINATION" \
    --github-target-enterprise "$ENTERPRISE"

# 3-5. To migrate repositories
export SOURCE="SOURCE_ORG_NAME"
export DESTINATION="DESTINATION_ORG_NAME"
export SOURCE_REPO="SOURCE_REPO_NAME"
export TARGET_REPO="TARGET_REPO_NAME"
gh gei migrate-repo \
    --github-source-org "$SOURCE" \
    --source-repo "$SOURCE_REPO" \
    --github-target-org "$DESTINATION" \
    --target-repo "$TARGET_REPO"

# 3-6. To generate a migration script, run the gh gei generate-script command.
export SOURCE="SOURCE_ORG_NAME"
export DESTINATION="DESTINATION_ORG_NAME"
export FILENAME="migration-script.sh"
gh gei generate-script \
    --github-source-org "$SOURCE" \
    --github-target-org "$DESTINATION" \
    --output "$FILENAME"
