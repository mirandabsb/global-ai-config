# Walkthrough: Refinamento do Workflow de Backup GitHub

Implementamos uma reestruturação completa na lógica de roteamento e na legibilidade do workflow de backup.

## 1. Melhorias na Lógica de Roteamento
Para resolver o problema de workflows `IARA_Saude_*` serem movidos para a pasta `IARA/` (conflito de prefixo), implementamos a estratégia de **Longest Match**:
- O workflow busca todas as tags disponíveis.
- Ordena da maior para a menor (`IARA_Saude` > `IARA`).
- Compara o nome do workflow com essas tags. se o nome começa com a tag, essa é a pasta de destino.
- Filtro de **Apenas Ativos**: Reduzimos o volume de 173 para ~76 workflows, focando apenas no que é produtivo.

## 2. Experiência e Organização (Node Renaming)
Atendendo ao padrão da ImmA, todos os **34 nós** do workflow foram renomeados para nomes descritivos em **PT-BR e minúsculo**.
- **Exemplo**: `Schedule Trigger` -> `trigger: backup_hora`
- **Exemplo**: `buscar_pastas` -> `logic: mapeia_pastas`
- **Exemplo**: `GitHubWorkflow` -> `github: busca_sha_arquivo`

> [!IMPORTANT]
> Todas as conexões e expressões internas que referenciavam nomes antigos (ex: `$('Get many workflows')`) foram atualizadas automaticamente para garantir o funcionamento imediato.

## 3. Verificação de Sucesso
Após a execução final (Execução 5220302+):
1. Workflows `IARA_Saude_*` devem aparecer em `Clinica_Medica/` (se a tag for esta) ou `IARA_Saude/` (conforme a nova tag do n8n).
2. O nome do arquivo no GitHub agora é o **nome exato** que você vê no n8n.
3. Não há mais sanitização agressiva que causava perda de SHA no GET.

**Status Final**: Operacional. Sugerimos uma execução manual para validação final visual no GitHub.
