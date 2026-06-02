# Changelog

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.8] - 2026-02-25

### Fixed
- **Lógica de Debounce (`Tecnoweb_IARA_tratamento_mensagens_v1.3`)**:
  - Estabilização do acúmulo temporário com tempo fixo (12s). Eliminação de redundâncias de polling por controle nativo do agendador via nova detecção PostgreSQL.
- **Engine de Formatação de Cache (`Tecnoweb_atendimento_v1.2`)**:
  - Prevenção de falhas de limite de timeout da Sandbox pela supressão de problemas com dupla demarcação de quebras de linha (escaping) durante injeções baseadas em Javascript para manipulação JSON. 
- **Persistência de Estado (Redis)**:
  - Restabelecimento do alinhamento de leitura de flag de validação (`cliente_validado`) ao identificar e padronizar o direcionamento das credenciais apontadas estritamente para `Redis Chat IARA`.

### Changed
- **Atualização Mandatória de TypeVersion (`IARA_atendimento_v2.6` e Tratamento)**:
  - Otimizações na integridade e compatibilidade de dependências injetadas de nós-fonte via orquestração. Modelos de conectores de IA e HTTPRequests refatorados para garantir operação fluída sob os standards correntes das versões 4.3/4.4.

---

## [2.7] - 2026-02-24
 
 ### Fixed
 - **Correções do Workflow `Tecnoweb_IARA_tratamento_mensagens`**:
   - Correção do Type Error `Cannot read properties of undefined (reading 'sender')` no nó `debounce_mensagens` adicionando filtros preventivos em `verifica_mensagem` contra resultados vazios oriundos de `buscar_mensagem`.
 - **Implementação do Workflow Cache Layer (`Tecnoweb_atendimento`, etc)**:
   - Resolução de lógica condicional invertida e passos ausentes na população de cache.
   - Replicação bem-sucedida do mecanismo de cache via Redis dos workflows base para produção.
 - **Melhorias e Correções da Validação de Clientes (`Tecnoweb_valida_cliente_v1.1` e `v1.2`)**:
   - Reformulação da lógica de verificação de mensagens, tratamento adequado de respostas negativas ("Não") ou CNPJ inválidos.
   - Ajuste no estado gerenciado via Redis para suportar fallback apropriado (3-strike system).
   - Correção do Erro Crítico "Referenced node doesn't exist" (falha no nó `fila_id`): Adaptação na ingestão do array `ids_processados` a partir de uma propriedade direta do payload (`chamado_iara`) garantindo suporte à conversão explícita de itens.
   - Remoção do node loop indevido no tratamento do debounce. Acionada tratativa correta para inserção de lote vs valor escalar no final da cadeia.
 
 ---
 
 ## [2.6] - 2026-02-20
 
 ### Planned
 - Nova arquitetura de validação de cliente CNPJ (Workflow `fGo3J7MWtrdfjmZe`):
   - Implementação de lógica de persistência via Redis para evitar loops infinitos.
   - Sistema de "3-strike" (três tentativas) para entrada de CNPJ inválido.
   - Escalonamento automático para atendimento humano após a terceira falha.
   - Integração com o fluxo principal de mensagens (`F45q62Msp3aAwQkM`) para verificação de status `VALIDADO` no Redis.
 
 ---

## [2.5] - 2026-02-18

### Added
- Suporte multi-formato no pipeline de ingestão RAG:
  - Integração de processamento para arquivos **TXT** e **CSV** (transcrições) além de PDF.
  - Novo nó `roteador_formatos` (Switch) para direcionamento de fluxo baseado no tipo de arquivo.
  - Extratores Gemini especializados para cada formato, garantindo metadados consistentes.
- Melhorias na interface e manutenção n8n:
  - Padronização de todos os nomes de nós para `snake_case` (ex: `armazena_pgvector`, `baixa_arquivo`).
  - Adição de documentação visual na tela (Sticky Notes) delimitando as fases de Início, Processamento e Carga.
  - Inclusão de tabela de Changelog interna no canvas do n8n.

### Changed
- Migração do workflow oficial para o ID `SkjQC05HFM8kKfwP` (Tecnoweb_IARA_ingestao_RAG v2.5), substituindo a versão arquivada.
- Otimização do processamento de CSV: Remoção de loop interno redundante, utilizando a iteração nativa do n8n.

## [2.2] - 2026-02-17

### Fixed
- Remoção da injeção de header de metadados no `pageContent` do nó `Normalizar Saída (JSON)`.
  - O header estava causando redundância e "sujando" o conteúdo textual usado nos embeddings.
  - `pageContent` agora contém apenas o texto limpo do documento.
  - Os metadados permanecem exclusivamente na coluna JSONB `metadata` (12 campos).

## [2.1] - 2026-02-17

### Added
- Enriquecimento do pipeline RAG com **12 campos de metadados semânticos** (expandido de 4):
  - `source_id`, `source_type`, `source_name`, `content_hash` (controle)
  - `titulo`, `resumo`, `tags`, `tipo_documento` (semânticos)
  - `topicos_chave`, `publico_alvo`, `glossario` (classificação)
  - `data_processamento` (auditoria)
- Lógica de extração estruturada via Gemini Flash para preenchimento automático dos campos.

### Changed
- Atualização do nó `Buscar Hashes Existentes` para usar `SELECT DISTINCT`, suportando múltiplos chunks por documento no controle de versão.

## [2.0] - 2026-02-17

### Added
- Implementação de sincronização incremental baseada em hash (`content_hash`) para arquivos do Google Drive.
- Novos nós de processamento no workflow `Tecnoweb_IARA_ingestao_RAG v2.0`:
  - `Buscar Hashes Existentes` — consulta hashes existentes para comparação.
  - `Filtrar e Deduplicar` — Code node com lógica hash-based.
  - `Tem Itens?` — Filter node para controle de fluxo.
  - `Normalizar Saída (JSON)` — Code node para saída estruturada.
  - `Deletar Registro Antigo` — deleção seletiva para updates.
  - `Atualizar Metadados` — SQL para rastreamento de fontes.
- Colunas de controle no banco de dados (`rag_documents`): `source_id`, `content_hash`, `source_type`, `source_name`, `updated_at`.

### Changed
- Reestruturação completa do workflow de ingestão RAG (15 nós).
- Mudança da política de limpeza: de "Full Wipe" (`DELETE FROM rag_documents`) para "Incremental Selective Delete".
- Refatoração do nó de Normalização para suporte a metadados fatiados (flattened).

### Fixed
- Correção de erro de chave duplicada (`UNIQUE` constraint `rag_documents_source_id_key`) em `source_id` que impedia o chunking multi-registro por arquivo.
- Correção na população de metadados no `Default Data Loader` que estava sobrescrevendo campos incorretamente.

## [1.2] - 2026-02-13

### Changed
- Refatoração do workflow **YouTube Video Transcriber** (`gUTEO_8jwBxvUAAxSQ0_N`) para processamento em lote via Google Sheets.
  - Substituição do Chat Trigger por Manual Trigger + Google Sheets Read.
  - Implementação de `SplitInBatches` (batch size = 1) para respeitar limites de API.
  - Adição de nó Google Sheets Write para gravação de resultados (Transcrição, Resumo, Glossário, Status).
  - Reconfiguração do `Get transcript` para usar URL proveniente da planilha.

### Added
- Prompt `prompt_YouTube_v1.0` — prompt especializado para transcrição técnica de vídeos LINCE.
- Prompt `prompt_PDF_v1.0` — prompt de Engenheiro de Dados para conversão de documentos PDF em dados estruturados para RAG.

## [1.1] - 2026-02-12

### Changed
- Migração de marca: Renomeação de todos os workflows e tags de "IARA" para "Tecnoweb" para alinhamento organizacional.

## [1.0] - 2026-02-12

### Added
- Versão inicial do workflow de ingestão RAG para o projeto Tecnoweb.
- Integração básica Google Drive → Gemini → PGVector.
- Documentação do contexto do projeto em `tecnoweb.md` (IDs de banco, workflows, tabelas).
