---
name: sentry-triage
description: >
  Skill de triagem e resolução de erros capturados pelo Sentry em instância N8n self-hosted.
  Use quando o usuário reportar um erro do Sentry, colar um stack trace, ou pedir ajuda para
  investigar issues. Acessa a Sentry REST API via Python (com proxy da IDE) + correlaciona
  com workflows N8n via n8n MCP para diagnóstico completo e resolução guiada.
---

# Sentry Triage — Skill de Diagnóstico de Erros

## Quando Ativar
- Usuário menciona um erro do Sentry (issue ID, stack trace, mensagem de erro)
- Usuário pergunta "por que o workflow X está falhando?"
- Usuário cola uma mensagem de erro de um workflow N8n
- Usuário pede para investigar issues no painel do Sentry

---

## Contexto do Ambiente

| Item | Valor |
|------|-------|
| Plataforma | Sentry — `https://imma-ex.sentry.io` |
| Projeto Sentry | `node` |
| Org Slug | `imma-ex` |
| DSN (n8n) | `https://04e7a53fc9724b42cc0e4f39422e7049@o4510317758840832.ingest.us.sentry.io/4511360728236032` |
| Org ID | `o4510317758840832` |
| Project ID | `4511360728236032` |
| Integração | N8n self-hosted via Log Streaming nativo (`N8N_LOG_STREAMING_DESTINATIONS`) |
| Cron Monitor | `n8n-heartbeat` (check-in a cada 5 min) |
| Webhook alerta | `https://webhooks.immatecnologia.com.br/webhook/sentry-alert` |
| Credentials | `.env` nesta pasta (`imma/ops/sentry-triage/.env`) |

> **⚠️ Sem MCP Sentry**: O Sentry MCP (`https://mcp.sentry.dev/mcp`) **NÃO está configurado**
> nesta IDE. Todo acesso é feito via **Sentry REST API** usando Python com o proxy da IDE.

---

## Protocolo de Conexão (DEFINITIVO — não alterar)

### Passo 1 — Ler o token do `.env`

O agente deve sempre começar lendo as credenciais do arquivo local:

```
/home/marcos/Antigravity/.agent/Biblioteca_Global/imma/ops/sentry-triage/.env
```

Variáveis disponíveis:
- `SENTRY_AUTH_TOKEN` — Bearer token da REST API
- `SENTRY_ORG` — `imma-ex`
- `SENTRY_PROJECT` — `node`
- `SENTRY_BASE_URL` — `https://sentry.io/api/0`

### Passo 2 — Executar chamadas via Python (método correto e validado)

> **⚠️ CRÍTICO — Arquitetura de Rede da IDE:**
> A IDE opera em rede isolada. O terminal **não possui DNS externo nem rota direta à internet**.
> O proxy local (`127.0.0.1:40245`) é a **única rota de saída** — ele deve ser mantido ativo.
>
> **ERROS COMUNS A EVITAR:**
> - ❌ Remover variáveis de proxy (`os.environ.pop('https_proxy')`) → causa `Name or service not known`
> - ❌ Usar `--noproxy '*'` no curl → sem rota de saída, falha silenciosa
> - ❌ Usar `curl` diretamente → proxy retorna `403 Forbidden` para `CONNECT` tunnels HTTPS
>
> **SOLUÇÃO VALIDADA:** Python com proxy mantido + SSL não verificado (o proxy da IDE
> faz inspeção TLS, então o certificado do destino não é apresentado ao cliente):

```python
import urllib.request, json, ssl

TOKEN = "<valor de SENTRY_AUTH_TOKEN do .env>"
BASE  = "https://sentry.io/api/0"

# NÃO remover variáveis de proxy — o proxy da IDE é a rota de saída
# O proxy faz TLS inspection, então desabilitar verificação SSL é necessário
ssl_ctx = ssl._create_unverified_context()

def sentry_get(path):
    req = urllib.request.Request(
        f"{BASE}{path}",
        headers={"Authorization": f"Bearer {TOKEN}"}
    )
    with urllib.request.urlopen(req, context=ssl_ctx, timeout=15) as r:
        return json.loads(r.read())

def sentry_put(path, body):
    data = json.dumps(body).encode()
    req = urllib.request.Request(
        f"{BASE}{path}",
        data=data,
        headers={
            "Authorization": f"Bearer {TOKEN}",
            "Content-Type": "application/json"
        },
        method="PUT"
    )
    with urllib.request.urlopen(req, context=ssl_ctx, timeout=15) as r:
        return json.loads(r.read())
```

### Passo 3 — Queries úteis (usar `sentry_get` acima)

```python
# Listar todas as issues não resolvidas
issues = sentry_get("/projects/imma-ex/node/issues/?query=is:unresolved&limit=25&sort=date")

# Resumo compacto para triagem
for i in issues:
    print(i["shortId"], "|", i["level"], "|", i["count"], "|", i["title"][:80])

# Detalhes de uma issue específica
issue = sentry_get("/issues/<issue-id>/")

# Stack trace completo (último evento)
events = sentry_get("/issues/<issue-id>/events/?limit=1&full=true")

# Issues das últimas 24h
recent = sentry_get("/projects/imma-ex/node/issues/?query=is:unresolved&statsPeriod=24h")

# Marcar como ignorado (EventLoopBlocked falsos positivos)
sentry_put("/issues/<issue-id>/", {"status": "ignored"})

# Marcar como resolvido
sentry_put("/issues/<issue-id>/", {"status": "resolved"})
```

---

## Protocolo de Triagem

### Fase 1: Coleta

1. Ler `.env` → extrair `SENTRY_AUTH_TOKEN`
2. Executar `sentry_get("/projects/imma-ex/node/issues/?query=is:unresolved&limit=25&sort=date")`
3. Agrupar por tipo e prioridade

### Fase 2: Classificação

| Categoria | Exemplos | Ação |
|-----------|----------|------|
| **Configuração** | Credenciais expiradas, env var faltando | Corrigir config |
| **Código/Expressão** | TypeError, referência undefined | Corrigir nó do workflow |
| **Infraestrutura** | Timeout, connection refused, OOM | Investigar stack/rede |
| **Dependência Externa** | API 5xx, rate limit | Aguardar/retry |
| **Dados** | JSON inválido, campo ausente | Validar input |
| **Permissão** | 401/403, token expirado | Renovar credenciais |
| **Falso Positivo** | EventLoopBlocked (N8n interno) | Ignorar no Sentry |

### Fase 3: Diagnóstico

1. Analisar stack trace via `sentry_get("/issues/<id>/events/?limit=1&full=true")`
2. Identificar o nó N8n que falhou (`node.name`, `node.type`, `httpCode`)
3. Correlacionar com execuções via n8n MCP:
   - `n8n_executions(action="list", status="error", limit=5)`
   - `n8n_executions(action="get", id="<exec-id>", mode="error")`
4. Verificar padrões: `count`, `firstSeen`, recorrência

### Fase 4: Resolução

1. Propor correção com root cause claro
2. Aplicar via n8n MCP se possível (`n8n_update_partial_workflow`)
3. Validar executando o workflow
4. Marcar no Sentry: `sentry_put("/issues/<id>/", {"status": "resolved"})`

### Fase 5: Prevenção

- [ ] Error handler no workflow (`onError` → Error Workflow)
- [ ] Retry automático no nó crítico
- [ ] Validação de dados antes do nó crítico
- [ ] Alerta específico no Sentry para este tipo de erro

---

## Formato de Resposta

```markdown
## 🔴 Diagnóstico — [Título do Erro]

**Issue:** [shortId] — [permalink]
**Categoria:** [Configuração | Código | Infra | Dependência | Dados | Permissão | Falso Positivo]
**Severidade:** [Crítico | Alto | Médio | Baixo]
**Workflow afetado:** [Nome] (ID: [id])
**Nó com falha:** [Nome do nó]

### Root Cause
[Explicação concisa]

### Correção
[Passos ou código para corrigir]

### Prevenção
[O que fazer para evitar recorrência]
```

---

## Notas Importantes

- **Sem MCP Sentry** — usar REST API via Python (protocolo acima)
- **N8n usa Log Streaming nativo** — não Error Workflow — via `N8N_LOG_STREAMING_DESTINATIONS`
- **EventLoopBlocked** com `isUnhandled: false` são alertas de performance do N8n interno, não erros fatais — considerar ignorar no Sentry
- **Cron Monitor** `n8n-heartbeat` verifica disponibilidade a cada 5 minutos
- **Workflow de alerta** `[SYS] Sentry Alert → WhatsApp` (ID: `SBTfTUjQ1jO35q1g`)
