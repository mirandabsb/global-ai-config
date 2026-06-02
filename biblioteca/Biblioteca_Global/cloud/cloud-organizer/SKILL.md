---
name: cloud-organizer
description: >
  Skill de organização de pastas em serviços de nuvem (OneDrive e Google Drive) via rclone.
  Organiza Imagens e Vídeos cronologicamente (Ano/Mês/Descrição) e Documentos
  conforme o usuário definir interativamente.

  Ative esta skill quando o usuário pedir para organizar, reorganizar ou estruturar
  pastas no OneDrive ou Google Drive.

  Exemplos de ativação:
  - "organize minha pasta de Imagens no OneDrive"
  - "reorganize os Vídeos no Google Drive"
  - "organize minha pasta Documentos"
  - "reorganize meu cloud storage"
---

# Cloud Organizer — Skill de Organização de Nuvem

> Ferramenta: `rclone` (requerido e já configurado no sistema)
> Suporte: **OneDrive** (`onedrive:`) e **Google Drive** (`gdrive_imma:`)

---

## Regras Fixas de Organização

### 📷 Imagens e 🎬 Vídeos → Estrutura Cronológica (SEMPRE)

A estrutura abaixo é **fixa e não negociável** para Imagens e Vídeos. Não pergunte ao usuário sobre ela — apenas execute:

```
Remote:Imagens/
  └── YYYY/
        └── MM/
              └── Nome da Pasta Original/
                    └── arquivo.jpg
```

Exemplos reais:
- `africa/IMG_0205.JPG` (data: 2004-03-25) → `2004/03/africa/IMG_0205.JPG`
- `Porto - Novembro 2020/IMG01915.JPG` (data: 2020-11-10) → `2020/11/Porto - Novembro 2020/IMG01915.JPG`
- `IMG_20260226_112415.jpg` (avulso, data: 2026-02-26) → `2026/02/Avulsas/IMG_20260226_112415.jpg`

**Regras de limpeza de nomes:**
- Substituir `_` por espaço
- Remover prefixos de data do tipo `2023_01_` ou `2023-01-` do início do nome
- Preservar o nome restante como descrição
- Arquivos soltos na raiz (sem subpasta) → colocar em `YYYY/MM/Avulsas/`

**Referência de data:**
- Usar a data de modificação reportada pelo rclone (campo `ModTime`)
- Se uma pasta tem arquivos de meses/anos diferentes, **cada arquivo vai para seu respectivo Ano/Mês**, mas mantendo o mesmo nome de subpasta

### 📄 Documentos → Estrutura Definida pelo Usuário (SEMPRE perguntar)

Para Documentos, **sempre** pergunte antes de qualquer ação:

> 📂 **Como você quer organizar sua pasta de Documentos?**
>
> Algumas sugestões:
> 1. **Por Categoria** — `Documentos/Financeiro/`, `Documentos/Pessoal/`, `Documentos/Trabalho/`
> 2. **Cronológico** — `Documentos/YYYY/MM/Descrição/`
> 3. **Misto** — Categorias no primeiro nível, depois por ano dentro de cada categoria
> 4. **Manual** — Você me diz a estrutura e eu aplico
>
> Qual você prefere? (informe o número ou descreva sua preferência)

Após a resposta, confirme a estrutura proposta antes de executar.

---

## Passo 1 — Identificar o Alvo

Determine o que o usuário quer organizar. Se não ficou claro, pergunte:

> Qual pasta você quer organizar?
> - `Imagens`
> - `Videos`
> - `Documentos`
> - Outra (informe o nome)

E qual serviço de nuvem?
> - OneDrive (remoto: `onedrive:`)
> - Google Drive (remoto: `gdrive_imma:`)

---

## Passo 2 — Gerar Preview Antes de Agir

**Nunca mova arquivos sem antes mostrar o preview ao usuário.**

Execute o script de preview:

```bash
python3 ~/.agent/Biblioteca_Global/cloud/cloud-organizer/scripts/generate_preview.py <REMOTO> <PASTA>
# Exemplo:
python3 ~/.agent/Biblioteca_Global/cloud/cloud-organizer/scripts/generate_preview.py onedrive Imagens
```

O script gera uma tabela Markdown com amostra das movimentações planejadas. Apresente o resultado ao usuário e pergunte:

> ✅ Este é o preview da reorganização. Os arquivos serão movidos conforme a tabela acima.
>
> **Deseja confirmar e executar?** (sim / não / ajustar)

Só avance ao Passo 3 após confirmação explícita.

---

## Passo 3 — Executar a Organização

Após confirmação, execute o script principal:

```bash
python3 ~/.agent/Biblioteca_Global/cloud/cloud-organizer/scripts/organize_cloud_universal.py <REMOTO> <PASTA>
# Exemplo:
python3 ~/.agent/Biblioteca_Global/cloud/cloud-organizer/scripts/organize_cloud_universal.py onedrive Imagens
```

O script opera **server-side** via rclone: sem downloads, sem uploads — apenas movimentações no servidor.

Monitore a saída e reporte progresso ao usuário. Em caso de erro em um arquivo, continue com os demais e apresente um relatório final dos erros.

---

## Passo 4 — Relatório Final

Ao concluir, apresente:

```
✅ Organização concluída!

📊 Resumo:
  - Pastas processadas: X
  - Arquivos movidos: Y
  - Arquivos com erro: Z (listar se houver)

📁 Nova estrutura criada:
  - 2024/03/Porto - Novembro 2020/
  - 2020/11/Reforma Casa/
  - ...
```

---

## Scripts de Suporte

Os scripts ficam em `scripts/` ao lado deste SKILL.md:

**Localização:** `/home/marcos/Antigravity/.agent/Biblioteca_Global/cloud/cloud-organizer/scripts/`

| Script | Função |
|--------|--------|
| `generate_preview.py` | Gera preview Markdown das movimentações antes de executar |
| `organize_cloud_universal.py` | Executa a organização real via rclone |
| `organize_cloud_universal.ps1` | Versão Windows via PowerShell + Robocopy (para pastas locais) |

### Assinatura dos scripts Python

```
python3 generate_preview.py <remoto> <pasta>
  # remoto: "onedrive" ou "gdrive_imma"
  # pasta:  "Imagens", "Videos", "Documentos", etc.

python3 organize_cloud_universal.py <remoto> <pasta> [--dry-run]
  # --dry-run: simula sem mover nada (use para debug)
```

---

## Tratamento de Casos Especiais

| Situação | Ação |
|----------|------|
| Arquivo já está em `YYYY/MM/Descrição` | Ignorar — já está organizado |
| Pasta vazia | Ignorar e reportar no final |
| Nome de pasta com data embutida (ex: `2013_00_viagem`) | Remover prefixo, usar data dos arquivos internos |
| Arquivo sem subpasta (solto na raiz) | Mover para `YYYY/MM/Avulsas/` |
| Data inválida ou ausente | Usar `0000/00/Sem Data/` e reportar no final |
| Dois arquivos com mesmo nome no destino | Adicionar sufixo `_2`, `_3`, etc. |

---

## Notas Importantes

- **OneDrive**: remote configurado como `onedrive:` no rclone
- **Google Drive**: remote configurado como `gdrive_imma:` no rclone
- Verifique disponibilidade com `rclone listremotes` antes de iniciar
- Para Documentos, **sempre** pergunte a estrutura antes de qualquer ação
- Para Imagens/Vídeos, a estrutura é fixa — não precisa perguntar, só confirmar o preview
