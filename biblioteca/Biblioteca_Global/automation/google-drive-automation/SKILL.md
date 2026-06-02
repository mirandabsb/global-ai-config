---
name: google-drive-automation
description: "Automate Google Drive file operations (upload, download, search, share, organize) via the official Google Drive MCP server (drivemcp.googleapis.com). Manage files, folders, permissions, and search across drives using OAuth 2.0 authentication."
requires:
  mcp: [google-drive]
risk: medium
source: google-official
---

# Google Drive Automation via Google Drive MCP (Official)

Automate Google Drive workflows including file search, read, create, download, folder management, sharing/permissions, and organization through Google's official Drive MCP server.

> **Note:** This skill was previously based on Rube MCP (Composio), which was discontinued on May 15, 2026. It now uses the official Google Drive MCP server maintained by Google.

## Prerequisites

- Google Drive MCP server configured in `mcp_config.json` with OAuth 2.0 credentials
- A Google Cloud project with the following APIs enabled:
  - `drive.googleapis.com` (Google Drive API)
  - `drivemcp.googleapis.com` (Google Drive MCP API)
- OAuth 2.0 Client ID configured with appropriate redirect URIs
- OAuth Consent Screen configured with Drive scopes

## Setup

### 1. Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable the APIs:
   ```bash
   gcloud services enable drive.googleapis.com --project=YOUR_PROJECT_ID
   gcloud services enable drivemcp.googleapis.com --project=YOUR_PROJECT_ID
   ```
3. Create an OAuth 2.0 Client ID (Desktop App or Web Application)
4. Configure the OAuth Consent Screen with scopes:
   - `https://www.googleapis.com/auth/drive.readonly`
   - `https://www.googleapis.com/auth/drive.file`

### 2. MCP Configuration

Add to your `mcp_config.json`:

```json
"google-drive": {
  "type": "http",
  "url": "https://drivemcp.googleapis.com/mcp/v1",
  "serverUrl": "https://drivemcp.googleapis.com/mcp/v1",
  "oauth": {
    "enabled": true,
    "clientId": "YOUR_OAUTH_CLIENT_ID",
    "clientSecret": "YOUR_OAUTH_CLIENT_SECRET",
    "scopes": [
      "https://www.googleapis.com/auth/drive.readonly",
      "https://www.googleapis.com/auth/drive.file"
    ]
  }
}
```

### 3. Authentication

After adding the configuration, restart the IDE. The MCP server will prompt you to authenticate via browser on first use.

## Available Tools

The official Google Drive MCP server provides 7 tools:

| Tool | Description |
|------|-------------|
| `search_files` | Search for files using Drive query syntax |
| `read_file_content` | Read the content of a file |
| `create_file` | Create a new file in Google Drive |
| `download_file_content` | Download file content |
| `get_file_metadata` | Get metadata for a file |
| `get_file_permissions` | List permissions on a file |
| `list_recent_files` | List recently accessed files |

## Core Workflows

### 1. Search and Find Files

**When to use**: User wants to find specific files or browse Drive contents

**Tool sequence**:
1. `search_files` - Search by name, content, type, date, or folder [Required]
2. `get_file_metadata` - Get detailed file info [Optional]
3. `get_file_permissions` - Check who has access [Optional]

**Query syntax examples**:
- Name search: `"name contains 'report'"` or `"name = 'exact.pdf'"`
- Type filter: `"mimeType = 'application/pdf'"` or `"mimeType = 'application/vnd.google-apps.folder'"`
- Folder scoping: `"'FOLDER_ID' in parents"`
- Date filter: `"modifiedTime > '2024-01-01T00:00:00'"`
- Combine: `"name contains 'report' and trashed = false"`
- Boolean: `"sharedWithMe = true"`, `"starred = true"`

### 2. Read and Download Files

**When to use**: User wants to read or download file content

**Tool sequence**:
1. `search_files` - Locate the file [Prerequisite]
2. `read_file_content` - Read file content (text-based files) [Required]
3. `download_file_content` - Download binary content [Alternative]

**Pitfalls**:
- `read_file_content` works best with Google Workspace files (Docs, Sheets, Slides) and text-based files
- For binary files (images, PDFs), use `download_file_content`

### 3. Create Files

**When to use**: User wants to create new files in Google Drive

**Tool sequence**:
1. `search_files` - Find target folder [Optional]
2. `create_file` - Create the file [Required]
3. `get_file_metadata` - Verify creation [Optional]

### 4. Browse Recent Files

**When to use**: User wants to see what they've been working on recently

**Tool sequence**:
1. `list_recent_files` - Get recently accessed files [Required]
2. `read_file_content` - Read a specific file [Optional]

### 5. Check Permissions

**When to use**: User wants to audit who has access to files

**Tool sequence**:
1. `search_files` - Find the file [Prerequisite]
2. `get_file_permissions` - List all permissions [Required]

## Common Patterns

### Query Syntax Reference
Google Drive uses a specific query language:
- Name search: `"name contains 'report'"` or `"name = 'exact.pdf'"`
- Type filter: `"mimeType = 'application/pdf'"`
- Folder type: `"mimeType = 'application/vnd.google-apps.folder'"`
- Folder scoping: `"'FOLDER_ID' in parents"`
- Date filter: `"modifiedTime > '2024-01-01T00:00:00'"`
- Combine with `and`/`or`/`not`: `"name contains 'report' and trashed = false"`
- Boolean filters: `"sharedWithMe = true"`, `"starred = true"`, `"trashed = false"`
- Owner filter: `"'user@example.com' in owners"`

### File Type MIME References
| Type | MIME |
|------|------|
| Google Doc | `application/vnd.google-apps.document` |
| Google Sheet | `application/vnd.google-apps.spreadsheet` |
| Google Slides | `application/vnd.google-apps.presentation` |
| Folder | `application/vnd.google-apps.folder` |
| PDF | `application/pdf` |
| CSV | `text/csv` |

## Known Pitfalls

- **Wildcards NOT supported**: Use `contains` operator instead of `*` for partial matching
- **Query complexity**: >5-10 OR clauses may error "The query is too complex"; split into multiple queries
- **'My Drive' root**: Use `'root' in parents` to search root folder (not searchable by name)
- **Owner syntax**: Use `'user@example.com' in owners` (NOT `owner:user@example.com`)
- **Scope limitations**: `drive.readonly` allows read; `drive.file` allows read/write only on files created by the app. For full write access, add `drive` scope
- **OAuth flow**: First authentication requires browser interaction; tokens are cached after that

## Security Considerations

> ⚠️ **Indirect Prompt Injection Risk**: When exposing a language model to untrusted Drive data, there is a risk of indirect prompt injection. Avoid processing documents from unverified sources. Always review actions before execution.

## Quick Reference

| Task | Tool | Key Params |
|------|------|------------|
| Search files | `search_files` | query string, Drive query syntax |
| Read content | `read_file_content` | file ID |
| Create file | `create_file` | name, content, parent folder |
| Download file | `download_file_content` | file ID, export format |
| File metadata | `get_file_metadata` | file ID |
| Permissions | `get_file_permissions` | file ID |
| Recent files | `list_recent_files` | (none) |

## When to Use
This skill is applicable whenever the user needs to interact with Google Drive: searching files, reading documents, creating content, checking permissions, or browsing recent activity.
