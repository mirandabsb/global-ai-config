import subprocess
from datetime import datetime
import re
import sys
import os

# Args: <remoto> <pasta>
# Exemplo: python3 generate_preview.py onedrive Imagens
if len(sys.argv) < 3:
    print("Uso: python3 generate_preview.py <remoto> <pasta>")
    sys.exit(1)

REMOTO = sys.argv[1].rstrip(":")
PASTA = sys.argv[2]
REMOTE = f"{REMOTO}:{PASTA}"

def clean_description(name):
    if not name: return "Avulsas"
    name = re.sub(r'^\d{4}[_-]?\d{2}[_-]?', '', name)
    name = name.replace('_', ' ')
    return ' '.join(name.split())

def generate_preview():
    print(f"Gerando preview rápido para {REMOTE}...")
    # Limita profundidade e usa --files-only para ser mais rápido
    cmd = ["rclone", "lsf", REMOTE, "--format", "pt", "--recursive", "--max-depth", "2", "--files-only"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    lines = result.stdout.splitlines()
    preview = {} # target_dir -> [sample_files]
    
    for line in lines[:500]: # Limita para o preview ser rápido
        if ';' not in line: continue
        rel_path, date_str = line.split(';')
        parts = rel_path.split('/')
        
        try:
            dt = datetime.strptime(date_str.split()[0], '%Y-%m-%d')
            year = dt.strftime('%Y')
            month = dt.strftime('%m')
        except: continue

        if len(parts) > 1:
            description = clean_description(parts[0])
        else:
            description = "Avulsas"
            
        target_dir = f"{year}/{month}/{description}"
        if target_dir not in preview:
            preview[target_dir] = []
        
        if len(preview[target_dir]) < 3: # Apenas 3 exemplos por pasta
            preview[target_dir].append(rel_path)

    # Gerar Markdown
    md = f"# Preview de Reorganização: {TARGET_SUBDIR}\n\n"
    md += "Esta é uma amostra de como os arquivos serão movidos:\n\n"
    md += "| Origem | Destino Planejado |\n"
    md += "| :--- | :--- |\n"
    
    for target, files in preview.items():
        for f in files:
            md += f"| `{f}` | `{target}/{os.path.basename(f)}` |\n"
            
    # Salva preview na pasta do script (ao lado da skill)
    output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "reorganization_preview.md")
    output_path = os.path.normpath(output_path)
    with open(output_path, "w") as f:
        f.write(md)
    print(f"Preview gerado em: {output_path}")

if __name__ == "__main__":
    generate_preview()
