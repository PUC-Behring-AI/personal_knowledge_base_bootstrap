# Cria a estrutura inicial da base a partir de kb_agent/seeds/ (versão PowerShell).
#
# - Espelha a árvore de seeds na raiz do repositório.
# - Cria pastas e arquivos que ainda não existem.
# - NUNCA sobrescreve nem apaga nada: arquivo existente é pulado e reportado.
# - Substitui {{DATE}} pela data de hoje (YYYY-MM-DD) nos arquivos criados.
#
# Uso: powershell -ExecutionPolicy Bypass -File kb_agent\scripts\bootstrap-structure.ps1
#      ... -DryRun

param([switch]$DryRun)

$ErrorActionPreference = 'Stop'
$root  = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$seeds = Join-Path $root 'kb_agent\seeds'
$today = Get-Date -Format 'yyyy-MM-dd'

if (-not (Test-Path $seeds)) { throw "erro: $seeds não existe" }

$created = 0; $skipped = 0
Get-ChildItem -Path $seeds -Recurse -File -Force | Sort-Object FullName | ForEach-Object {
  $rel = $_.FullName.Substring($seeds.Length + 1)
  $dst = Join-Path $root $rel
  if (Test-Path $dst) {
    Write-Output "pulado   $rel (já existe)"
    $script:skipped++
    return
  }
  if ($DryRun) {
    Write-Output "criaria  $rel"
  } else {
    New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
    (Get-Content -Raw -Encoding UTF8 $_.FullName) -replace '\{\{DATE\}\}', $today |
      Set-Content -NoNewline -Encoding UTF8 $dst
    Write-Output "criado   $rel"
  }
  $script:created++
}

Write-Output ""
Write-Output "criados: $created · pulados: $skipped · nada foi sobrescrito ou apagado"
