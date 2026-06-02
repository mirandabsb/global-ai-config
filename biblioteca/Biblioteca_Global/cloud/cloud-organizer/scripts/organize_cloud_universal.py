import subprocess
import os
import sys
import re
from datetime import datetime

# Args: <remoto> <pasta> [--dry-run]
# Exemplo: python3 organize_cloud_universal.py onedrive Imagens
# Exemplo: python3 organize_cloud_universal.py gdrive_imma Videos --dry-run

if len(sys.argv) < 3:
    print("Uso: python3 organize_cloud_universal.py <remoto> <pasta> [--dry-run]")
    print("  remoto: 'onedrive' ou 'gdrive_imma'")
    print("  pasta:  'Imagens', 'Videos', 'Documentos', etc.")
    sys.exit(1)

REMOTO = sys.argv[1].rstrip(":")
PASTA = sys.argv[2]
DRY_RUN = "--dry-run" in sys.argv
REMOTE_PATH = f"{REMOTO}:{PASTA}"

moved = 0
errors = []
skipped = 0
new_dirs = set()

def clean_description(name):
    if not name:
        return "Avulsas"
    name = re.sub(r'^\d{4}[_-]?\d{2}[_-]?', '', name)
    name = re.sub(r'^\d{4}[_-]?', '', name)
    name = name.replace('_', ' ')
    return ' '.join(name.split()).strip() or "Avulsas"

def get_file_list():
    cmd = ["rclone", "lsf", REMOTE_PATH, "--format", "pt", "--recursive", "--files-only"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"[ERRO] Falha ao listar {REMOTE_PATH}: {result.stderr}")
        sys.exit(1)
    return result.stdout.splitlines()

def move_file(src_rel, dst_rel):
    global moved
    src = f"{REMOTE_PATH}/{src_rel}"
    dst = f"{REMOTE_PATH}/{dst_rel}"
    cmd = ["rclone", "moveto", src, dst]
    if DRY_RUN:
        print(f"  [DRY-RUN] {src_rel} → {dst_rel}")
        moved += 1
        return True
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        moved += 1
        return True
    else:
        errors.append(f"{src_rel}: {result.stderr.strip()}")
        return False

def already_organized(parts):
    """Verifica se o arquivo já está na estrutura YYYY/MM/..."""
    return (
        len(parts) >= 3
        and re.match(r'^\d{4}$', parts[0])
        and re.match(r'^\d{2}$', parts[1])
    )

def run():
    print(f"\n{'[DRY-RUN] ' if DRY_RUN else ''}Organizando: {REMOTE_PATH}")
    print("=" * 60)

    files = get_file_list()
    total = len(files)
    print(f"Total de arquivos encontrados: {total}\n")

    for i, line in enumerate(files, 1):
        if ';' not in line:
            continue

        rel_path, date_str = line.split(';', 1)
        parts = rel_path.split('/')

        if already_organized(parts):
            skipped += 1
            continue

        try:
            dt = datetime.strptime(date_str.strip().split()[0], '%Y-%m-%d')
            year = dt.strftime('%Y')
            month = dt.strftime('%m')
        except Exception:
            dst_rel = f"0000/00/Sem Data/{parts[-1]}"
            errors.append(f"Data inválida: {rel_path}")
            print(f"  [!] Data inválida: {rel_path}")
            continue

        if len(parts) > 1:
            description = clean_description(parts[0])
            filename = '/'.join(parts[1:])
        else:
            description = "Avulsas"
            filename = parts[0]

        dst_rel = f"{year}/{month}/{description}/{filename}"
        new_dirs.add(f"{year}/{month}/{description}/")

        print(f"  [{i}/{total}] {rel_path}")
        print(f"         → {dst_rel}")
        move_file(rel_path, dst_rel)

    print("\n" + "=" * 60)
    print(f"✅ Concluído!")
    print(f"   Arquivos movidos:   {moved}")
    print(f"   Já organizados:     {skipped}")
    print(f"   Erros:              {len(errors)}")

    if new_dirs:
        print(f"\n📁 Novas estruturas criadas ({len(new_dirs)}):")
        for d in sorted(new_dirs)[:20]:
            print(f"   {REMOTE_PATH}/{d}")
        if len(new_dirs) > 20:
            print(f"   ... e mais {len(new_dirs) - 20} pastas")

    if errors:
        print(f"\n⚠️ Erros ({len(errors)}):")
        for e in errors:
            print(f"   {e}")

if __name__ == "__main__":
    run()
