# 遷移至 GitHub Enterprise Managed Users 完整指南 - 第 2 部分：遷移前準備

> **📚 系列：遷移至 GitHub Enterprise Managed Users 完整指南**
> 這是 EMU 遷移指南系列的**第 2 部分，共 6 部分**。
>
> | 部分 | 主題 |
> |------|------|
> | [第 1 部分：探索與決策](Part1-Discovery&Decision.md) | 定義目標、評估適用性、取得共識 |
> | **[第 2 部分：遷移前準備](Part2-Pre-MigrationPreparation.md)**（您在此處）| 盤點、清理、IdP 準備、使用者溝通 |
> | [第 3 部分：身分識別與存取設定](Part3-Identity&Access-Setup.md) | 設定 SCIM、佈建使用者、建立團隊 |
> | [第 4 部分：安全性與合規性](Part4-Security&Compliance.md)  | 稽核記錄、安全強化、整合 |
> | [第 5 部分：遷移執行](Part5-MigrationExecution.md) | 執行 GEI、遷移儲存庫 |
> | [第 6 部分：驗證與採用](Part6-Validation&Adoption.md) | 測試、使用者培訓、OSS 策略、正式上線 |

---

# 第 2 階段：遷移前準備

清理舊環境並準備遷移

## 遷移前需求檢查清單
在開始遷移之前，確保你已經完成了以下準備工作：
1. [Identity Provider 準備就緒](#1-identity-provider-準備就緒)
2. [盤點現況](#2-盤點現況)
3. [評估儲存庫大小 (需逐一儲存庫進行評估)](#3-評估儲存庫大小-需逐一儲存庫進行評估)
4. [使用者溝通計畫](#4-使用者溝通計畫)
5. [遷移前清理](#5-遷移前清理)
   - [封存未使用的儲存庫](#封存未使用的儲存庫)
   - [關閉過時的 Pull Requests](#關閉過時的-pull-requests)
   - [清理過時的 Issues](#清理過時的-issues)
   - [清理已未使用的分支](#清理已未使用的分支)
   - [稽核並移除未使用的整合](#稽核並移除未使用的整合)
   - [整理團隊和存取權限](#整理團隊和存取權限)
6. [清理檢查清單](#6-清理檢查清單)

### 1. Identity Provider 準備就緒

EMU 需要相容的 Identity Provider，GitHub 可與以下 Identity Provider 整合：

| Identity Provider | SAML SSO | OIDC SSO | SCIM Provisioning |
|-------------------|----------|----------|-------------------|
| Microsoft Entra ID (Azure AD) | ✅ | ✅ | ✅ |
| Okta | ✅ | ❌ | ✅ |
| PingFederate | ✅ | ❌ | ✅ |

詳細設定說明請參閱 [Configuring SCIM provisioning for Enterprise Managed Users](https://docs.github.com/en/enterprise-cloud@latest/admin/identity-and-access-management/provisioning-user-accounts-for-enterprise-managed-users/configuring-scim-provisioning-for-enterprise-managed-users)。

### 2. 盤點現況

遷移之前，需要完整了解要搬移的內容，可使用 GitHub CLI 的 [`gh-repo-stats`](https://github.com/mona-actions/gh-repo-stats/) 擴充功能來產生完整的盤點資料：

- 安裝 `gh-repo-stats` 擴充功能並為你的組織產生盤點：

  ```bash
  # Install the extension
  gh extension install mona-actions/gh-repo-stats

  # Generate inventory for your organization
  gh repo-stats --org your-org-name --output inventory.csv
  ```

- 盤點清單將包含以下欄位：

  | 欄位名稱 | 說明 |
  |----------|------|
  | Org_Name | 組織名稱 |
  | Repo_Name | 儲存庫名稱 |
  | Is_Empty | 是否為空儲存庫 |
  | Last_Push | 上次推送時間 |
  | Last_Update | 上次更新時間 |
  | isFork | 是否為 Fork |
  | isArchived | 是否已封存 |
  | Repo_Size(mb) | 儲存庫大小（MB） |
  | Record_Count | 記錄數量 |
  | Collaborator_Count | 協作者數量 |
  | Protected_Branch_Count | 受保護分支數量 |
  | PR_Review_Count | PR 審查數量 |
  | Milestone_Issue_Count | 里程碑 Issue 數量 |
  | PR_Count | Pull Request 數量 |
  | PR_Review_Commit_Cr | PR 審查提交數量 |
  | Issue_Comment_Count | Issue 留言數量 |
  | Issue_Event_Count | Issue 事件數量 |
  | Release_Count | Release 數量 |
  | Project | 專案數量 |
  | Branch_Count | 分支數量 |
  | Tag_Count | 標籤數量 |
  | Discussion_Count | Discussion 數量 |
  | Wiki | Wiki 狀態 |
  | Full_URL | 完整 URL |
  | Migration_Issue | 遷移問題標記 |
  | Created | 建立時間 |

### 3. 評估儲存庫大小 (需逐一儲存庫進行評估)

- 大型儲存庫可能顯著影響遷移時間和成功率，可使用 [`git-sizer`](https://github.com/github/git-sizer) 來分析每個儲存庫：

  ```bash
  # Clone the repository
  git clone --mirror https://github.com/org/repo.git

  # Navigate to the cloned repo
  cd repo.git

  # Get the size of the largest file
  git-sizer --no-progress -j | jq ".max_blob_size"

  # Get total size of all files
  git-sizer --no-progress -j | jq ".unique_blob_size"
  ```

- 如果儲存庫歷史中有超過 100MB 的檔案，考慮在遷移前使用 [Git LFS](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-git-large-file-storage) 或重寫歷史

### 4. 使用者溝通計畫

遷移後使用者將會經歷：
- 新的使用者名稱（帳號加上企業簡碼）
- 失去貢獻公開儲存庫的能力
- 不可使用 EMU 帳號被加入至外部組織
- 不同的身分驗證流程
- 無法從企業外部 fork 儲存庫，可以依照企業政策，將企業內組織所擁有的 private 或內部 internal 儲存庫 fork 到自己的使用者命名空間，或 fork 到企業內其他組織中
- 在使用 GitHub Pages 時受到限制 (Private Access)


### 5. 遷移前清理

- [封存未使用的儲存庫](#封存未使用的儲存庫)
- [關閉過時的 Pull Requests](#關閉過時的-pull-requests)
- [清理過時的 Issues](#清理過時的-issues)
- [修剪死掉的分支](#修剪死掉的分支)
- [稽核並移除未使用的整合](#稽核並移除未使用的整合)
- [整理團隊和存取權限](#整理團隊和存取權限)

#### 封存未使用的儲存庫

- 識別並封存不再積極維護的儲存庫：

  ```bash
  # Find repositories with no activity in the last year
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
  }' -f org=YOUR_ORG | jq '.data.organization.repositories.nodes[] | 
    select(.isArchived == false) | 
    select(.pushedAt < (now - 31536000 | todate)) | 
    .name'
  ```

- 在封存之前，請考慮：
  - [ ] 這個儲存庫是否已被其他專案取代？
  - [ ] 是否有應該遷移的活躍 fork？
  - [ ] 它是否包含應該保存在其他地方的文件？

- 使用以下方式封存儲存庫：

  ```bash
  # Archive a single repository
  gh repo archive OWNER/REPO

  # Bulk archive from a list
  while read repo; do
    gh repo archive "$repo" --yes
    echo "Archived: $repo"
  done < repos-to-archive.txt
  ```

> **注意：** 已封存的儲存庫仍然可以在需要時被遷移，但它們向你的團隊表明該內容是歷史性的而非活躍的

#### 關閉過時的 Pull Requests

- 數月未被處理的 Open PRs 很少會被合併，在遷移前關閉以避免污染你的新環境

  ```bash
  # Find PRs older than 90 days with no recent activity
  gh pr list --repo OWNER/REPO --state open --json number,title,updatedAt,author \
    --jq '.[] | select(.updatedAt < (now - 7776000 | todate))'

  # Close stale PRs with a comment explaining why
  gh pr close PR_NUMBER --repo OWNER/REPO \
    --comment "Closing as part of pre-migration cleanup. This PR has been inactive for >90 days. Please reopen against the new repository location if still needed."
  ```

- 對於批量操作，建立一個腳本

  ```bash
  #!/bin/bash
  # close-stale-prs.sh - Close PRs older than specified days

  REPO="$1"
  DAYS="${2:-90}"
  CUTOFF_DATE=$(date -d "$DAYS days ago" +%Y-%m-%d 2>/dev/null || date -v-${DAYS}d +%Y-%m-%d)

  gh pr list --repo "$REPO" --state open --json number,title,updatedAt --jq '.[]' | \
  while read -r pr; do
    PR_NUM=$(echo "$pr" | jq -r '.number')
    UPDATED=$(echo "$pr" | jq -r '.updatedAt' | cut -d'T' -f1)
    
    if [[ "$UPDATED" < "$CUTOFF_DATE" ]]; then
      echo "Closing PR #$PR_NUM: $(echo "$pr" | jq -r '.title')"
      gh pr close "$PR_NUM" --repo "$REPO" \
        --comment "🧹 Closing as part of pre-migration cleanup to EMU. This PR has been inactive since $UPDATED. If still relevant, please recreate after migration."
    fi
  done
  ```

#### 清理過時的 Issues

- 與 PRs 類似，長期無人回應的舊 Issues 先進行盤點

  ```bash
  # Find issues with no activity in 6 months
  gh issue list --repo OWNER/REPO --state open --json number,title,updatedAt,labels \
    --jq '.[] | select(.updatedAt < (now - 15552000 | todate))'

  # Close with a descriptive label and comment
  gh issue close ISSUE_NUMBER --repo OWNER/REPO \
    --comment "Closing as part of pre-migration housekeeping. If this issue is still relevant, please reopen or create a new issue in our new location."
  ```

- 可建立一個 **stale** 或 **pre-migration-triage** 標籤來標記需要在遷移前審查的 Issues，以進行分類

#### 清理已未使用的分支

- 每個儲存庫都會隨時間累積分支，請於 migration 清理它們：

  ```bash
  # List merged branches (safe to delete)
  git branch -r --merged main | grep -v main | grep -v HEAD

  # List branches with no commits in 6 months
  for branch in $(git branch -r | grep -v HEAD); do
    last_commit=$(git log -1 --format="%ci" "$branch" 2>/dev/null | cut -d' ' -f1)
    if [[ "$last_commit" < "$(date -d '6 months ago' +%Y-%m-%d 2>/dev/null || date -v-6m +%Y-%m-%d)" ]]; then
      echo "$branch - last commit: $last_commit"
    fi
  done

  # Delete remote branches (be careful!)
  git push origin --delete branch-name
  ```

#### 稽核並移除未使用的整合

- 在遷移前審查 OAuth Apps、GitHub Apps 和 Webhooks：

  ```bash
  # List all webhooks in an organization
  gh api orgs/YOUR_ORG/hooks --jq '.[] | {id, name, active, config: .config.url}'

  # List installed GitHub Apps
  gh api orgs/YOUR_ORG/installations --jq '.installations[] | {id, app_slug, permissions}'
  ```

- 對於每個整合，可依據以下內容進行確認：
  - [ ] 這個整合是否仍在積極使用中？
  - [ ] 這個整合是否支援 EMU？（與供應商確認）
  - [ ] 是否有 EMU 相容的替代方案？
  - [ ] 誰擁有這個整合並能驗證其必要性？

#### 整理團隊和存取權限

- 審查團隊結構和成員：

  ```bash
  # List all teams and their member counts
  gh api orgs/YOUR_ORG/teams --jq '.[] | {name, slug, members_count: .members_count}'

  # List team members
  gh api orgs/YOUR_ORG/teams/TEAM_SLUG/members --jq '.[].login'
  ```

- 需要處理的問題：
  - [ ] 是否有沒有成員或沒有儲存庫存取的團隊？
  - [ ] 是否有應該合併的重複團隊？
  - [ ] 團隊名稱是否遵循你的命名慣例？
  - [ ] 巢狀團隊的結構是否適合你的 IdP 群組？

### 6. 清理檢查清單

使用檢查清單追蹤你的進度：

| 類別 | 任務 | 負責人 | 狀態 |
|------|------|--------|------|
| 儲存庫 | 識別超過 1 年沒有活動的儲存庫 | | ☐ |
| 儲存庫 | 封存或刪除未使用的儲存庫 | | ☐ |
| 儲存庫 | 記錄不應遷移的儲存庫 | | ☐ |
| Pull Requests | 關閉超過 90 天未活動的 PRs | | ☐ |
| Pull Requests | 合併或關閉已準備好的 PRs | | ☐ |
| Issues | 分類超過 6 個月未活動的 Issues | | ☐ |
| Issues | 關閉不再相關的 Issues | | ☐ |
| 分支 | 刪除已合併的分支 | | ☐ |
| 分支 | 刪除過時的功能分支 | | ☐ |
| 整合 | 稽核所有 OAuth 和 GitHub Apps | | ☐ |
| 整合 | 移除未使用的 Webhooks | | ☐ |
| 整合 | 驗證剩餘整合的 EMU 相容性 | | ☐ |
| 團隊 | 審查並合併團隊結構 | | ☐ |
| 團隊 | 將團隊對應到 IdP 群組 | | ☐ |

目標很簡單：**只遷移你需要的東西，而且要乾淨地遷移。**

---

> **📚 EMU 遷移指南系列導覽**
>
> ⬅️ **上一篇：[第 1 部分 - 探索與決策](Part1-Discovery&Decision.md)**
>
> ➡️ **下一篇：[第 3 部分 - 身分識別與存取設定](Part3-Identity&Access-Setup.md)**
>
> ---

