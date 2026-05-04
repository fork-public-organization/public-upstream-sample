# 1-1. Install the extension
gh extension install mona-actions/gh-repo-stats

# 1-2. Set environment variables for authentication and organization name
$env:GH_SOURCE_PAT="TOKEN"
$env:SOURCE="SOURCE_ORG_NAME"
# Generate inventory for your organization
gh repo-stats `
    --org $env:SOURCE `
    --output inventory.csv `
    --token $env:GH_SOURCE_PAT