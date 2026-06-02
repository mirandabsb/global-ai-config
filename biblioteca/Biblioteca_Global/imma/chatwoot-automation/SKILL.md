---
name: chatwoot-automation
description: "Automate Chatwoot operations via Application API: manage contacts, conversations, outbound/inbound messages, private notes, labels, agent assignments, and custom attributes. Custom tailored for the self-hosted ImmA instance."
requires:
  mcp: [firecrawl-mcp, context7]
risk: low
source: community
---

# Chatwoot Automation and API Integration

This skill provides comprehensive documentation and patterns to integrate and automate operations on Chatwoot—an open-source, omni-channel customer support platform—specifically tailored for self-hosted environments like the ImmA Tecnologia workspace.

## 📚 Base de Conhecimento Local (Knowledge Base)

> O projeto possui uma base de conhecimento atualizada com a documentação oficial (Help Center) do Chatwoot, catalogada em Markdown. Use esta base para buscar detalhes de uso, filtros, SLAs e relatórios.

**Localização da Base:** `/home/marcos/Link para Projetos/imma-org/docs/tecnico/Chatwoot/Base Dados/`
**Arquivo de Índice Geral:** `/home/marcos/Link para Projetos/imma-org/docs/tecnico/Chatwoot/Base Dados/_INDEX.md`

**Sempre que precisar de informações sobre funcionalidades, regras de negócio ou uso da interface do Chatwoot (ex: SLAs, CSAT, Automações, Campanhas, Relatórios), consulte primeiro o `_INDEX.md` para encontrar o arquivo correto e, em seguida, leia o conteúdo na Base de Dados antes de responder.**

---

## 🔑 CONEXÕES ATIVAS — ImmA Tecnologia (usar SEMPRE, sem buscar em outro lugar)

> Credenciais definitivas de produção para ambas as instâncias do Chatwoot. **Nunca** pergunte ao usuário por token ou URL — use os valores abaixo diretamente. Skill localizada em `Biblioteca_Global/business/imma/chatwoot-automation/`.

### 1. Instância de Produção / Clientes (chat.immatecnologia.com.br)
*   **Finalidade**: Atendimento de clientes e canais de produção.
*   **Base URL**: `https://chat.immatecnologia.com.br`
*   **API Access Token**: `6nMAYEGAV1Ek3be7sQPSHubW`
*   **Account ID**: `1`

```bash
export CHATWOOT_PROD_URL="https://chat.immatecnologia.com.br"
export CHATWOOT_PROD_TOKEN="6nMAYEGAV1Ek3be7sQPSHubW"
export CHATWOOT_PROD_ACCOUNT_ID="1"
```

### 2. Instância de Suporte Técnico / Admin (suporte.immatecnologia.com.br)
*   **Finalidade**: Suporte técnico e administração interna de infraestrutura.
*   **Base URL**: `https://suporte.immatecnologia.com.br`
*   **API Access Token**: `59pzJ8RTisGigGYzdDtv2A37`
*   **Account ID**: `1`

```bash
export CHATWOOT_SUPORTE_URL="https://suporte.immatecnologia.com.br"
export CHATWOOT_SUPORTE_TOKEN="59pzJ8RTisGigGYzdDtv2A37"
export CHATWOOT_SUPORTE_ACCOUNT_ID="1"
```

---

**Padrões de chamadas:**

*   **Instância de Produção:**
    ```bash
    curl -s -X GET "https://chat.immatecnologia.com.br/api/v1/accounts/1/ENDPOINT" \
      -H "api_access_token: ${CHATWOOT_API_TOKEN}" \
      -H "Content-Type: application/json"
    ```

*   **Instância de Suporte Técnico:**
    ```bash
    curl -s -X GET "https://suporte.immatecnologia.com.br/api/v1/accounts/1/ENDPOINT" \
      -H "api_access_token: ${CHATWOOT_API_TOKEN}" \
      -H "Content-Type: application/json"
    ```

---

## Core Workflows and Endpoints

### 1. Contacts Management

**When to use**: Search for existing customers, create new contacts, or update contact custom attributes and labels.

#### A. Find/Search Contacts
- **Method**: `GET`
- **Endpoint**: `/api/v1/accounts/{accountId}/contacts/search`
- **Query Parameters**:
  - `q`: Search query (email, phone, name, or identifier)
  - `page`: Page number (for pagination)
- **Request Example**:
  ```bash
  curl -X GET "https://chat.immatecnologia.com.br/api/v1/accounts/1/contacts/search?q=jane@example.com" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json"
  ```
- **Response Shape**:
  ```json
  {
    "payload": [
      {
        "id": 42,
        "name": "Jane Doe",
        "email": "jane@example.com",
        "phone_number": "+5511999999999",
        "identifier": "client-uuid-123"
      }
    ]
  }
  ```

#### B. Create Contact
- **Method**: `POST`
- **Endpoint**: `/api/v1/accounts/{accountId}/contacts`
- **Request Body**:
  - `name` (string) - Required - Contact's full name.
  - `email` (string) - Optional - Email address.
  - `phone_number` (string) - Optional - Phone number (E.164 format highly recommended, e.g., `+5511999999999`).
  - `identifier` (string) - Optional - External unique identifier (CRM ID, user UUID, etc.).
  - `custom_attributes` (object) - Optional - Key-value pair metadata.
- **Request Example**:
  ```bash
  curl -X POST "https://chat.immatecnologia.com.br/api/v1/accounts/1/contacts" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "name": "Jane Doe",
      "email": "jane@example.com",
      "phone_number": "+5511999999999",
      "identifier": "client-uuid-123",
      "custom_attributes": {
        "cnpj": "12.345.678/0001-90",
        "segmento": "tecnologia"
      }
    }'
  ```

#### C. Update Contact Custom Attributes / Labels
- **Method**: `PUT`
- **Endpoint**: `/api/v1/accounts/{accountId}/contacts/{contactId}`
- **Request Body**: Same properties as create, but updates existing ones.
- **Request Example**:
  ```bash
  curl -X PUT "https://chat.immatecnologia.com.br/api/v1/accounts/1/contacts/42" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "custom_attributes": {
        "cnpj": "12.345.678/0001-90",
        "status_financeiro": "adimplente"
      }
    }'
  ```

---

### 2. Conversations Management

**When to use**: Create chat tickets, assign conversations to teams or agents, assign labels, or toggle resolution status.

#### A. Create New Conversation
- **Method**: `POST`
- **Endpoint**: `/api/v1/accounts/{accountId}/conversations`
- **Request Body**:
  - `source_id` (string) - Required - The inbox channel session ID or phone ID.
  - `inbox_id` (integer) - Required - Numeric ID of the inbox where the conversation belongs.
  - `contact_id` (integer) - Required - Numeric ID of the contact starting the ticket.
  - `custom_attributes` (object) - Optional - Custom attribute fields for the conversation.
- **Request Example**:
  ```bash
  curl -X POST "https://chat.immatecnologia.com.br/api/v1/accounts/1/conversations" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "inbox_id": 2,
      "contact_id": 42,
      "custom_attributes": {
        "urgencia": "alta",
        "departamento": "suporte"
      }
    }'
  ```

#### B. Toggle Conversation Status (Resolution / Open)
- **Method**: `POST`
- **Endpoint**: `/api/v1/accounts/{accountId}/conversations/{conversationId}/toggle_status`
- **Request Body**:
  - `status` (string) - Required - Target status. Accepted values: `open`, `resolved`, `pending`, `snoozed`.
- **Request Example**:
  ```bash
  curl -X POST "https://chat.immatecnologia.com.br/api/v1/accounts/1/conversations/123/toggle_status" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "status": "resolved"
    }'
  ```

#### C. Add / Overwrite Conversation Labels
- **Method**: `POST`
- **Endpoint**: `/api/v1/accounts/{accountId}/conversations/{conversationId}/labels`
- **Request Body**:
  - `labels` (array of strings) - Required - Overwrites the entire label list.
- **Request Example**:
  ```bash
  curl -X POST "https://chat.immatecnologia.com.br/api/v1/accounts/1/conversations/123/labels" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "labels": ["suporte-tecnico", "prioridade-alta"]
    }'
  ```

#### D. Update Conversation Custom Attributes
- **Method**: `POST`
- **Endpoint**: `/api/v1/accounts/{accountId}/conversations/{conversationId}/custom_attributes`
- **Request Body**:
  - `custom_attributes` (object) - Required - Key-value pair configuration.
- **Request Example**:
  ```bash
  curl -X POST "https://chat.immatecnologia.com.br/api/v1/accounts/1/conversations/123/custom_attributes" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "custom_attributes": {
        "cnpj_vinculado": "12.345.678/0001-90",
        "ticket_jira": "KAN-148"
      }
    }'
  ```

---

### 3. Messages & Notification Dispatch

**When to use**: Send a direct message to a user or post a private note (internal team-only comments).

- **Method**: `POST`
- **Endpoint**: `/api/v1/accounts/{accountId}/conversations/{conversationId}/messages`
- **Request Body**:
  - `content` (string) - Required - The message string body.
  - `message_type` (string) - Optional - Set to `outgoing` (agent message), `incoming` (user message), or `activity` (system note). Defaults to `outgoing`.
  - `private` (boolean) - Optional - If `true`, creates a yellow/internal note visible only to agents and hidden from the customer. Defaults to `false`.
- **Request Example**:
  ```bash
  curl -X POST "https://chat.immatecnologia.com.br/api/v1/accounts/1/conversations/123/messages" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "content": "Atenção Equipe: Este cliente está aguardando retorno da migração do banco.",
      "message_type": "outgoing",
      "private": true
    }'
  ```

---

### 4. Routing & Assignments (Teams/Agents)

**When to use**: Assign conversations automatically to agents or departments (Teams).

#### A. Assign to Agent
- **Method**: `POST`
- **Endpoint**: `/api/v1/accounts/{accountId}/conversations/{conversationId}/assignments`
- **Request Body**:
  - `assignee_id` (integer) - Required - The numeric ID of the target agent.
- **Request Example**:
  ```bash
  curl -X POST "https://chat.immatecnologia.com.br/api/v1/accounts/1/conversations/123/assignments" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "assignee_id": 5
    }'
  ```

#### B. Assign to Team (Departmental Routing)
- **Method**: `POST`
- **Endpoint**: `/api/v1/accounts/{accountId}/conversations/{conversationId}/assignments`
- **Request Body**:
  - `team_id` (integer) - Required - The numeric ID of the Chatwoot team (e.g., `Suporte` or `Treinamento`).
- **Request Example**:
  ```bash
  curl -X POST "https://chat.immatecnologia.com.br/api/v1/accounts/1/conversations/123/assignments" \
    -H "api_access_token: YOUR_ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "team_id": 3
    }'
  ```

---

## Standard n8n Nodes Configuration Pattern

For workflows integrating with Chatwoot using HTTP Request nodes:

### 1. Credentials config
- **Authentication**: `Header Auth`
- **Name**: `api_access_token`
- **Value**: `{{ $credentials.api_access_token }}`

### 2. HTTP Node parameters
- **URL**: `https://chat.immatecnologia.com.br/api/v1/accounts/1/conversations/{{ $json.conversation_id }}/messages`
- **Method**: `POST`
- **Headers**:
  - `Content-Type`: `application/json`
  - `api_access_token`: `{{ $credentials.api_access_token }}`
- **JSON/Body Parameters**:
  ```json
  {
    "content": "Ticket ID: {{ $json.ticket_id }} criado no banco local com sucesso.",
    "message_type": "outgoing",
    "private": true
  }
  ```

---

## Known Pitfalls & Best Practices

1. **Label Overwrite**: Using the `/conversations/{id}/labels` POST endpoint **overwrites all existing labels**. Always fetch active conversation labels first via `GET /conversations/{id}` and merge them before pushing if you intend to append.
2. **Private Notes visiblity**: Setting `"private": true` is absolutely critical for system logs, warnings, or debug actions. If omitted or set to `false`, the text is sent directly to the customer's WhatsApp/email via the connected channel.
3. **E.164 format in phone numbers**: Chatwoot is strict with phone number formats. Prepend the country code and remove spaces or dashes (e.g., `+5511999999999` for Brazil) to prevent sync anomalies.
4. **Custom Attributes Definition**: Before setting custom attributes on contacts or conversations via API, they **must be created beforehand** in the Chatwoot Settings UI (`/settings/attributes`). Pushing unregistered keys may result in no-ops or errors.
5. **Rate Limits (Self-Hosted)**: Ensure server rate limits (configured in Chatwoot's Redis/Rack-Attack configuration) aren't breached. When dispatching massive bulk alerts or logs, insert a dynamic `Wait` or `Debounce` mechanism.

---

## Quick Reference API Mapping

| Action | HTTP Method | Endpoint Path | Key Payloads |
|---|---|---|---|
| **Search Contact** | `GET` | `/api/v1/accounts/{accId}/contacts/search` | `?q=query` |
| **Create Contact** | `POST` | `/api/v1/accounts/{accId}/contacts` | `name`, `email`, `phone_number` |
| **Update Contact** | `PUT` | `/api/v1/accounts/{accId}/contacts/{id}` | `custom_attributes` |
| **Create Ticket** | `POST` | `/api/v1/accounts/{accId}/conversations` | `inbox_id`, `contact_id` |
| **Set status** | `POST` | `/api/v1/accounts/{accId}/conversations/{id}/toggle_status` | `status: resolved/open/pending` |
| **Add Label** | `POST` | `/api/v1/accounts/{accId}/conversations/{id}/labels` | `labels: ["tag1", "tag2"]` |
| **Send Message** | `POST` | `/api/v1/accounts/{accId}/conversations/{id}/messages` | `content`, `message_type`, `private` |
| **Assign Agent** | `POST` | `/api/v1/accounts/{accId}/conversations/{id}/assignments` | `assignee_id: integer` |
| **Assign Team** | `POST` | `/api/v1/accounts/{accId}/conversations/{id}/assignments` | `team_id: integer` |
