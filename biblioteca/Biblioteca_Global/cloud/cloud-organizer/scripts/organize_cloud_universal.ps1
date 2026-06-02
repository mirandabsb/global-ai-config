param (
    [Parameter(Mandatory=$true)]
    [string]$Path
)

if (-not (Test-Path $Path)) {
    Write-Host "Caminho não encontrado: $Path" -ForegroundColor Red
    return
}

Set-Location $Path

# Obtém todas as pastas na raiz (ignorando as que já são anos)
$folders = Get-ChildItem -Directory | Where-Object { $_.Name -notmatch '^\d{4}$' }

foreach ($folder in $folders) {
    Write-Host "`n--- Processando: $($folder.Name) ---" -ForegroundColor Cyan
    
    # Tenta obter a data do arquivo mais recente ou da própria pasta se vazia
    $files = Get-ChildItem -Path $folder.FullName -File -Recurse
    if ($files) {
        # Usa a data do arquivo mais recente para representar a pasta
        $refDate = ($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
    } else {
        $refDate = $folder.LastWriteTime
    }

    # Extrai Ano e Mês
    $year = $refDate.ToString("yyyy")
    $month = $refDate.ToString("MM")

    # Limpa o nome da pasta (remove data inicial e troca _ por espaço)
    $cleanName = $folder.Name -replace '^\d{4}[_-]\d{2}[_-]', ''
    $cleanName = $cleanName -replace '^\d{4}[_-]', ''
    $cleanName = $cleanName.Replace('_', ' ').Trim()

    # Define o caminho de destino (Estrutura: Ano\Mês\Descrição)
    $targetDir = Join-Path $Path (Join-Path $year (Join-Path $month $cleanName))

    # Cria a pasta de destino se não existir
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    Write-Host "  -> Destino: $targetDir" -ForegroundColor Gray

    # Move todo o conteúdo para o novo destino
    # Usamos Robocopy para maior robustez com caminhos longos e metadados
    $sourcePath = $folder.FullName
    Write-Host "  -> Movendo arquivos..." -ForegroundColor Yellow
    
    # Move arquivos mantendo a estrutura interna se houver
    robocopy "$sourcePath" "$targetDir" /E /MOVE /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null

    # Remove a pasta original se o robocopy deixou o diretório pai
    if (Test-Path $sourcePath) {
        Remove-Item -Path $sourcePath -Force -Recurse -ErrorAction SilentlyContinue
    }
    
    Write-Host "  [OK] Organizado com sucesso!" -ForegroundColor Green
}

Write-Host "`nReorganização de '$Path' concluída!" -ForegroundColor Magenta
