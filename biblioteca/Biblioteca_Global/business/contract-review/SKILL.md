---
name: contract-review
description: Revisão de contratos legais com IA. Identifica termos desfavoráveis, sugere redlines e compara com padrões de mercado. Use para análise de contratos, due diligence ou preparação para negociação. Suporta NDAs, SaaS, M&A, contratos de emprego, acordos de pagamento e outros documentos jurídicos.
version: 3.0.0
source: https://github.com/evolsb/claude-legal-skill
license: MIT
category: business
tags: [legal, contratos, nda, saas, ma, due-diligence, negociação, redline]
---

# Contract Review Skill

🤖 Assumindo @legal-advisor...

Revisão de contratos legais para identificação de riscos, extração de termos-chave e sugestão de redlines. Construído com base no dataset CUAD (41 categorias de risco), benchmarks do ContractEval e LegalBench.

## Quando Ativar

- Usuário menciona "revisar contrato", "analisar acordo", "checar este contrato"
- Usuário envia ou referencia um PDF/DOCX de documento legal
- Usuário pergunta sobre cláusulas específicas, riscos ou termos

---

## Step 1: Pre-Review Checklist

Antes de analisar o conteúdo, verificar completude do documento:

- [ ] **Campos em branco**: Sinalizar qualquer "$X", "TBD", "[valor]", "____" placeholder
- [ ] **Anexos ausentes**: Listar todos os schedules/exhibits referenciados e indicar quais estão faltando
- [ ] **Status de assinatura**: Rascunho ou já executado?
- [ ] **Todas as páginas presentes**: Verificar truncamento ou seções ausentes

Se campos em branco ou anexos ausentes existirem, sinalizar prominentemente no cabeçalho da saída.

---

## Step 2: Identificar Tipo de Documento & Posição do Usuário

**Perguntar se não estiver claro:** "Qual parte você é? (cliente, fornecedor, comprador, vendedor, licenciante, licenciado, parte receptora, parte divulgadora)"

Isso afeta o que é "arriscado":
- Cliente revisando acordo de fornecedor → sinalizar termos favoráveis ao fornecedor
- Fornecedor revisando próprio template → sinalizar termos favoráveis ao cliente
- Comprador em M&A → sinalizar termos favoráveis ao vendedor
- Vendedor em M&A → sinalizar termos favoráveis ao comprador
- Parte receptora em NDA → sinalizar termos favoráveis à parte divulgadora

**Avaliar dinâmica de poder:**
- Startup vs. grande empresa? (alavancagem limitada de negociação)
- Formulário padrão vs. negociado? (alguns termos não negociáveis)
- Setor regulado? (alguns termos legalmente exigidos)

---

## Output Format

Use **markdown** para saída legível e escaneável. NÃO use tags XML.

---

### Exemplo de Output

```markdown
# Revisão de Contrato: [Nome do Documento]

**Tipo de Documento:** Contrato de Assinatura SaaS
**Sua Posição:** Cliente
**Contraparte:** Acme Software Inc.
**Nível de Risco:** 🟡 Médio
**Status do Documento:** Rascunho / Executado em [data]

## ⚠️ Alertas Pré-Assinatura

- **Campo em branco:** Valor da taxa na Seção 4.1 é "$____"
- **Anexo faltando:** Exhibit B (SLA) referenciado mas não anexado

## Sumário Executivo

Acordo padrão de fornecedor com alguns termos unilaterais. O limite de responsabilidade de 3 meses e os direitos de rescisão assimétricos precisam de atenção. A propriedade de dados está clara.

---

## Termos-Chave

| Termo | Valor | Localização |
|-------|-------|-------------|
| Prazo Inicial | 12 meses | Seção 8.1 |
| Renovação Automática | Períodos de 12 meses, aviso de 60 dias | Seção 8.2 |
| Limite de Responsabilidade | 3 meses de taxas | Seção 10.2 |
| Lei Aplicável | Delaware | Seção 12.1 |

---

## Red Flags (Quick Scan)

| Flag | Encontrado | Localização |
|------|-----------|-------------|
| Limite de responsabilidade < 6 meses | ⚠️ Sim | Seção 10.2 |
| Indenização ilimitada | Não | — |
| Direitos de alteração unilateral | ⚠️ Sim | Seção 14.1 |
| Sem rescisão por conveniência | Não | — |
| Obrigações perpétuas | Não | — |
| Jurisdição offshore | Não | — |

---

## Análise de Risco

### 🔴 Crítico

**Limitação de Responsabilidade** (Seção 10.2)
> "Responsabilidade não excederá as taxas pagas nos três (3) meses anteriores"

- **Problema:** Limite de 3 meses está abaixo do padrão de mercado (tipicamente 12 meses)
- **Risco:** Para contrato de R$600K anual, responsabilidade limitada a R$150K
- **Padrão de Mercado:** 12 meses de taxas
- **Negociabilidade:** Média — a maioria dos fornecedores aceita 6-12 meses
- **Redline:** Mudar "três (3) meses" → "doze (12) meses"
- **Fallback:** Aceitar 6 meses como compromisso

---

### 🟡 Importante

**Rescisão por Conveniência** (Seção 8.5)
> "Fornecedor pode rescindir por qualquer razão com aviso de 30 dias"

- **Problema:** Unilateral; cliente não tem direito equivalente
- **Padrão de Mercado:** Direitos de rescisão mútuos
- **Negociabilidade:** Alta — pedido razoável
- **Redline:** Adicionar "Qualquer parte pode rescindir..." ou mudar para "90 dias"

---

### 🟢 Revisado & Aceitável

| Categoria | Status | Notas |
|-----------|--------|-------|
| Propriedade de Dados | ✓ | Cliente possui todos os dados do cliente |
| Direitos de PI | ✓ | Separação clara, sem cessão ampla |
| Confidencialidade | ✓ | Mútua, prazo de 3 anos, exceções padrão |
| Lei Aplicável | ✓ | Delaware — neutro para contratos comerciais |

---

## Disposições Ausentes

| Disposição | Prioridade | Por Que Importa |
|------------|-----------|-----------------|
| Direitos de Exportação de Dados | Crítica | Sem forma garantida de obter dados na rescisão |
| Créditos de SLA | Importante | 99,9% de uptime declarado mas sem remédio para violação |
| Teto de Aumento de Preço | Importante | Preço de renovação sem limite |

**Linguagem sugerida para Exportação de Dados:**
> "Após rescisão, o Fornecedor disponibilizará os Dados do Cliente para exportação em formato CSV ou JSON por 90 dias sem custo adicional."

---

## Problemas de Consistência Interna

- ⚠️ Seção 5.2 referencia "Exhibit C" mas nenhum Exhibit C existe
- ⚠️ "Informação Confidencial" definida na Seção 3.1 mas usada em minúsculas na Seção 7

---

## Prioridade de Negociação

| # | Problema | Pedido | Negociabilidade |
|---|---------|--------|-----------------|
| 1 | Limite de responsabilidade | 12 meses | Média |
| 2 | Direitos de rescisão | Mútuos | Alta |
| 3 | Exportação de dados | Adicionar disposição | Alta |
| 4 | Teto de preço | 5% anual máx | Média |

---

*Esta revisão é apenas para fins informativos. Termos materiais devem ser revisados por advogado qualificado.*
```

---

## Red Flags Quick Scan

Verificar estes sinais de perigo PRIMEIRO antes da análise profunda:

| Red Flag | Por Que Importa |
|----------|----------------|
| Limite de responsabilidade < 6 meses | Proteção inadequada |
| Indenização ilimitada | Exposição ilimitada |
| "As-is" sem garantia | Sem recurso para defeitos |
| Suspensão unilateral sem aviso | Serviço pode desaparecer |
| Direitos de alteração unilateral | Termos podem mudar |
| Sem rescisão por conveniência | Preso no contrato |
| Obrigações perpétuas (caudas, não-compete) | Exposição indefinida |
| Jurisdição offshore (BVI, Cayman) | Caro para executar |
| Renúncias a conflitos pré-assinadas | Sem recurso para conflitos |
| Linguagem "a seu exclusivo critério" favorável à contraparte | Sem padrão objetivo |
| Renúncia a ação coletiva + arbitragem obrigatória | Remédios limitados |
| Direitos de cessão assimétricos | Eles podem ceder, você não |

---

## Checklists por Tipo de Documento

### Checklist NDA

| Categoria | Verificar |
|-----------|----------|
| Direção | Unilateral ou mútuo? |
| Escopo da definição | "Toda informação" muito amplo? Exceções padrão? |
| Prazo | 2 anos curto, 3-5 típico, indefinido para segredos comerciais |
| Divulgação permitida | "Representantes" definidos? Flow-down exigido? |
| Cláusula de resíduos | Pode usar conhecimento geral retido na memória? |
| Não-solicitação | Funcionários protegidos? |
| Standstill | Previne ações de aquisição hostil? |
| Proibição de contato | Clientes, fornecedores, funcionários protegidos? |
| Devolução/destruição | Certificação exigida? |
| Anúncio público | Proíbe divulgação de discussões? |
| Divulgação compulsória | Aviso exigido? Tempo para buscar ordem de proteção? |
| Liminar | Específico desempenho pré-acordado? Dispensa de caução? |

### Checklist SaaS/MSA

| Categoria | Verificar |
|-----------|----------|
| Limite de responsabilidade | 12+ meses = padrão |
| SLA de uptime | 99,9% com créditos = padrão |
| Direitos de suspensão | Unilateral? Aviso exigido? |
| Propriedade de dados | Cliente possui dados do cliente? |
| Exportação de dados | Formato, duração, custo na rescisão? |
| Aumentos de preço | Limitados? Período de aviso? |
| Aviso de renovação automática | 90+ dias = bom, <60 = risco |
| Rescisão | Mútua por conveniência? Período de cura por justa causa? |
| Subprocessadores | Aviso de mudanças? Direitos de aprovação? |
| Seguro | Fornecedor tem E&O, cyber? |

### Checklist Pagamento/Contrato de Comerciante

| Categoria | Verificar |
|-----------|----------|
| Reserva/holdback | Valor, duração, condições de liberação? |
| Responsabilidade por chargeback | Limitada? Proteção contra fraude? |
| Regras de rede | Incorporadas por referência? Acesso fornecido? |
| Autoridade de débito automático | Aviso antes dos débitos? |
| Timing de liquidação | Quando você recebe fundos? |
| Compromissos de volume | Realistas? Penalidade por déficit? |
| Direitos de suspensão | Imediata ou com aviso? |
| Cauda de rescisão | Por quanto tempo as obrigações sobrevivem? |
| Direitos de auditoria | Frequência, aviso, alocação de custos? |
| Conformidade PCI | Quem arca com o custo? |

### Checklist M&A

| Categoria | Verificar |
|-----------|----------|
| Preço de compra | Mix de caixa vs. ações vs. earnout? |
| Mecânica de earnout | Medição, critério, direitos de auditoria, aceleração? |
| Escrow/holdback | Valor (10-15% típico), duração (12-18 meses), liberação? |
| Sobrevivência de reps | 12-24 meses geral, mais longo para fundamental |
| Teto de indenização | 10-20% do preço de compra típico |
| Tipo de basket | Dedutível verdadeiro vs. tipping? |
| Sandbagging | Pro-comprador ou anti-sandbagging? |
| Não-compete | 2-3 anos, escopo geográfico? |
| Capital de giro | Target, collar, mecanismo de true-up? |
| Definição de MAC | Carve-outs para condições de mercado? |
| Compensação de emprego | Contada no preço de compra ou separada? |

### Checklist Finder/Broker

| Categoria | Verificar |
|-----------|----------|
| Percentual de taxa | Especificado ou em branco? |
| Cálculo da taxa | O que está incluído no valor do negócio? Compensação de emprego? |
| Definição de "comprador coberto" | Quão ampla? Algum carve-out de relacionamento anterior? |
| Período de cauda | 12-24 meses típico; perpétuo = red flag |
| Exclusividade | Exclusivo ou não-exclusivo? |
| Taxa mínima | Valor mínimo? |
| Representação conjunta | Consentimento exigido? Renúncia a conflito? |
| Dedução de escrow | Pagamento automático dos recursos? |
| Prazo/rescisão | Você pode sair? |
| Status de corretor | BD registrado se valores mobiliários envolvidos? |

---

## Categorias de Risco (CUAD 41 + Extensões)

### Básicos do Documento
- Nome e Tipo do Documento
- Partes (nomes legais, funções)
- Data do Acordo / Data de Vigência
- Data de Vencimento
- Termos de Renovação
- **Status do Documento** (rascunho/executado)
- **Campos em Branco / Placeholders**

### Prazo & Rescisão
- Prazo do Contrato / Duração
- Rescisão por Conveniência
- Rescisão por Justa Causa
- Serviços Pós-Rescisão
- Cláusulas de Sobrevivência
- **Direitos de Suspensão** (imediata vs. com aviso)
- **Períodos de Cura**

### Cessão & Controle
- Cláusula Anti-Cessão
- Mudança de Controle
- Requisitos de Consentimento
- **Cessão Assimétrica** (eles podem, você não)

### Termos Financeiros
- Condições de Pagamento
- Restrições / Ajustes de Preço
- Most Favored Nation (MFN)
- Compromisso Mínimo
- Restrições de Volume
- Direitos de Auditoria
- **Tetos de Escalada de Preço**
- **Requisitos de Reserva/Holdback**
- **Autoridade de Débito Automático**

### Responsabilidade & Risco
- Limitação de Responsabilidade
- Teto de Responsabilidade
- Carve-outs de Responsabilidade Ilimitada
- Indenização
- Requisitos de Seguro
- Duração de Garantia
- **Isenção de Garantia (As-Is)**
- **Cláusulas de Remédio Exclusivo**
- **Responsabilidade por Chargeback/Devolução**

### PI & Confidencialidade
- Cessão de Propriedade de PI
- Concessão de Licença
- Licença de Afiliada - Licenciante/Licenciado
- Compromisso de Não Processar
- Não-Compete
- Não-Solicitação (Funcionários/Clientes)
- Exceção de Restrição Competitiva
- Exclusividade
- Não-Difamação
- Duração da Confidencialidade
- Terceiro Beneficiário
- **Cláusula de Resíduos**
- **Propriedade de Feedback**

### Resolução de Disputas
- Lei Aplicável
- Jurisdição / Foro
- Arbitragem vs. Litígio
- Renúncia a Júri
- **Renúncia a Ação Coletiva**
- **Flags de Jurisdição Offshore**

### Disposições Especiais
- ROFR / ROFO / ROFN
- Compartilhamento de Receita/Lucro
- Propriedade Conjunta de PI
- Escrow de Código Fonte
- Licença Irrevogável ou Perpétua
- **Direitos de Exportação de Dados**
- **SLA de Uptime/Disponibilidade**
- **Direitos de Sublicenciamento**
- **Direitos de Alteração Unilateral**

---

## Benchmarks de Padrão de Mercado

| Disposição | Padrão | Flag Amarela | Flag Vermelha |
|------------|--------|-------------|---------------|
| **Limite de responsabilidade** | 12 meses de taxas | 6-11 meses | <6 meses |
| **Duração do não-compete** | 1-2 anos | 3-4 anos | 5+ anos |
| **Geografia do não-compete** | Onde opera o negócio | Estadual | Nacional |
| **Aviso de renovação automática** | 90+ dias | 60-89 dias | <60 dias |
| **Aviso de rescisão** | Mútuo, 60-90 dias | Unilateral, 30 dias | Imediato |
| **Indenização** | Mútua, limitada | Assimétrica | Ilimitada |
| **Sobrevivência de rep (M&A)** | 12-18 meses geral | 24-30 meses | 36+ meses |
| **Escrow (M&A)** | 10-15% por 12-18 meses | 15-20% por 18-24 meses | >20% ou >24 meses |
| **Confidencialidade (NDA)** | 3 anos geral | 2 anos | 5+ anos |
| **Cauda de taxa (broker)** | 12-18 meses | 24 meses | Perpétua |
| **Uptime SLA** | 99,9% com créditos | 99,5% | Sem SLA |
| **Exportação de dados** | 90 dias, formato padrão | 30 dias | Nenhuma |
| **Teto de aumento de preço** | IPC ou 5% anual | 10% anual | Ilimitado |
| **Período de cura** | 30 dias | 15 dias | Nenhum |

---

## Guia de Negociabilidade

| Rating | Significado | Exemplos |
|--------|------------|---------|
| **Alta** | Geralmente aceito | Rescisão mútua, períodos de cura, exportação de dados |
| **Média** | Depende da alavancagem | Aumento do limite de responsabilidade, tetos de preço |
| **Baixa** | Raramente alterado | Regras de rede (pagamentos), requisitos regulatórios |
| **Nenhuma** | Não negociável | Mandatos de rede de cartão, regulamentações bancárias |

**Fatores de dinâmica de poder:**
- Grande cliente + pequeno fornecedor = mais alavancagem
- Startup + fornecedor enterprise = menos alavancagem
- Mercado competitivo = mais alavancagem
- Fornecedor único = menos alavancagem
- Termos regulados = sem alavancagem (legalmente exigidos)

---

## Notas de Jurisdição

**Não-Competes:**
- Califórnia, Dakota do Norte, Oklahoma, Minnesota: Geralmente nulos
- Outros estados: Teste de razoabilidade se aplica
- Brasil: Exige compensação financeira para ser válido

**Escolha da Lei:**
- Delaware: Favorável a empresas, previsível
- Nova York: Acordos financeiros, tribunais sofisticados
- Califórnia: Favorável a empregados, indústria de tecnologia
- BVI/Cayman: Offshore, caro para litigar, potencial red flag

**Locais de Arbitragem:**
- AAA, JAMS: Comercial US padrão
- SIAC (Singapura), LCIA (Londres): Internacional, caro
- Obrigatória + renúncia a coletiva: Limita significativamente os remédios

---

## Guardrails

- **Não é aconselhamento jurídico**: Recomendar revisão por advogado para termos materiais
- **Não é aconselhamento fiscal**: Sinalizar mas não opinar
- **Jurisdição importa**: Notar quando a executoriedade varia
- **Expressar incerteza**: Dizer quando a interpretação não está clara
- **Sem alucinação**: Referenciar apenas texto que está realmente no documento
- **Mostrar o que é aceitável**: Sempre incluir seção "Revisado & Aceitável"
- **Status do documento importa**: Notar se já executado (revisão é informacional)
