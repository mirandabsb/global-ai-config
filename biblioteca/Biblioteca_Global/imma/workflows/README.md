# Workflows do Projeto IARA e outras aplicações(Backup Automatizado)

Este repositório serve como um backup centralizado e automatizado para todos os workflows da plataforma de automação (n8n) utilizados no Projeto IARA e outras aplicações.
O objetivo é garantir o controle de versões, a segurança e a capacidade de recuperação de toda a lógica de automação do projeto.

**Atenção:** Os arquivos neste repositório são gerenciados automaticamente. Alterações manuais feitas diretamente aqui serão substituídas pelo processo de automação.

## 🤖 Processo de Backup

O conteúdo deste repositório é gerenciado por um workflow do n8n chamado "Backup Workflows Github". Este processo garante que o repositório esteja sempre sincronizado com a instância de produção do n8n.

O processo de backup funciona da seguinte forma:

* **Trigger Agendado:** O workflow é executado automaticamente num horário pré-definido (a cada hora, aos 15 minutos).
* **Limpeza:** Remove a pasta de backup local anterior para garantir uma exportação limpa.
* **Exportação:** Executa o comando `n8n export:workflow --backup` para exportar todos os workflows ativos da instância em arquivos .json.
* **Leitura:** O sistema lê todos os arquivos .json exportados.
* **Iteração:** O workflow entra em loop, processando um workflow de cada vez, com uma pequena pausa entre eles para evitar limites da API.
* **Verificação no GitHub:** Para cada workflow, verifica se o arquivo já existe neste repositório.
* **Commit Conditional:**
    * **Se o arquivo não existir:** O workflow cria o novo arquivo .json no repositório.
    * **Se o arquivo já existir:** O workflow compara a data de `updatedAt` (última atualização) do arquivo local com a do arquivo no repositório. Um novo commit (edit) só é realizado se houver alterações, garantindo que houveram modificações reais.

## 📦 Repositórios Individuais

Os workflows foram migrados para repositórios individuais para melhor gestão no n8n. Cada pasta abaixo é um repositório Git independente:

| Pasta | Link GitHub |
| :--- | :--- |
| **Backup_BD** | [Backup_BD](https://github.com/iara-devops/Backup_BD) |
| **Backup_GitHub** | [Backup_GitHub](https://github.com/iara-devops/Backup_GitHub) |
| **Chatwoot** | [Chatwoot](https://github.com/iara-devops/Chatwoot) |
| **Clinica_Medica** | [Clinica_Medica](https://github.com/iara-devops/Clinica_Medica) |
| **Finanças** | [Finanças](https://github.com/iara-devops/Finanças) |
| **Fluxos_Compartilhados** | [Fluxos_Compartilhados](https://github.com/iara-devops/Fluxos_Compartilhados) |
| **IARA** | [IARA](https://github.com/iara-devops/IARA) |
| **IARA Imobiliaria** | [IARA_Imobiliaria](https://github.com/iara-devops/IARA_Imobiliaria) |
| **IARA_v2** | [IARA_v2](https://github.com/iara-devops/IARA_v2) |
| **Jira** | [Jira](https://github.com/iara-devops/Jira) |
| **Tecnoweb** | [Tecnoweb](https://github.com/iara-devops/Tecnoweb) |
| **Templates** | [Templates](https://github.com/iara-devops/Templates) |
| **YouTube** | [YouTube](https://github.com/iara-devops/YouTube) |
| **n8n_agente** | [n8n_agente](https://github.com/iara-devops/n8n_agente) |

## 📁 Estrutura dos Arquivos

Cada arquivo .json neste repositório representa um único workflow do n8n. A convenção de nomenclatura utilizada é:

`[Pasta]/[NomeDoWorkflow]_[IDdoWorkflow].json`

Exemplo: `Backup_GitHub/Backup Workflows Github_L5ute5uhxQ5IA0GQ.json`

## 🚀 Restauração de um Workflow

Para restaurar um workflow a partir deste backup:

1.  Navegue até o arquivo .json desejado no repositório.
2.  Faça o download do arquivo.
3.  Na sua instância n8n, vá para Workflows e clique em **Import** > **Import from File**.
4.  Selecione o arquivo .json que você baixou.
