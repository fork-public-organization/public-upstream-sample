# GitHub to GitHub EMU 遷移 Guidance

本專案提供從標準 GitHub Enterprise Cloud (GHEC) 遷移至 GitHub Enterprise Managed Users (EMU) 環境的自動化腳本與指導文件，協助組織實現集中式身份管理、強化安全性與合規性

## 專案結構

```
gh2gh/
├── README.md                    # 本文件
├── local-testing.ps1            # 本地測試用腳本
├── mannequins.csv               # Mannequin 對應表
├── *.csv                        # 儲存庫盤點資料
├── guidance/                    # 遷移指導文件
│   ├── Migration-Life-Cycle.md  # 遷移生命週期總覽
│   ├── en-us/                   # 英文版指導文件
│   └── zh-tw/                   # 繁體中文版指導文件
├── log/                         # 遷移日誌
└── scripts/                     # 自動化腳本
    ├── 0-prep.ps1               # 環境準備
    ├── 1-repo-inventory.ps1     # 儲存庫盤點
    ├── 2-pre-migration-cleanup.ps1  # 遷移前清理
    ├── 3-exec-migration.ps1     # 執行遷移
    └── 4-reclaim-mannequins.ps1 # 認領 Mannequin
```

## 先決條件

| 工具 | 最低版本 | 說明 |
|------|----------|------|
| [GitHub CLI](https://cli.github.com/) | v2.4.0+ | 基礎命令列工具 |
| [gh-repo-stats](https://github.com/mona-actions/gh-repo-stats) 擴充套件 | - | 產生儲存庫盤點清單 |
| [gh-gei](https://github.com/github/gh-gei) 擴充套件 | - | GitHub Enterprise Importer 遷移工具 |
| jq | - | JSON 查詢與處理工具 |
| git | - | 版本控制操作 |


## 遷移生命週期

遷移分為 **6 個階段**，其中第 5-6 階段會依群組反覆執行：

| 階段 | 名稱 |
|------|------|
| Phase 1 | 探索與決策 (Discovery & Decision)  |
| Phase 2 | 遷移前準備 (Pre-Migration Preparation) | 
| Phase 3 | 身份與存取設定 (Identity & Access Setup) |
| Phase 4 | 安全性與合規性 (Security & Compliance) | 
| Phase 5 | 遷移執行 (Migration Execution) | 
| Phase 6 | 驗證與採用 (Validation & Adoption) | 

> Phase 5-6 採用分群組逐步遷移策略，而非一次性大規模遷移，以降低風險。

## 腳本說明

所有腳本位於 `scripts/` 目錄下，需依序執行：

### 0-prep.ps1 — 環境準備

安裝 GitHub CLI（最低 v2.4.0）及 jq 等基礎工具

### 1-repo-inventory.ps1 — 儲存庫盤點

使用 `gh-repo-stats` 擴充套件產生來源組織所有儲存庫的盤點清單（`inventory.csv`），包含大小、協作者數量、保護分支等資訊

### 2-pre-migration-cleanup.ps1 — 遷移前清理

盤點現況：
- 辨識過去一年無活動的儲存庫
- 辨識超過 90 天的 Pull Request
- 辨識超過 6 個月無活動的 Issue
- 列出已合併及過時的分支
- 稽核 Webhook 與 GitHub App 整合
- 列出團隊與成員

### 3-exec-migration.ps1 — 執行遷移

使用 GitHub Enterprise Importer (`gh-gei`) 執行實際遷移：
- 組織層級遷移 (`gh gei migrate-org`)
- 個別儲存庫遷移 (`gh gei migrate-repo`)
- 產生遷移腳本 (`gh gei generate-script`)

### 4-reclaim-mannequins.ps1 — 認領 Mannequin

將遷移過程中產生的佔位使用者 (Mannequin) 對應至實際的 Managed User

## 指導文件

`guidance/` 目錄下提供完整的遷移指導文件

| 文件 | 內容 |
|------|------|
| Part1 - Discovery & Decision | 探索與決策：定義遷移目標、評估 EMU 適合性 |
| Part2 - Pre-Migration Preparation | 遷移前準備：盤點現況、IdP 就緒驗證、技術債清理 |
| Part3 - Identity & Access Setup | 身份與存取：SCIM 佈建設定、團隊建立 |
| Part4 - Security & Compliance | 安全性與合規性：稽核日誌、安全政策、CI/CD 更新 |
| Part5 - Migration Execution | 遷移執行：GEI 操作、Mannequin 認領 |
| Part6 - Validation & Adoption | 驗證與採用：測試、使用者培訓、上線監控 |

## 快速開始

1. 執行 `scripts/0-prep.ps1` 安裝必要工具
2. 設定環境變數
3. 執行 `scripts/1-repo-inventory.ps1` 盤點來源組織儲存庫
4. 執行 `scripts/2-pre-migration-cleanup.ps1` 進行遷移前清理
5. 執行 `scripts/3-exec-migration.ps1` 進行實際遷移
6. 執行 `scripts/4-reclaim-mannequins.ps1` 認領 Mannequin 使用者
