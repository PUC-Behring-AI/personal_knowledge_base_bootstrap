#!/usr/bin/env bash
# Cria a estrutura inicial da base a partir de kb_agent/seeds/.
#
# - Espelha a árvore de seeds na raiz do repositório.
# - Cria pastas e arquivos que ainda não existem.
# - NUNCA sobrescreve nem apaga nada: arquivo existente é pulado e reportado.
# - Substitui {{DATE}} pela data de hoje (YYYY-MM-DD) nos arquivos criados.
#
# Uso: bash kb_agent/scripts/bootstrap-structure.sh   (a partir da raiz da base)
#      bash kb_agent/scripts/bootstrap-structure.sh --dry-run

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
seeds="$root/kb_agent/seeds"
today="$(date +%F)"
dry=0
[ "${1:-}" = "--dry-run" ] && dry=1

[ -d "$seeds" ] || { echo "erro: $seeds não existe" >&2; exit 1; }

created=0 skipped=0
while IFS= read -r -d '' src; do
  rel="${src#"$seeds"/}"
  dst="$root/$rel"
  if [ -e "$dst" ]; then
    echo "pulado   $rel (já existe)"
    skipped=$((skipped + 1))
    continue
  fi
  if [ "$dry" -eq 1 ]; then
    echo "criaria  $rel"
  else
    mkdir -p "$(dirname "$dst")"
    sed "s/{{DATE}}/$today/g" "$src" > "$dst"
    echo "criado   $rel"
  fi
  created=$((created + 1))
done < <(find "$seeds" -type f -print0 | sort -z)

echo
echo "criados: $created · pulados: $skipped · nada foi sobrescrito ou apagado"
