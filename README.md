# GitHub to GitHub EMU 遷移 Guidance

本專案提供從標準 GitHub Enterprise Cloud (GHEC) 遷移至 GitHub Enterprise Managed Users (EMU) 環境的自動化腳本與指導文件，協助組織實現集中式身份管理、強化安全性與合規性。

## Test for Demo PMA
- Test for Demo PMA
- Test for Demo PMA
- Test for Demo PMA
- Test for Demo PMA
- Test for Demo PMA
- Test for Demo PMA
- Test for Demo PMA
- Test for Demo PMA

## 專案結構

```
github-migration-guide/
├── README.md                              # 本文件
├── guidance/                              # 遷移指導文件
│   ├── Migration-Life-Cycle.md            # 遷移生命週期總覽
│   ├── Part1-Discovery&Decision.md
│   ├── Part2-Pre-MigrationPreparation.md
│   ├── Part3-Identity&Access-Setup.md
│   ├── Part4-Security&Compliance.md
│   ├── Part5-MigrationExecution.md
│   └── Part6-Validation&Adoption.md
└── scripts/                               # 自動化腳本
    ├── powershell/                        # PowerShell 版本（Windows）
    │   ├── 0-prep.ps1
    │   ├── 1-repo-inventory.ps1
    │   ├── 2-pre-migration-cleanup.ps1
    │   ├── 3-exec-migration.ps1
    │   └── 4-reclaim-mannequins.ps1
    └── shell/                             # Shell 版本（Linux/macOS）
        ├── 0-prep.sh
        ├── 1-repo-inventory.sh
        ├── 2-pre-migration-cleanup.sh
        ├── 3-exec-migration.sh
        └── 4-reclaim-mannequins.sh
```

## 先決條件

| 工具 | 最低版本 | 說明 |
|------|----------|------|
| [GitHub CLI](https://cli.github.com/) | v2.4.0+ | 基礎命令列工具 |
| [gh-repo-stats](https://github.com/mona-actions/gh-repo-stats) 擴充套件 | - | 產生儲存庫盤點清單 |
| [gh-gei](https://github.com/github/gh-gei) 擴充套件 | - | GitHub Enterprise Importer 遷移工具 |
| jq | - | JSON 查詢與處理工具 |
| git | - | 版本控制操作 |
| PowerShell 7+ 或 Bash | - | 依選用的腳本版本決定 |

## 遷移生命週期

遷移分為 **6 個階段**，其中第 5-6 階段會依群組反覆執行：

| 階段 | 名稱 |
|------|------|
| Phase 1 | 探索與決策 (Discovery & Decision) |
| Phase 2 | 遷移前準備 (Pre-Migration Preparation) |
| Phase 3 | 身份與存取設定 (Identity & Access Setup) |
| Phase 4 | 安全性與合規性 (Security & Compliance) |
| Phase 5 | 遷移執行 (Migration Execution) |
| Phase 6 | 驗證與採用 (Validation & Adoption) |

> Phase 5-6 採用分群組逐步遷移策略，而非一次性大規模遷移，以降低風險。

## 腳本說明

所有腳本位於 `scripts/` 目錄下，分別提供 PowerShell（`scripts/powershell/`）與 Shell（`scripts/shell/`）兩種版本，功能相同，請依作業系統擇一使用並依序執行。

### 0-prep — 環境準備

安裝 GitHub CLI（最低 v2.4.0）、`gh-repo-stats`、`gh-gei` 擴充套件及 jq 等基礎工具。

### 1-repo-inventory — 儲存庫盤點

使用 `gh-repo-stats` 擴充套件產生來源組織所有儲存庫的盤點清單（`inventory.csv`），包含大小、協作者數量、保護分支等資訊。

### 2-pre-migration-cleanup — 遷移前清理

盤點現況：

- 辨識過去一年無活動的儲存庫
- 辨識超過 90 天的 Pull Request
- 辨識超過 6 個月無活動的 Issue
- 列出已合併及過時的分支
- 稽核 Webhook 與 GitHub App 整合
- 列出團隊與成員

### 3-exec-migration — 執行遷移

使用 GitHub Enterprise Importer (`gh-gei`) 執行實際遷移：

- 組織層級遷移 (`gh gei migrate-org`)
- 個別儲存庫遷移 (`gh gei migrate-repo`)
- 產生遷移腳本 (`gh gei generate-script`)

### 4-reclaim-mannequins — 認領 Mannequin

將遷移過程中產生的佔位使用者 (Mannequin) 對應至實際的 Managed User。

## 指導文件

`guidance/` 目錄下提供完整的遷移指導文件：

| 文件 | 內容 |
|------|------|
| [Migration-Life-Cycle](guidance/Migration-Life-Cycle.md) | 遷移生命週期總覽 |
| [Part1 - Discovery & Decision](guidance/Part1-Discovery&Decision.md) | 探索與決策：定義遷移目標、評估 EMU 適合性 |
| [Part2 - Pre-Migration Preparation](guidance/Part2-Pre-MigrationPreparation.md) | 遷移前準備：盤點現況、IdP 就緒驗證、技術債清理 |
| [Part3 - Identity & Access Setup](guidance/Part3-Identity&Access-Setup.md) | 身份與存取：SCIM 佈建設定、團隊建立 |
| [Part4 - Security & Compliance](guidance/Part4-Security&Compliance.md) | 安全性與合規性：稽核日誌、安全政策、CI/CD 更新 |
| [Part5 - Migration Execution](guidance/Part5-MigrationExecution.md) | 遷移執行：GEI 操作、Mannequin 認領 |
| [Part6 - Validation & Adoption](guidance/Part6-Validation&Adoption.md) | 驗證與採用：測試、使用者培訓、上線監控 |

## 快速開始

以下以 Shell 版本為例（Windows 使用者請改用 `scripts/powershell/` 下對應的 `.ps1` 檔案）：

1. 執行 `scripts/shell/0-prep.sh` 安裝必要工具
2. 設定環境變數（來源/目標組織、PAT 等）
3. 執行 `scripts/shell/1-repo-inventory.sh` 盤點來源組織儲存庫
4. 執行 `scripts/shell/2-pre-migration-cleanup.sh` 進行遷移前清理
5. 執行 `scripts/shell/3-exec-migration.sh` 進行實際遷移
6. 執行 `scripts/shell/4-reclaim-mannequins.sh` 認領 Mannequin 使用者