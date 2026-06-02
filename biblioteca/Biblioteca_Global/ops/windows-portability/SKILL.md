---
name: windows-portability
description: >
  Instruções para sincronizar e configurar o ambiente AntiGravity no Windows.
  Cobre setup via WSL2 (recomendado) e Windows Nativo.
---

# 🪟 Windows Portability — Guia de Setup

Este guia contém as instruções necessárias para que o **AntiGravity** funcione perfeitamente no ambiente Windows, mantendo paridade com a configuração do Linux.

---

## 🚀 Opção 1: WSL2 (Recomendado - Paridade Total)

Esta é a melhor forma de usar o AntiGravity no Windows, pois permite rodar todos os scripts bash, rclone e MCPs sem modificações.

### Passo 1: Preparar o WSL
Certifique-se de que o WSL2 está instalado com uma distro (ex: Ubuntu).
```powershell
wsl --install
```

### Passo 2: Clonar o Repositório
Dentro do terminal Linux (WSL), execute:
```bash
# Clone o repositório
git clone git@github.com-mirandabsb:mirandabsb/AntiGravity_Linux.git ~/Antigravity

# Entre na pasta e execute o setup
cd ~/Antigravity
./setup.sh
```

### Passo 3: Sincronizar Segredos
Copie o arquivo `.env_secrets` da sua máquina Linux original para:
`~/Antigravity/.agent/Configuration/.env_secrets`

---

## 🛠️ Opção 2: Windows Nativo (Powershell)

Use esta opção se preferir não usar o WSL.

### Passo 1: Clonagem
Use o Git para Windows para clonar o repositório:
```powershell
git clone git@github.com-mirandabsb:mirandabsb/AntiGravity_Linux.git $HOME/Antigravity
```

### Passo 2: Ajustar Configurações
Edite o arquivo `~/Antigravity/antigravity.config.yaml`:
- Altere os caminhos de `/home/marcos/` para `C:/Users/marcos/` (ou seu usuário correspondente).

### Passo 3: Dependências
- **Python**: Instale o Python 3 e adicione ao PATH.
- **Rclone**: Instale a versão Windows do rclone para usar as skills de cloud.

---

## 🧠 Instrução para a LLM (AntiGravity no Windows)

Se você é o AntiGravity rodando no Windows e está lendo este arquivo, siga este protocolo:

1. **Assuma o contexto de @devops-engineer**.
2. **Verifique o ambiente**: Identifique se você está no WSL ou Powershell.
3. **Valide os caminhos**: Verifique se o `antigravity.config.yaml` aponta para diretórios existentes no Windows.
4. **Segredos**: Verifique se o arquivo `.env_secrets` em `.agent/Configuration/` contém os tokens necessários para o Neon, Sentry e n8n.
5. **Correção Automática**: Se detectar caminhos no formato Linux em um ambiente Windows nativo, proponha a correção imediata.

---

> **Nota de Sincronização**: Sempre faça `git push` após instalar novas skills ou agentes no Linux para que eles estejam disponíveis após o `git pull` no Windows.
