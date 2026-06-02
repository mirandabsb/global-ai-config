# Postmortem: Incidentes de Integração e Roteamento no n8n

| Documento | Detalhes |
|-----------|---|
| **Sistemas Afetados** | Repositório `workflows-imma/Tecnoweb` |
| **Autoria** | Equipe de Engenharia / Agentes Assistentes |

Este relatório sumariza e analisa as causas raízes e detalha a solução arquitetural para problemas encontrados em nossa operação com n8n.

---

## 25 de Fevereiro de 2026

### Incidente D: Timeouts Críticos por Escaping Duplo em JSON e Divergência de Instância Redis
* **Workflows afetados:** `Tecnoweb_atendimento_v1.2` (nó `formata_cache`) e `Tecnoweb_valida_cliente_v1.2` (nó `marca_validado_redis`)
* **Erro observado:** Timeout de execução no JsTaskRunnerSandbox (`Unknown error` em ~62s) no nó `formata_cache` e dessincronização de estado de cliente, o workflow principal falhava em ler a validação gravada.
* **Causa Raiz:**
  - **Engine Corrompida (Double Escaping):** O código JavaScript embutido no workflow para o tratamento de strings JSON do cache possuía um escaping duplo literal (`\\\\n`). Ao carregar via sandbox do n8n, o parser agrupava tudo numa única linha maciça não conseguindo decodar adequadamente os sub-agrupamentos causando exaurimento temporal de runloop (bloqueio síncrono seguido por death por tempo limite).
  - **Identidade de Conexões Fragmentada:** O nodo de gravação atrelava-se isoladamente na stack `Redis IARA` (ID: 2xAK3x2MQLbPqGJM) mas a checagem que libera a passagem aguardava no namespace `Redis Chat IARA` (ID: rdXMiQENAIsoOF8m).
* **Resolução:**
  - Remoção dos caracteres backslash excedentes garantindo escaping nativo simples;
  - Substituição das credenciais isoladas, fazendo um override das dependências apontando todas elas ao ID unificado de conexão principal.

---

## 24 de Fevereiro de 2026

### Incidente A: The Debounce `null/undefined` Crash
* **Workflows afetados:** `Tecnoweb_IARA_tratamento_mensagens_v1.2`
* **Erro observado:** `TypeError: Cannot read properties of undefined (reading 'sender')` ocorrido no nó em JavaScript de `debounce_mensagens`.
* **Causa Raiz:** A query de banco `buscar_mensagem` eventualmente não retornava resultados se não houvesse mensagens pendentes válidas sob a janela temporal. O nó enviava o dado assim mesmo (vazio/undefined) para os code-blocks `debounce_mensagens`. Este tentava varrer os campos de remetente (sender) sem a devida sanidade ou early return.
* **Resolução:** 
  - Inserido verificação estrita de vazios `verifica_mensagem` logo após a extração, filtrando resultados em brancos antes do debouncing.
  - Abordagem unificada via JavaScript para forçar `.filter(text => text && text.trim() !== "")`.

### Incidente B: Falhas na Persistência de Cache Redis
* **Workflows afetados:** Família `Tecnoweb_atendimento_v1.0 / v1.2 / IARA_imob_atendimento_v1.3`
* **Erro observado:** LLM continuava a processar as mesmas perguntas repetidamente custando tokens. A tentativa de cache esbarrava em erros ou populava chaves erradamente.
* **Causa Raiz:** O bloco de persistência no Redis (Read/Write) possuía sua lógica de condição booleana mal orientada. Ele estava pulando a alocação de valores recém criados porque a verificação base do "Achei no cache?" enviava caminhos trocados. Além disso haviam steps soltos após popular os dados, ou omitindo a atualização do banco do cache.
* **Resolução:**
  - Inversão da lógica condicional e conexão firme nos pipelines de Cache Layer.
  - Teste de conceito no workflow `HVFdTEFx2WUpc8fy` de dev antes do rollout geral com sucesso em reduzir carga de banco e de APIs.

### Incidente C: Sub-workflows Desacoplados & Isolamento (`valida_cliente`)
* **Workflows afetados:** `Tecnoweb_valida_cliente_v1.1` e `v1.2`
* **Erro observado:** `Cannot assign to read only property 'name' of object 'Error: Referenced node doesn't exist'`
* **Causa Raiz:**
  - *Contexto Desacoplado:* Ocorria principalmente porque um sub-workflow tenta chamar as variáveis ou atributos de nodos com base no _nome_ que esse nodo possuía apenas no workflow-pai da invocação (p.ex., chamar `$('debounce_mensagens').first().json` de dentro de _outro_ escopo de n8n não funciona caso não passado via input properties).
  - *Lógica de loop errônea:* Variáveis primitivas como um single ID numérico chegam escalarmente, mas métodos iteradores (`.map()`) tentam manipular nela presumindo lista, ocasionando Crashs.
* **Resolução:**
  - Transferência de estado do Payload `ids_processados` diretamente pelo Trigger do nó (`chamado_iara`) garantindo uma conversão explícita: testar se é array de ID de múltiplos debounces ou cast caso venha sozinho (`[ids_processados]`).
  - Remoção proativa de blocos loops não aplicáveis quando o chamador repassava as transações em regime solitário e atualização das diretrizes de Postgres Update substituindo variáveis inexistentes pelas do webhook trigger.
  - Implementado sistema "3-strikes" nas validações de CNPJ para evitar "infinitely trapped users", acionando automaticamente um transbordo (Assistência Humana) pós flag vermelha.

---

## 3. Lições Aprendidas (Takeaways)

1. **Proteção e Tipagem nos Boundaries de Workflow:** Sempre presumir que dados passados via `executeWorkflow` (`Sub-workflows`) demandam desestruturação local e não confiar em espelhos dos nomes do "Pai". Use variáveis estritas em inputs.
2. **Resiliência a Nulos:** Todo payload obtido do PostgreSQL deve atuar sob presunção de falha. Se 0 items vêm no lote, os nodos de manipulações deverão usar early exits `if(items.length === 0) return []`.
3. **Mapeamento Explícito de Loops:** Diferenciar cenários de lotes oriundo de debounces vs. processamentos de nó solitários, preferindo SQL statements de IN Array para simplificação se possível.

## 4. Ações Futuras
- [ ] Implementar a convenção descrita no Changelog para todas as criações futuras de sub-workflows.
- [ ] Mapear as restrições adicionais de segurança nas variáveis globais (eg. `bot_slug`) antes das queries serem despachadas no BD central de filas.
