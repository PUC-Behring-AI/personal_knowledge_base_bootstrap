---
name: weekly-review
description: Conduz a revisão semanal do GTD em ~15 minutos e produz a nota da semana (01 Projects/Logs diários/Resumos/YYYY-Www.md). Processa o inbox, verifica projetos, resume a semana a partir dos diários, sugere links e faz commit. Use para "revisão semanal", "fecha a semana", "review" ou quando o healthcheck detectar semana encerrada sem nota.
---

# weekly-review

"Revisão rima com versão." O usuário responde perguntas; você faz o bookkeeping. Ao final existe uma nota da semana e um commit.

## Convenção
- Antes de escrever, confira a estrutura de `01 Projects/Logs diários/` contra a seção "Logs diários" do `AGENTS.md`. Diários fora do padrão são corrigidos (com confirmação) antes de serem resumidos, senão o resumo linka para caminhos que vão mudar.
- Caminho: `01 Projects/Logs diários/Resumos/YYYY-Www.md`, semana ISO (segunda a domingo). Ex.: `2026-W39.md`.
- Frontmatter: `tipo: resumo-semanal`, `periodo: YYYY-Www`, `inicio: YYYY-MM-DD`, `fim: YYYY-MM-DD`, `origem: assistente`.
- A nota linka para todos os diários da semana. O que não está no resumo continua nos diários; o resumo não substitui.

## Passos (nesta ordem; pare em cada pergunta)

Inbox → projetos → objetivos → diários → nota da semana → links → índices → commit.

1. **Delimite a semana.** Por padrão, a semana ISO corrente (ou a anterior, se hoje é segunda). Diga as datas. Verifique se a nota já existe; se sim, ofereça atualizar em vez de recriar.
2. **Inbox** → invoque `process-inbox`. Se o inbox está vazio, diga e siga.
3. **Projetos.** Para cada nota-raiz em `01 Projects/`:
   - Tem `Próximo passo` preenchido? Se não, pergunte (lógica de `next-action`).
   - Terminou? → proponha mover para `04 Archive/` com uma nota de fechamento de 3 linhas (entregue, ficou de fora, aprendizado).
   - Parado há >14 dias? → mencione, sem julgamento; pergunte se continua projeto, vira área, ou arquiva.
   Faça tudo em uma rodada de perguntas, não uma por projeto.
   Depois, **`Objetivos.md`**: para cada objetivo, o status e o próximo passo ainda são verdade? Algum projeto desta semana não pertence a objetivo nenhum? Atualize `Última movimentação` só nos objetivos que de fato se moveram; os parados há mais de 14 dias ficam visíveis no healthcheck. Não crie objetivos; pergunte.
4. **Leia os diários da semana** (`01 Projects/Logs diários/YYYY/YYYY-MM-DD.md` no intervalo). Se não houver diários, use `git log --since` e as notas modificadas na semana como matéria-prima, e diga que o resumo está baseado nisso.
5. **Escreva a nota da semana** no formato abaixo. Regras:
   - Cada afirmação linka para o diário ou nota de origem.
   - Decisões e aprendizados vêm dos callouts `[!decision]` e `[!learning]` dos diários, mais o que o usuário disser agora.
   - Seção **Fora do resumo**: liste em uma linha cada o que você leu e deixou de fora. Perda por compressão fica visível.
6. **Conexões.** Proponha até 3 `[[links]]` entre notas tocadas nesta semana e notas antigas, citando o trecho que justifica cada um. O usuário aceita ou recusa; aplique só os aceitos.
7. **Atualize** `index.md` (nota da semana + o que foi movido), `_sistema/progresso.md` (se a trilha avançou; ao menos duas revisões feitas → nível 3 em uso) e `_sistema/log.md`: `## [YYYY-MM-DD] skill | weekly-review: YYYY-Www (N inbox, P projetos, A arquivados)`.
8. **Commit**: `git add -A && git commit -m "Revisão semanal YYYY-Www"`. Ofereça push se `Dados` ≠ `maquina`.
9. **Feche** em 3 linhas: o que mudou, o próximo passo mais urgente, quando é a próxima revisão.

## Formato da nota

Use `Templates/Resumo semanal.md` (preencha os campos `{{date:...}}` com o período revisado, não com hoje). Se o template não existir, este é o formato:

```markdown
---
tipo: resumo-semanal
periodo: YYYY-Www
inicio: YYYY-MM-DD
fim: YYYY-MM-DD
origem: assistente
tags: []
---
# YYYY-Www

## Temas da semana
- 

## Por projeto
### [[Projeto A]]
- avançou: 
- próximo passo: 

## Decisões
- 

## Aprendizados
- 

## Travou
- 

## Fora do resumo
- 

## Diários
- [[YYYY-MM-DD]] · [[YYYY-MM-DD]] · ...
```

## O que esta skill não faz
- Não pula etapas para ganhar tempo. Se o usuário tem 5 minutos, faça só o passo 2 e diga que a revisão ficou incompleta.
- Não arquiva, descarta ou reescreve sem confirmação.
- Não escreve o resumo com opinião própria sobre a semana. Padrões e travas vêm do que está registrado ou do que o usuário disse.
