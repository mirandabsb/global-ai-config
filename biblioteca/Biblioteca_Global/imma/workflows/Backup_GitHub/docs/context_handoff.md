# Context Handoff: n8n Backup System (workflows-imma)

## Resumo Técnico
O workflow de backup foi estabilizado após problemas de roteamento causados por prefixos similares (`IARA` vs `IARA_Saude`).

### Convenção de Nomes
- **Nós**: Devem seguir o padrão `categoria: acao_especifica` em minúsculo (ex: `n8n: busca_tags`).
- **Arquivos**: Nome exato do n8n + `.json`. Sem sanitização.
- **Pastas**: Baseadas no match exato com as Tags do n8n.

### Lógica de Mapeamento (`logic: mapeia_pastas`)
O código JS realiza um `sort` nas tags por tamanho decrescente. Isso garante que se um workflow se chama `IARA_Saude_Teste`, o sistema tente dar match primeiro com a tag `IARA_Saude` antes de tentar `IARA`.

### Próximos Passos
- Já validado com a tag `IARA_Saude`.
- Limpeza bidirecional (cleanup do GitHub quando workflow for deletado no n8n) está planejada para a próxima iteração.
- A branch `main` continua sendo a "Single Source of Truth" para o agrupamento por pastas.
