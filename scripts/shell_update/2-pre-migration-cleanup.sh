# 2-1. Set environment variables
export GH_SOURCE_PAT="SOURCE_PAT"
export GH_PAT="DESTINATION_PAT"

export SOURCE="SOURCE_ORG_NAME"
export DESTINATION="DESTINATION_ORG_NAME"
export ENTERPRISE="DESTINATION_ENTERPRISE_NAME"

# 2-2. Find repositories with no activity in the last year
gh api graphql -f query='
query($org: String!, $cursor: String) {
  organization(login: $org) {
    repositories(first: 100, after: $cursor) {
      pageInfo { hasNextPage endCursor }
      nodes {
        name
        pushedAt
        isArchived
        defaultBranchRef {
          target {
            ... on Commit {
              committedDate
            }
          }
        }
      }
    }
  }
}' -f org="$SOURCE" | jq '.data.organization.repositories.nodes[] |
  select(.isArchived == false) |
  select(.pushedAt < (now - 31536000 | todate)) |
  .name'

# 2-3. Find PRs older than 90 days with no recent activity
export SOURCE_REPO="SOURCE_REPO_NAME"
gh pr list \
  --repo "$SOURCE/$SOURCE_REPO" \
  --state open \
  --json number,title,updatedAt,author \
  --jq '.[] | select(.updatedAt < (now - 7776000 | todate))'

# 2-4. Find issues with no activity in 6 months
export SOURCE_REPO="SOURCE_REPO_NAME"
gh issue list \
  --repo "$SOURCE/$SOURCE_REPO" \
  --state open \
  --json number,title,updatedAt,labels \
  --jq '.[] | select(.updatedAt < (now - 15552000 | todate))'

# 2-5. List unused branches (Manual for each repo)
## List merged branches (safe to delete)
git branch -r --merged main | grep -v main | grep -v HEAD

## List branches with no commits in 6 months
for branch in $(git branch -r | grep -v HEAD); do
  last_commit=$(git log -1 --format="%ci" "$branch" 2>/dev/null | cut -d' ' -f1)
  if [[ "$last_commit" < "$(date -d '6 months ago' +%Y-%m-%d 2>/dev/null || date -v-6m +%Y-%m-%d)" ]]; then
    echo "$branch - last commit: $last_commit"
  fi
done

# 2-6. List integrations
## Set GitHub token with appropriate permissions
export GH_TOKEN="SOURCE_GITHUB_TOKEN" # with permissions to `admin:org_hook`
## List all webhooks in an organization
gh api "orgs/$SOURCE/hooks" \
  --jq '.[] | {id, name, active, config: .config.url}'

## List current webhooks
gh api "orgs/$SOURCE/hooks" \
  --jq '.[] | {
    id: .id,
    name: .name,
    active: .active,
    url: .config.url,
    events: .events
  }'

## List installed GitHub Apps
gh api "orgs/$SOURCE/installations" \
  --jq '.installations[] | {id, app_slug, permissions}'

## List installed apps for an organization and create a report
gh api "orgs/$SOURCE/installations" \
  --jq '.installations[] | {
    app_slug: .app_slug,
    app_id: .app_id,
    id: .id,
    repository_selection: .repository_selection,
    permissions: .permissions
  }' > installed_apps.json

# 2-7. List teams and members
## List all teams and their member counts
gh api "orgs/$SOURCE/teams" \
  --jq '.[] | {name, slug, members_count: .members_count}'

## List team members
gh api "orgs/$SOURCE/teams/TEAM_SLUG/members" \
  --jq '.[].login'
