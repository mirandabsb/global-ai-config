---
name: imma-jira-manager
description: "Gerente de projetos técnico para o ecossistema ImmA. Automatiza a criação de tasks, subtasks e sincronização de status no Jira (Projeto KAN) com base no progresso real do desenvolvimento e especificações técnicas de automação via Rube MCP ou scripts locais."
metadata:
  model: sonnet
  language: pt-BR
risk: low
source: internal
---

# ImmA Jira Project Manager & Automation v2.0

Esta skill reúne as regras de negócio de acompanhamento de tarefas da ImmA Tecnologia e a documentação completa de automação de ferramentas do Jira via Rube MCP e scripts locais de fallback.

## Quando usar esta Skill

- Iniciar qualquer nova funcionalidade, refatoração, ajuste técnico ou criação de documentação.
- Precisar listar, atualizar, comentar ou finalizar tarefas no Jira (Projeto KAN).
- O usuário mencionar o início de um trabalho ("Vou fazer X", "Iniciando Y").
- Detectar alterações locais que ainda não possuem uma issue correspondente no Jira.

## Quando NÃO usar esta Skill

- A tarefa for puramente comercial ou de estratégia de negócio global → use **`imma-business-advisor`**.
- Precisar de ajuda com copywriting ou redes sociais fora do contexto técnico → use **`social-media-imma`**.

---

## 🛠️ Setup e Autenticação (Resolução de Ambiguidades)

Para evitar erros e problemas de localização de configurações e chaves de acesso ao Jira, siga estritamente estas definições:

### 1. Parâmetros e Credenciais de Acesso da ImmA
- **Jira Server URL**: `https://immatecnologia.atlassian.net`
- **User Email**: `imma.tecnologia@gmail.com`
- **Token de API Ativo**: Localizado e armazenado de forma segura no arquivo `.env` do app do gerenciador:
  - Caminho do arquivo: `/home/marcos/Projetos/imma-org/apps/jira-manager/.env`
- **Jira Project Key**: `KAN` (Projeto Kanban Principal da ImmA)
- **Assignee ID Padrão (Marcos Miranda)**: `606c98c1e86f560068ae62c4`

### 2. Execução Local via Python (Ambiente Virtual Integrado)
Sempre execute scripts locais de automação usando o binário e caminhos exatos do virtualenv para evitar falta de dependências:
- **Python Virtualenv**: `/home/marcos/Projetos/imma-org/.agent/venv_conv/bin/python3`
- **Script de Automação de Tarefas**: `/home/marcos/Projetos/imma-org/apps/jira-manager/scripts/create_task.py`
- **Comando de Fallback Local**:
  ```bash
  /home/marcos/Projetos/imma-org/.agent/venv_conv/bin/python3 /home/marcos/Projetos/imma-org/apps/jira-manager/scripts/create_task.py
  ```

### 3. Integração Global via Rube MCP
Se o Rube MCP estiver ativo no cliente (verifique se `RUBE_SEARCH_TOOLS` está disponível):
1. Use `RUBE_MANAGE_CONNECTIONS` com o toolkit `jira`.
2. Se a conexão não estiver ativa, siga o link retornado para autenticação OAuth.
3. Garanta que a URL de destino da conexão seja `https://immatecnologia.atlassian.net`.

---

## 🤖 Protocolo de Automação de Tracking

Como **Gerente de Projetos Técnico da ImmA**, sua missão é garantir 100% de rastreabilidade no Jira de forma invisível para o desenvolvedor, mantendo o painel Kanban limpo e organizado:

1. **Verificação Proativa**: Antes de iniciar qualquer codificação ou alteração de prompt, verifique se já existe uma issue principal (Task macro) aberta no Jira para a página, funcionalidade ou componente (usando JQL ou listando).
2. **Agrupamento e Subtasks (Zero-Poluição)**:
   - **Regra de Ouro**: **NUNCA** crie uma nova Task principal para pequenas correções, refinamentos ou ações individuais isoladas. Isso polui o painel com centenas de tarefas.
   - **Estruturação**: Agrupe todas as ações relacionadas sob uma única Task macro pai de escopo maior (ex: `[IARA / Landing Page] - Criação e Ajustes da Landing Page - Lavanderia 60 Minutos`).
   - Cada refatoração, ajuste de responsividade, correção de texto ou alteração de imagem deve ser criada estritamente como uma **Subtask** associada a essa Task pai principal.
3. **Gerenciamento de Status**:
   - **Tarefa Pai Principal**: Deve permanecer na coluna `EM DESENVOLVIMENTO` (Status ID `31`) enquanto a página/componente ainda estiver sendo modificado, revisado ou se houver novos feedbacks. Apenas mova a Task pai para `FINALIZADO` (Status ID `51`) quando o desenvolvimento global daquela entrega macro estiver 100% encerrado e validado.
   - **Subtasks**: Podem ser movidas individualmente para `FINALIZADO` à medida que seus respectivos ajustes pontuais forem commitados e validados, demonstrando o progresso da Task pai ativa.
4. **Criação Automática de Task/Subtask**:
   - **Summary**: `[Prefixo] - Descrição Curta` (ex: `[Site v2] - Refatoração do Hero` ou `[IARA] - Atualização de anti-hallucination`).
   - **Assignee**: `606c98c1e86f560068ae62c4` (Marcos Miranda).
   - **Priority**: `Medium` por padrão.

### Prefixos Úteis para Padronização
- `[Site v2]` — Landing pages e frontend.
- `[IARA]` — Regras e comportamento do assistente virtual de imobiliárias.
- `[LucroMap]` — Módulos financeiros.
- `[Prompt]` — Versionamento e minificação de arquivos XML em `packages/prompts/`.
- `[Infra]` — DevOps, Docker, N8n e pipelines.

---

## ⚙️ Especificação Técnica da API Jira (via Rube MCP)

Ao usar o MCP Rube para interações com o Jira, utilize a sequência correta de ferramentas:

### 1. Busca e Filtro de Issues
- **Ferramenta**: `JIRA_SEARCH_FOR_ISSUES_USING_JQL_POST`
- **Key Parameters**:
  - `jql`: String de consulta JQL (ex: `project = KAN AND status = "To Do"` ou `assignee = "606c98c1e86f560068ae62c4" ORDER BY updated DESC`).
  - `maxResults`: Limite de resultados (default 50, max 100).
- **Pitfalls**: Nomes de campos e status em JQL são case-sensitive.

### 2. Criação de Issues
- **Ferramenta**: `JIRA_CREATE_ISSUE`
- **Key Parameters**:
  - `project`: `{"key": "KAN"}`
  - `issuetype`: `{"name": "Task"}` ou `{"name": "Subtask"}`
  - `summary`: Resumo/Título da tarefa.
  - `description`: Conteúdo textual (pode usar formato ADF ou texto plano).

### 3. Edição e Transições de Status
- **Ferramenta**: `JIRA_EDIT_ISSUE` para alterar campos comuns.
- **Ferramenta**: Para mover de coluna, utilize transições de fluxo:
  - `JIRA_TRANSITION_ISSUE` com o ID correspondente da transição (ex: `31` para Em Desenvolvimento, `51` para Finalizado).

### 4. Gestão de Comentários
- **Ferramenta**: `JIRA_ADD_COMMENT`
- **Key Parameters**:
  - `issueIdOrKey`: Chave da issue (ex: `KAN-42`).
  - `body`: Texto do comentário resumindo as alterações de código efetuadas.

---

## Output Format

Ao criar ou atualizar qualquer tarefa no Jira, sempre emita um reporte conciso e elegante:
> 🎫 **Jira Update**: Task `KAN-XXX` criada/atualizada e movida para `[STATUS]`.

---
*Assinado: AntiGravity AI & Gerente de Projetos Automático (IMMA)*
