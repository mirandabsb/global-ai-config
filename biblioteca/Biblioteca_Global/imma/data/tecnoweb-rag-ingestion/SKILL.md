---
name: tecnoweb-rag-ingestion
description: "Skill automatizada para ingerir novos textos, gerar documentação Markdown no padrão Q&A, encontrar o último incremento numérico na Base de Dados e salvar o arquivo atualizado."
---

# Tecnoweb RAG Ingestion

Esta skill automatiza a ingestão de novos textos, PDFs ou transcrições de vídeos para a base de conhecimento estruturada do sistema Tecnoweb/LINCE.

## Quando usar

Ative essa skill sempre que o usuário disser que tem um novo texto/manual/transcrição para ser adicionado à base de dados da Tecnoweb, ou quando solicitar a conversão de um conteúdo para o padrão de documentação do RAG.

## Procedimento de Execução

Siga ESTES passos, nesta exata ordem:

### 1. Ler o Diretório Base
- Utilize a ferramenta `list_dir` no caminho absoluto da base de dados:
  `/home/marcos/Projetos/imma-org/packages/n8n-workflows/TECNOWEB/Base de Dados`

### 2. Determinar o Próximo Número (Incremento)
- Analise os arquivos retornados. Eles seguem o padrão `[NUMERO]_[SLUG_DO_ARQUIVO].md` (exemplo: `142_lince_carga_balanca.md`).
- Encontre o maior número inteiro utilizado nos prefixos.
- Some `+1` a esse número. Este será o prefixo do seu novo arquivo.

### 3. Receber e Estruturar o Conteúdo
- Se o usuário ainda não tiver enviado o texto bruto (ou arquivo PDF/TXT/áudio), peça-o cordialmente.
- Após receber o conteúdo, processe-o transformando-o **OBRIGATORIAMENTE em um formato de Perguntas e Respostas (Q&A)**. Todo o conteúdo, instruções e procedimentos devem ser convertidos em perguntas lógicas que um usuário faria, seguidas da resposta técnica e direta.
- **REGRAS ESTRITAS DE PRECISÃO (ANTI-ALUCINAÇÃO E FIDELIDADE):**
  - **NÃO EXCLUA** nenhuma informação operacional, técnica ou de regra de negócios presente no conteúdo original.
  - **NÃO INVENTE** ou presuma recursos, passos ou regras que não estejam explicitamente detalhados no texto fonte.
  - A documentação deve ser altamente técnica, precisa e estritamente fiel ao que foi transcrito/escrito.
- **O padrão OBRIGATÓRIO da documentação RAG exige:**
  - Título Principal (H1) claro.
  - Metadados logo abaixo do título, usando blockquote: `> **Sistema:** [Nome] | **Módulo:** [Nome] | **Fonte:** [Origem]`
  - Uma seção obrigatória: `## Glossário` contendo uma tabela Markdown com os termos técnicos do documento.
  - Uma seção obrigatória: `## Perguntas e Respostas (Q&A)`. DENTRO DESTA SEÇÃO, crie subtítulos H3 (`### [Pergunta]`) contendo as perguntas lógicas baseadas no texto, seguidas de suas respectivas respostas, passos a passo e listas.
  - **ATENÇÃO:** Não utilize seções discursivas normais. Todo o conteúdo processual e informativo deve ser distribuído dentro das respostas do Q&A.
  - Filtragem de linguagem coloquial (ex: vícios de linguagem em vídeos) com o objetivo de limpar o texto, mas preservando 100% da informação na forma de respostas.

### 4. Salvar o Arquivo
- Gere um slug descritivo para o conteúdo. Exemplo: para um vídeo sobre "Cadastro de Produtos", o slug seria `lince_cadastro_produtos`.
- Monte o nome final do arquivo: `[NUMERO_INCREMENTADO]_[slug_gerado].md`.
- Utilize a ferramenta `write_to_file` para gravar o Markdown estruturado na pasta base da Tecnoweb:
  `/home/marcos/Projetos/imma-org/packages/n8n-workflows/TECNOWEB/Base de Dados/[NOME_DO_ARQUIVO].md`

### 5. Confirmar Conclusão
- Responda ao usuário com uma confirmação que inclua:
  - O nome do arquivo criado.
  - O caminho onde foi salvo.
  - Um breve resumo de 1 ou 2 linhas sobre os tópicos abordados no documento.
