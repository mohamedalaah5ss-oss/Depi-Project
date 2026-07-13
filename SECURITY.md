# Security Policy

## Supported Versions

This is a solo educational/portfolio project. Only the latest commit on `main` is actively maintained.

| Version | Supported |
|---------|:---------:|
| Latest (`main`) | ✅ |
| Older commits | ❌ |

---

## Credential & Secret Handling

This project uses a **least-privilege security model** for all cloud credentials:

- **Azure Blob Storage** access is granted via **SAS tokens** (Shared Access Signatures) scoped to specific containers and time windows — no storage account keys are ever used in application code.
- **Snowflake** credentials (account, user, password, warehouse, database, schema) are stored exclusively in a `.env` file, which is listed in `.gitignore` and **never committed to version control**.
- The `.env.example` file contains only placeholder values — no real credentials appear anywhere in commit history.

### ⚠️ For Reviewers
If you are running this project locally, create your own `.env` file from `.env.example` and populate it with your own credentials. Do not share or commit the populated `.env` file.

---

## Reporting a Vulnerability

This is a non-production educational project and does not operate live infrastructure. However, if you discover a security concern (e.g., accidentally committed credentials in history):

1. **Do not open a public GitHub Issue.**
2. Contact the maintainer directly via GitHub profile: [@mohamedalaah5ss-oss](https://github.com/mohamedalaah5ss-oss)
3. Include a description of the concern and the affected file or commit.

Responses will be best-effort for this project scope.
