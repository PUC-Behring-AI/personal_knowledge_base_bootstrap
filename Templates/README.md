# Templates

Modelos de nota. Configure esta pasta no Obsidian em **Settings → Core plugins → Templates → Template folder location** = `Templates`. Os campos `{{date:...}}`, `{{time:...}}` e `{{title}}` são preenchidos pelo Obsidian ao inserir o template; o assistente preenche os mesmos campos quando cria a nota por você.

| Template | Usado por | Onde a nota vai |
|---|---|---|
| `Diario.md` | skill `daily-log` | `01 Projects/Logs diários/YYYY/YYYY-MM-DD.md` |
| `Resumo semanal.md` | skills `weekly-review`, `compress` | `01 Projects/Logs diários/Resumos/YYYY-Www.md` |
| `Resumo mensal.md` | skill `compress` | `01 Projects/Logs diários/Resumos/YYYY-MM.md` |
| `Resumo trimestral.md` | skill `compress` | `01 Projects/Logs diários/Resumos/YYYY-Qn.md` |
| `Projeto.md` | skill `process-inbox` | `01 Projects/<nome>/<nome>.md` |
| `Paper.md` | operação Ingerir (nota de leitura) | `03 Resources/<tema>/<Autor Ano - Título>.md` |

Todo template começa com um cabeçalho de metadados (frontmatter) que tem, no mínimo:

```yaml
---
origem: usuario+assistente   # quem escreveu: usuario | assistente | usuario+assistente
tags: [exemplo, outra-tag]   # lista livre; pode ser vazia: []
---
```

`tipo` (transitoria, leitura, permanente, diario, resumo-*) e `data` ou `periodo` completam o cabeçalho conforme o tipo de nota. Crie os seus templates para os tipos de nota que se repetem (paper, reunião, pessoa), mantendo esses campos; o assistente passa a usá-los quando existirem.
