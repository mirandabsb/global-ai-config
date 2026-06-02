# PLAN: Backup Workflow Redesign

## Problema

O workflow `TxyFfViEjQXf1E2i` usa tags do n8n para determinar a pasta de destino, mas as tags **não correspondem** às pastas reais no repositório. Resultado: arquivos em pastas erradas.

## Estrutura real do repositório (main)

```
PASTA/nome_do_workflow.json
```

O nome do workflow **começa** com o nome da pasta:
- `Clinica_Medica/IARA_Saude_agendamento v3.1.json` ❌ (nome não começa com "Clinica_Medica")
- `IARA/IARA_agendamento_v3.0.json` ✅ (nome começa com "IARA")
- `Tecnoweb/Tecnoweb_Retry_Historico_v1.0.json` ✅

> [!IMPORTANT]
> A regra "nome começa com pasta" **não funciona** para `Clinica_Medica` — os workflows lá começam com `IARA_Saude_`, não `Clinica_Medica_`.

## Pergunta para o usuário

Antes de implementar, preciso de clareza em **1 ponto**:

### Como mapear `IARA_Saude_*` para a pasta correta?

| Opção | Descrição | Prós | Contras |
|-------|-----------|------|---------|
| **A. Renomear pasta** | `Clinica_Medica/` → `IARA_Saude/` no repo | Nome = prefixo do workflow, sem mapeamento manual | Muda a estrutura existente |
| **B. Mapeamento explícito** | Tabela fixa no código: `IARA_Saude → Clinica_Medica` | Mantém estrutura atual | Precisa manter a tabela manualmente |
| **C. TAG do n8n como fonte** | Corrigir as tags no n8n para corresponder às pastas | Single source of truth | Precisa auditar/corrigir todas as tags |

## Proposta: Opção A (recomendada)

Renomear as pastas no repo para que correspondam ao **prefixo real** dos workflows. Isso elimina toda necessidade de mapeamento:

```
TAG/workflow         →  PREFIXO/workflow
Clinica_Medica/      →  IARA_Saude/
IARA Imobiliaria/    →  IARA_imob/
```

**Lógica do `buscar_pastas` seria:**
1. Filtrar apenas workflows `active && !isArchived`
2. Para cada workflow: extrair o prefixo do nome (até o primeiro `_` que precede um nome funcional)
3. `githubPath = prefixo + "/" + nome_completo + ".json"`

## Branch strategy

- Backup na **`main`** com pastas (fonte canônica)
- Branches individuais podem ser deletadas (são redundantes e estão sujas)

## Verificação

- [ ] Todos os workflows ativos vão para a pasta correta
- [ ] Nenhum workflow fantasma (inativo/arquivado) é commitado
- [ ] Nenhum erro 422 (sha não fornecido)
- [ ] Nenhuma duplicata ou arquivo em pasta errada
