# 遷移至 GitHub Enterprise Managed Users 完整指南 - 第 1 部分：探索與決策

> **📚 系列：遷移至 GitHub Enterprise Managed Users 完整指南**
>
> **本系列內容取自 [The Complete Guide to Migrating to GitHub Enterprise Managed Users](https://github.com/orgs/community/discussions/189382)，並根據經驗進行了本地化調整**
>
> | 部分 | 主題 |
> |------|------|
> | [第 1 部分：探索與決策](Part1-Discovery&Decision.md)| 定義目標、評估適用性、取得共識 |
> | [第 2 部分：遷移前準備](Part2-Pre-MigrationPreparation.md) | 盤點、清理、IdP 準備、使用者溝通 |
> | [第 3 部分：身分識別與存取設定](Part3-Identity&Access-Setup.md) | 設定 SCIM、佈建使用者、建立團隊 |
> | [第 4 部分：安全性與合規性](Part4-Security&Compliance.md)  | 稽核記錄、安全強化、整合 |
> | [第 5 部分：遷移執行](Part5-MigrationExecution.md) | 執行 GEI、遷移儲存庫 |
> | [第 6 部分：驗證與採用](Part6-Validation&Adoption.md) | 測試、使用者培訓、OSS 策略、正式上線 |

---

## 遷移階段概覽

本指南拆分為六個不同階段，幫助你追蹤進度並確保沒有遺漏：

```mermaid
flowchart LR
    P1["第 1 階段 探索與 決策"] --> P2["第 2 階段 遷移前 準備"]
    P2 --> P3["第 3 階段 身分識別與 存取設定"]
    P3 --> P4["第 4 階段 安全性與 合規性"]
    P4 --> P5["第 5 階段 遷移 執行"]
    P5 --> P6["第 6 階段 驗證與 採用"]
    P6 -->|"針對每個群組 重複執行"| P5
    
    style P1 fill:#e1f5fe,stroke:#0288d1,color:#333
    style P2 fill:#fff3e0,stroke:#f57c00,color:#333
    style P3 fill:#e8f5e9,stroke:#388e3c,color:#333
    style P4 fill:#f3e5f5,stroke:#7b1fa2,color:#333
    style P5 fill:#fce4ec,stroke:#c2185b,color:#333
    style P6 fill:#e0f2f1,stroke:#00796b,color:#333
```

| 階段 | 重點 | 關鍵活動 | 時程 |
|------|------|----------|------|
| **第 1 階段** | 探索與決策 | 定義目標、評估適用性、取得共識 | 
| **第 2 階段** | 遷移前準備 | 盤點、清理、IdP 準備、使用者溝通 |
| **第 3 階段** | 身分識別與存取設定 | 設定 SCIM、佈建使用者、建立團隊 |
| **第 4 階段** | 安全性與合規性  | 稽核記錄、安全強化、整合 | 
| **第 5 階段** | 遷移執行 | 執行 GEI、遷移儲存庫、回收 mannequins |
| **第 6 階段** | 驗證與採用 | 測試、使用者培訓、OSS 策略、正式上線 |

- **第 1-4 階段**是循序執行且只做一次
- **第 5-6 階段是反覆執行**，你需要針對每個團隊、部門或儲存庫群組重複執行，**不要嘗試一次遷移所有人**

---

> **📚 EMU 遷移指南系列導覽**
>
> ➡️ **下一篇：[第 1 部分 - 探索與決策](Part1-Discovery&Decision.md)**
>
> ---

