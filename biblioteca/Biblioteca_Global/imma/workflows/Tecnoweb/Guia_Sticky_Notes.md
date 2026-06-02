# Guia de Organização: Sticky Notes

Abaixo estão as sugestões de marcações visuais para agrupar e documentar os seus workflows. 
**Como usar no n8n**: Selecione os nós citados com o mouse e pressione `Shift + S` para agrupá-los em uma nova Sticky Note. Depois, ajuste a cor e copie/cole título e o texto explicativo.

---

## Workflow 1: `Tecnoweb_historico_conversas_v1.0`

### 1️⃣ Recepção e Embedding (Cor sugerida: Roxo / Purple)
*   **Nós para selecionar**: `chamada_IARA` e `Gerar_Embedding_HTTP`
*   **Texto para a Nota**:
```markdown
# RECEPÇÃO E EMBEDDING
Recebe o Webhook da chamada de IARA e gera os Embeddings da mensagem para a Busca Semântica no banco vetorial.
```

### 2️⃣ Tratamento e Histórico (Cor sugerida: Verde / Green)
*   **Nós para selecionar**: `formata_telefone`, `atualiza_historico` e `No Operation, do nothing`
*   **Texto para a Nota**:
```markdown
# TRATAMENTO E HISTÓRICO
Formatação de IDs de telefone e gravação das mensagens convertidas em Embeddings no banco de dados para abastecer o contexto futuro do RAG.
```

---

## Workflow 2: `Tecnoweb_IARA_tratamento_mensagens_v1.2` (Estrutura Completa)

Abaixo descrevo as marcações exatas com base na imagem panorâmica para acompanhar o fluxo completo das mensagens:

### 1️⃣ INGESTÃO & DEBOUNCE (Cor sugerida: Verde Escuro / Dark Green)
*   **Nós para selecionar**: `When Executed By Another Workflow`, `Schedule Trigger`, `set_variaveis`, `limpar_tabelas`, `buscar_mensagem`, `verifica_mensagem`, `debounce_mensagens`, `espera_debounce`, `limite_tentativas`.
*   **Texto para a Nota**:
```markdown
# 1️⃣ INGESTÃO & DEBOUNCE
Extrai mensagens novas num job agendado, realiza a verificação anti-Nulos e efetua o Merge/Debounce em lote por Sender.
```

### 2️⃣ VALIDAÇÃO DE CONTEXTO (CLIENTES / CNPJ) (Cor sugerida: Amarelo Queimado / Gold)
*   **Nós para selecionar**: `busca_status_cnpj`, `Switch1`, `chama_verifica_cliente`, `No Operation, do nothing`.
*   **Texto para a Nota**:
```markdown
# 2️⃣ VALIDAÇÃO DE CONTEXTO (CLIENTES / CNPJ)
Interroga o cache Redis para verificar se o cliente possui permissões vigentes (CNPJ validado) ou o repassa para triagem do sub-workflow valida_cliente.
```

### 3️⃣ Verifica tipo de mensagem (Cor sugerida: Cinza Escuro / Dark Grey)
*   **Nós para selecionar**: `verifica_tipo`, `pegar_anexos`, `verifica_anexo`.
*   **Texto para a Nota**:
```markdown
# Verifica tipo de mensagem
```

### 4️⃣ Processadores de Mídia (Cores sugeridas: Azul Escuro / Dark Blue)
Crie caixas adjacentes para cada tipo de parser da IA:
*   **Bloco Áudio**: `download_audio` e `transcricao_audio` -> Crie uma nota intitulada: **Processando áudio**
*   **Bloco Imagem**: `download_imagem` e `analisar_imagem` -> Crie uma nota intitulada: **Processando Imagem**
*   **Bloco PDF**: `download_PDF` e `analisar_documento` -> Crie uma nota intitulada: **Processando PDF**
*   **Bloco Vídeo**: `download_video` e `analisar_video` -> Crie uma nota intitulada: **Processando Vídeo**

### 5️⃣ Junta mensagens (Cor sugerida: Azul Petróleo / Navy)
*   **Nós para selecionar**: `juntar_analises` e `unificar_dados`.
*   **Texto para a Nota**:
```markdown
# Junta mensagens
```

### 6️⃣ Chama Iara (Cor sugerida: Dourado / Light Gold)
*   **Nós para selecionar**: `Call "Tecnoweb_atendi..."` (executeWorkflow).
*   **Texto para a Nota**:
```markdown
# Chama Iara
```

### 7️⃣ Configura status da mensagem como processada (Cor sugerida: Verde Limão / Green)
*   **Nós para selecionar**: `fila_id`, `Loop Over Items`, `No Operation, do nothing1` e `mensagem_processada`.
*   **Texto para a Nota**:
```markdown
# Configura status da mensagem como processada
```

### 8️⃣ Erro Iara - configura BD para tentar de novo (Cor sugerida: Vermelho Escuro / Dark Red)
*   **Nós para selecionar**: `erro_IARA`, `testa_failed`, `Switch`, `Call "IARA/assistencia_humana..."` e `enviar_mensagem_erro`.
*   **Texto para a Nota**:
```markdown
# Erro Iara - configura BD para tentar de novo
```

---

## Workflow 3: `Tecnoweb_IARA_assistencia_humana_v1.0`

### 1️⃣ Recepção e Trigger (Cor sugerida: Cinza Escuro / Dark Grey)
*   **Nós para selecionar**: `Start_assitencia_humana`
*   **Texto para a Nota**:
```markdown
# Recepção e Trigger
Inicia a notificação para a equipe humana.
```

### 2️⃣ Notificação Interna (Cor sugerida: Leste / Teal)
*   **Nós para selecionar**: `If`, `envia_msg_telegram`, `enviar_chatwoot`
*   **Texto para a Nota**:
```markdown
# Notificação Interna
Roteia e envia o aviso para os canais de atendimento humano configurados (Telegram/Chatwoot).
```

---

## Workflow 4: `Tecnoweb_IARA_cria_vetor_v1.0`

### 1️⃣ Inicialização (Cor sugerida: Cinza Escuro / Dark Grey)
*   **Nós para selecionar**: `Criar_vetor`, `If`
*   **Texto para a Nota**:
```markdown
# Inicialização
Inicia o processo de vetorização e verifica os inputs.
```

### 2️⃣ Cérebro (Cor sugerida: Amarelo Queimado / Gold)
*   **Nós para selecionar**: `OpenAI Chat Model`, `Embeddings OpenAI`, `Supabase Vector Store`
*   **Texto para a Nota**:
```markdown
# Cérebro
Modelos LLM e funções de Embedding conectados ao Vector Store.
```

### 3️⃣ Processamento de Documentação (Cor sugerida: Azul / Blue)
*   **Nós para selecionar**: `Documentos IARA` (Default Data Loader)
*   **Texto para a Nota**:
```markdown
# Processamento de Documentação
Carrega e estrutura os documentos de contexto da IARA.
```

---

## Workflow 5: `Tecnoweb_IARA_fila_atendimento_v1.0`

### 1️⃣ Monitoramento de Fila (Cor sugerida: Roxo / Purple)
*   **Nós para selecionar**: `Schedule Trigger`, `fila_atendimento`
*   **Texto para a Nota**:
```markdown
# Monitoramento de Fila
Busca as próximas mensagens da fila a serem processadas pelo sistema.
```

### 2️⃣ Roteamento e Processamento (Cor sugerida: Verde / Green)
*   **Nós para selecionar**: `If1`, `filtra_bot`, `historico_conversa`, `chama_tratamento_mensagens`
*   **Texto para a Nota**:
```markdown
# Roteamento e Processamento
Verifica se devem ser ignoradas respostas do próprio bot, formata o histórico e repassa ao tratador central.
```

---

## Workflow 6: `Tecnoweb_IARA_ingestao_Planilha_v1.0`

### 1️⃣ Sincronização de Planilha (Cor sugerida: Azul / Blue)
*   **Nós para selecionar**: `Manual Trigger`, `Google Sheets`, `Postgres Select Existing`, `Code`, `Postgres Insert`
*   **Texto para a Nota**:
```markdown
# Sincronização de Planilha
Extrai os dados da planilha Google Sheets, verifica as entradas já existentes e insere os novos registros no banco.
```

---

## Workflow 7: `Tecnoweb_IARA_ingestao_RAG_v2.5`

### 1️⃣ Gatilhos e Triagem (Cor sugerida: Azul / Blue)
*   **Nós para selecionar**: `Google Drive Trigger`, `manual_trigger`, `configuracao_geral`, `busca_hashes_existentes`, `busca_arquivos_drive`, `filtra_e_deduplica`, `baixa_arquivos`
*   **Texto para a Nota**:
```markdown
# Gatilhos e Triagem
Inicia via webhook ou manualmente, encontra os arquivos novos não processados e baixa-os para o RAG.
```

### 2️⃣ Processadores Multi-Formato (Cor sugerida: Amarelo Queimado / Gold)
*   **Nós para selecionar**: `loop_arquivos`, `roteador_formatos`, `extrai_texto_txt`, `analisa_txt_gemini`, `extrai_dados_csv`, `analisa_linha_csv_gemini`, `analisa_pdf_gemini`, `loop_linhas_csv`, `separa_itens_csv`, `modelo_gemini`
*   **Texto para a Nota**:
```markdown
# Processadores Multi-Formato
Identifica o tipo de arquivo e envia para formatação usando a inteligência do Gemini (TXT, CSV, PDF).
```

### 3️⃣ Ingestão Vetorial (Cor sugerida: Verde / Green)
*   **Nós para selecionar**: `normalizar_JSON_doc`, `normalizar_JSON_csv`, `deleta_registro_antigo`, `aguarda_delecao`, `prepara_conteudo_vector`, `data_loader_padrao`, `armazena_pgvector`, `embeddings_openai`
*   **Texto para a Nota**:
```markdown
# Ingestão Vetorial
Limpa documentos antigos e salva as novas embeddings no Postgres para a Busca Semântica.
```

### 4️⃣ Geração Contínua (Cor sugerida: Cinza / Grey)
*   **Nós para selecionar**: `controle_loop_retorno`, `unifica_fluxos`, `aguarda_cotas_csv`, `se_nao_existe_csv`, `verifica_duplicidade_csv`
*   **Texto para a Nota**:
```markdown
# Geração Contínua
Controla os loops de itens processados, garante rate limiters e finaliza o pipeline de ingestão.
```

---

## Workflow 8: `Tecnoweb_importar_clientes_v1.0`

### 1️⃣ Importador CSV (Cor sugerida: Laranja / Orange)
*   **Nós para selecionar**: `When clicking ‘Execute workflow’`, `Download file`, `Extract from File`, `Code in JavaScript`, `loop_linhas_planilha`, `insere_dados_cliente`
*   **Texto para a Nota**:
```markdown
# Importador CSV
Puxa o arquivo, faz o parse localmente via código e popula as contas dos novos clientes no banco Postgres via Loop.
```
