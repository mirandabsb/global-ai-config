# AntiGravity Kit — Guia de Instalação

**O que é**: Kit oficial do Google AntiGravity para inicializar projetos com estrutura de agentes, skills e workflows prontos para uso. Agora instalado globalmente.

---

## Uso Global

Como o kit está instalado globalmente, você pode usá-lo diretamente:

```bash
ag-kit init
```

Ou via npx (sempre atualizado):

```bash
npx @vudovn/ag-kit init
```

---

## Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `ag-kit init` | Instala a pasta `.agent` no projeto atual |
| `ag-kit update` | Atualiza para a versão mais recente |
| `ag-kit status` | Verifica o status da instalação |

---

## 🛡️ Regra de Proteção Git (Obrigatória)

Sempre que o comando `ag-kit init` for executado, você **DEVE** garantir que o arquivo `.gitignore` na raiz do projeto contenha as seguintes entradas para evitar o commit de arquivos de configuração local e do diretório do agente:

```gitignore
# AntiGravity Kit
.agent/
.gemini/
GEMINI.md
```

**Nota:** Se o projeto for o próprio repositório core da IDE, esta regra deve ser aplicada com cautela, mas para projetos de usuário, a exclusão da pasta `.agent/` é mandatória para manter a portabilidade e segurança.

---

## Próximos passos após instalação

1. Siga os prompts do CLI para configurar o projeto
2. Abra o projeto no Google AntiGravity IDE
3. Use `/` para ver os workflows e skills disponíveis
