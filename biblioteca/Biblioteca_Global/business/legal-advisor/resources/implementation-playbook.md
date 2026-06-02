# Legal Advisor — Implementation Playbook

> Guia de referência completo para criação de documentação legal em projetos de tecnologia.
> Este playbook cobre templates, checklists de compliance e fluxos de implementação para as principais regulações globais.

---

## 1. Fluxo de Trabalho Geral

```
1. Identificar jurisdições aplicáveis (onde opera, onde estão os usuários)
2. Mapear dados coletados e bases legais
3. Selecionar template adequado ao tipo de negócio
4. Personalizar com dados específicos da empresa
5. Revisar com checklist de compliance
6. Sinalizar itens para revisão jurídica especializada
7. Publicar e configurar mecanismos de consentimento
8. Agendar revisão periódica (mínimo anual ou em mudanças legislativas)
```

---

## 2. Templates por Tipo de Documento

### 2.1 Política de Privacidade

**Estrutura mínima obrigatória (GDPR/LGPD/CCPA):**

```markdown
# Política de Privacidade — [Nome da Empresa]
**Última atualização:** [Data]

## 1. Quem Somos
[Nome da empresa], [CNPJ/Número de registro], com sede em [endereço].
Controlador de dados para fins desta política.

## 2. Dados que Coletamos
| Dado | Finalidade | Base Legal | Retenção |
|------|-----------|-----------|---------|
| E-mail | Comunicação e autenticação | Contrato / Legítimo interesse | Enquanto conta ativa + 3 anos |
| IP / Logs de acesso | Segurança e diagnóstico | Legítimo interesse | 90 dias |
| Dados de pagamento | Processamento de transações | Contrato | Conforme PCI DSS |
| Cookies analíticos | Melhoria do serviço | Consentimento | 13 meses |

## 3. Como Usamos os Dados
- Fornecimento e manutenção do serviço
- Comunicações transacionais (não requer opt-in)
- Marketing (requer opt-in explícito)
- Obrigações legais e regulatórias
- Prevenção a fraudes

## 4. Compartilhamento com Terceiros
Compartilhamos dados com:
- **Processadores de pagamento** (ex: Stripe): necessário para transações
- **Provedores de cloud** (ex: AWS, GCP): hospedagem e infraestrutura
- **Analytics** (ex: Google Analytics): apenas com consentimento
- **Autoridades legais**: quando exigido por lei

Não vendemos dados pessoais a terceiros.

## 5. Transferências Internacionais
[Se aplicável] Dados podem ser transferidos para:
- [País/região]: protegidos por [mecanismo: cláusulas contratuais padrão / adequação / SCCs]

## 6. Seus Direitos
**Usuários da UE/EEA (GDPR):**
- Acesso · Retificação · Erasure ("direito ao esquecimento")
- Portabilidade · Restrição · Objeção · Não sujeição a decisão automatizada

**Usuários da Califórnia (CCPA/CPRA):**
- Saber · Deletar · Corrigir · Opt-out de venda/compartilhamento
- Não discriminação por exercer direitos

**Usuários do Brasil (LGPD):**
- Confirmação · Acesso · Correção · Anonimização/Bloqueio/Eliminação
- Portabilidade · Revogação do consentimento · Revisão de decisões automatizadas

Para exercer seus direitos: [email de privacidade] ou [formulário]
Prazo de resposta: 30 dias (extensível a 60 dias em casos complexos)

## 7. Cookies
Ver Política de Cookies separada. [Link]
Gerencie preferências: [botão/link de configuração de cookies]

## 8. Segurança
Medidas implementadas:
- Criptografia em trânsito (TLS 1.2+) e em repouso
- Controle de acesso com menor privilégio
- Monitoramento e logs de segurança
- Plano de resposta a incidentes

## 9. Retenção de Dados
Retemos dados pelo menor período necessário. Ver tabela na Seção 2.

## 10. Menores de Idade
Nosso serviço não é direcionado a menores de [13/16/18] anos.
[Se coleta dados de menores: procedimentos de verificação de idade e consentimento parental]

## 11. Alterações a Esta Política
Notificaremos alterações materiais com [30 dias de antecedência / e-mail / banner].
Uso continuado após notificação = aceitação.

## 12. Contato e DPO
**Controlador:** [Nome e endereço]
**DPO (quando exigido):** [Nome, e-mail]
**E-mail de privacidade:** privacy@[empresa].com
**Autoridade supervisora (UE):** [Autoridade do país-sede]
```

---

### 2.2 Termos de Serviço / Termos de Uso

**Estrutura recomendada:**

```markdown
# Termos de Serviço — [Nome do Serviço]
**Versão:** [x.x] | **Vigência:** [Data]

## 1. Aceitação dos Termos
Ao acessar ou usar [Serviço], você concorda com estes Termos.
Se não concordar, não utilize o serviço.

## 2. Descrição do Serviço
[Descrição clara do que o serviço oferece, suas limitações e disponibilidade]

## 3. Contas de Usuário
- Você é responsável pela segurança da sua conta
- Informações devem ser precisas e atualizadas
- Uso mínimo: [idade mínima]
- Responsabilidade por atividades na conta

## 4. Uso Aceitável
**Permitido:** [lista de usos permitidos]

**Proibido:**
- Violação de leis aplicáveis
- Infração de direitos de terceiros
- Engenharia reversa ou extração de dados
- Uso para spam ou phishing
- [Específicos do serviço]

## 5. Propriedade Intelectual
- **Serviço:** [Empresa] detém todos os direitos sobre a plataforma
- **Seu conteúdo:** Você mantém direitos; concede licença de uso ao [Serviço]
- **Feedback:** Feedback submetido pode ser usado por [Empresa] sem obrigação

## 6. Pagamentos e Reembolsos
- Preços em [moeda], sujeitos a alteração com aviso prévio de [X dias]
- Planos de assinatura renovam automaticamente
- Política de reembolso: [descrever]
- Disputas de cobrança: contatar [suporte]

## 7. Rescisão
- Você pode cancelar a qualquer momento em [local/processo]
- [Empresa] pode suspender ou encerrar contas por violação destes Termos
- Dados retidos por [período] após encerramento

## 8. Limitação de Responsabilidade
SERVIÇO FORNECIDO "COMO ESTÁ". NA MEDIDA PERMITIDA POR LEI:
- [Empresa] não garante disponibilidade ininterrupta
- Responsabilidade máxima limitada a [valor pago nos últimos 12 meses / $100]
- Sem responsabilidade por danos indiretos, incidentais ou punitivos

## 9. Indenização
Você concorda em indenizar [Empresa] por claims decorrentes de:
- Violação destes Termos
- Seu conteúdo ou uso do serviço
- Violação de direitos de terceiros

## 10. Lei Aplicável e Foro
Estes Termos são regidos pelas leis de [jurisdição].
Disputas: [arbitragem / tribunal de / local]
[Para usuários da UE: direito a foro local do consumidor não é afastado]

## 11. Alterações
Notificaremos alterações materiais via [método].
Uso continuado = aceitação.

## 12. Contato
[Empresa], [endereço], [e-mail legal]
```

---

### 2.3 Política de Cookies

```markdown
# Política de Cookies

## Tipos de Cookies que Usamos

| Tipo | Exemplos | Base Legal | Opt-out |
|------|---------|-----------|---------|
| **Estritamente necessários** | Sessão, autenticação, CSRF | Interesse legítimo | Não (essenciais) |
| **Funcionais** | Preferências de idioma, tema | Consentimento | Sim |
| **Analíticos** | Google Analytics, Mixpanel | Consentimento | Sim |
| **Marketing** | Meta Pixel, Google Ads | Consentimento | Sim |

## Como Gerenciar Cookies
- Configurações do navegador: [link para guias]
- Nossa ferramenta de preferências: [link/botão]
- Opt-out global: [NAI opt-out, Google Ads Settings]

## Duração
Cookies de sessão: expiram ao fechar o navegador
Cookies persistentes: [X meses] (ver lista completa no [link])
```

---

### 2.4 Contrato de Processamento de Dados (DPA)

**Cláusulas obrigatórias (GDPR Art. 28):**

```markdown
# Data Processing Agreement (DPA)

Entre: [Controlador — Empresa do cliente]
E: [Processador — Sua empresa]

## 1. Objeto e Instruções
Processador processa dados apenas conforme instruções documentadas do Controlador.

## 2. Confidencialidade
Pessoal autorizado sujeito a obrigação de confidencialidade.

## 3. Segurança (Art. 32 GDPR)
Medidas técnicas e organizacionais implementadas:
- [lista de medidas de segurança]

## 4. Subprocessadores
Lista atual: [link ou anexo]
Notificação de mudanças: [X dias de antecedência]
Direito de objeção: [processo]

## 5. Assistência ao Controlador
Processador auxilia com:
- Requisições de direitos dos titulares
- Avaliações de impacto (DPIA)
- Notificações de violação (prazo: 72h após descoberta)

## 6. Deleção ou Devolução
Ao término: deletar ou devolver todos os dados pessoais (escolha do Controlador)

## 7. Auditoria
Controlador pode auditar ou contratar terceiro para auditoria com [X dias] de aviso.

## 8. Transferências Internacionais
[Mecanismo utilizado: SCCs, adequação, etc.]
```

---

## 3. Checklists de Compliance por Regulação

### GDPR (União Europeia)

- [ ] Identificar base legal para cada finalidade de processamento
- [ ] Registrar atividades de processamento (Art. 30) — obrigatório para empresas >250 funcionários ou alto risco
- [ ] Nomear DPO se: autoridade pública, monitoramento sistemático em larga escala, ou dados sensíveis em larga escala
- [ ] Implementar Privacy by Design e Privacy by Default
- [ ] Ter procedimento de resposta a violações (72h para autoridade + titulares se alto risco)
- [ ] Realizar DPIA para processamentos de alto risco
- [ ] Garantir mecanismo para exercício de direitos (30 dias)
- [ ] Configurar gestão de consentimento (granular, revogável, sem prejuízo)
- [ ] Contratos DPA assinados com todos os processadores
- [ ] Mecanismo para transferências internacionais (SCCs, adequação)

### LGPD (Brasil)

- [ ] Mapear bases legais utilizadas (9 hipóteses do Art. 7)
- [ ] Nomear Encarregado (DPO) — obrigatório para todos os controladores
- [ ] Publicar contato do Encarregado na política de privacidade
- [ ] Implementar direitos dos titulares (Art. 18): acesso, correção, eliminação, portabilidade, etc.
- [ ] Relatório de Impacto à Proteção de Dados (RIPD) para alto risco
- [ ] Comunicar incidentes à ANPD (prazo razoável, a ser regulamentado)
- [ ] Bases legais específicas para dados sensíveis (saúde, biométrico, etc.)
- [ ] Consentimento específico e destacado quando utilizado como base legal
- [ ] Adequar para transferências internacionais (países com proteção adequada ou garantias)

### CCPA/CPRA (Califórnia)

- [ ] Verificar se se aplica: receita >$25M, OU >100K consumidores CA, OU >50% receita de venda de dados
- [ ] Publicar aviso "Do Not Sell or Share My Personal Information"
- [ ] Implementar opt-out de venda/compartilhamento (link visível na homepage)
- [ ] Adicionar categoria "Sensitive Personal Information" e opt-out correspondente
- [ ] Responder requisições verificáveis em 45 dias (extensível a 90)
- [ ] Não discriminar usuários que exercem direitos
- [ ] Atualizar política de privacidade com categorias de dados, fontes, finalidades, destinatários
- [ ] Global Privacy Control (GPC): honrar sinais automáticos de opt-out

### CAN-SPAM / CASL (E-mail Marketing)

**CAN-SPAM (EUA) — mínimo obrigatório:**
- [ ] Identificação clara do remetente (nome real / nome comercial)
- [ ] Endereço físico válido no rodapé
- [ ] Assunto não enganoso
- [ ] Link de descadastro claro e funcional (opt-out em 10 dias úteis)
- [ ] Não usar e-mails de terceiros capturados sem permissão

**CASL (Canadá) — mais restritivo:**
- [ ] Consentimento expresso ANTES de enviar (opt-in obrigatório)
- [ ] Consentimento implícito limitado: relação comercial existente nos últimos 2 anos
- [ ] Identificação completa do remetente
- [ ] Mecanismo de descadastro que funciona em 10 dias úteis

### COPPA (Crianças — EUA)

- [ ] Verificar se coleta dados de menores de 13 anos
- [ ] Obter consentimento verificável dos pais/responsáveis
- [ ] Política de privacidade específica para crianças
- [ ] Não condicionar participação à divulgação de mais dados do que necessário
- [ ] Permitir pais de rever, deletar ou optar por não divulgar dados

---

## 4. Glossário de Termos Jurídicos

| Termo | Definição |
|-------|----------|
| **Controlador** | Entidade que decide sobre finalidade e meios do processamento |
| **Processador** | Entidade que processa dados em nome do controlador |
| **Titular** | Pessoa natural a quem os dados se referem |
| **DPIA** | Data Protection Impact Assessment — avaliação de impacto |
| **DPO** | Data Protection Officer / Encarregado de Proteção de Dados |
| **SCCs** | Standard Contractual Clauses — mecanismo de transferência internacional |
| **Pseudonimização** | Processo que impede atribuição direta sem informação adicional |
| **Anonimização** | Processo irreversível de desidentificação (dado deixa de ser pessoal) |
| **Base legal** | Fundamento jurídico que autoriza o processamento |
| **Consentimento** | Manifestação livre, específica, informada e inequívoca |
| **Legítimo interesse** | Base legal que requer balanceamento com direitos dos titulares |

---

## 5. Bandeiras Vermelhas — Quando Escalar para Advogado

Sempre recomendar revisão jurídica especializada quando:

- 🔴 Processamento de dados sensíveis em larga escala (saúde, biométrico, político, religioso)
- 🔴 Decisões automatizadas com efeitos jurídicos significativos (crédito, emprego)
- 🔴 Monitoramento sistemático de espaços públicos
- 🔴 Transferência de dados para países sem adequação (sem SCCs)
- 🔴 Coleta de dados de crianças
- 🔴 Receita significativa de publicidade direcionada
- 🔴 Serviço regulado (financeiro, saúde, educação infantil)
- 🔴 Violação ou suspeita de violação de dados
- 🔴 Investigação ou notificação de autoridade reguladora
- 🔴 M&A com ativos de dados significativos

---

> ⚠️ **Aviso Legal**: Este playbook é material educacional e não constitui aconselhamento jurídico.
> Consulte um advogado qualificado para orientação específica à sua situação.
