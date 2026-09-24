---
name: compress
description: Compressão progressiva do diário em camadas: gera notas de semana (YYYY-Www) faltantes a partir dos diários, notas de mês (YYYY-MM) a partir das semanas e de trimestre (YYYY-Qn) a partir dos meses, em 01 Projects/Logs diários/Resumos/. Use para "comprime", "resumo do mês", "fecha o trimestre" ou quando o healthcheck detectar períodos encerrados sem nota.
---

# compress

Os diários são raw e imutáveis. Cada camada acima é uma nota que resume a camada de baixo e linka para ela. Tamanho-alvo: semana ≈ 25% dos diários, mês ≈ 10%, trimestre ≈ 5%.

## Convenção
- Antes de escrever, confira a estrutura de `01 Projects/Logs diários/` contra a seção "Logs diários" do `AGENTS.md`. Resumos dentro da pasta do ano ou diários com nome fora do padrão são corrigidos (com confirmação) antes da compressão.
- Tudo em `01 Projects/Logs diários/Resumos/`. Nomes: `YYYY-Www.md`, `YYYY-MM.md`, `YYYY-Qn.md`. O nome é o período, nada mais.
- Frontmatter: `tipo: resumo-semanal | resumo-mensal | resumo-trimestral`, `periodo`, `inicio`, `fim`, `origem: assistente`, `fontes: [lista de notas usadas]`.
- Uma camada só é gerada a partir da camada imediatamente abaixo. Mês a partir de semanas, não de diários. Se faltam semanas, gere-as primeiro.
- Nunca reescreva uma nota de período existente sem confirmação; ofereça `atualizar` (acrescenta) ou `regerar` (substitui, e a anterior fica no git).

## Passos

1. **Descubra o que falta.** Liste períodos encerrados sem nota:
   - Semanas ISO com ao menos um diário e sem `YYYY-Www.md`.
   - Meses encerrados com ao menos uma semana e sem `YYYY-MM.md`.
   - Trimestres encerrados com ao menos um mês e sem `YYYY-Qn.md`.
   Mostre a lista e pergunte quais gerar. Se o usuário pediu um período específico, restrinja a ele.
2. **Semanas faltantes**: gere com o formato de `weekly-review` (mesma nota, mesmas seções), mas **sem** as etapas interativas (inbox, projetos, links). Marque no frontmatter `gerada-por: compress` para distinguir de uma revisão de verdade.
3. **Mês**: leia as notas de semana do mês. Escreva no formato abaixo. Padrões só quando aparecem em ≥2 semanas; cite quais.
4. **Trimestre**: leia as notas de mês. Formato abaixo, mais curto. Aqui vale olhar `01 Projects/` e `04 Archive/`: o que começou, o que terminou, o que ficou parado o trimestre inteiro.
5. **Fora do resumo** em toda camada: liste o que foi lido e não entrou. É a única defesa contra a perda por compressão ser invisível.
6. **Insights que merecem nota própria**: se um tema aparece em vários períodos e não tem nota permanente, proponha criar uma (`tipo: permanente`) em `03 Resources/` ou na área correspondente. Só com confirmação.
7. **Atualize** `index.md` e `_sistema/log.md`: `## [YYYY-MM-DD] skill | compress: gerados YYYY-Www, YYYY-MM, ...`.
8. Ofereça commit: `git add "01 Projects/Logs diários/Resumos" && git commit -m "Compressão: <períodos>"`.

## Formato: mês

Use `Templates/Resumo mensal.md` (e `Templates/Resumo trimestral.md` para o trimestre), preenchendo os campos `{{date:...}}` com o período comprimido. Se os templates não existirem, este é o formato:

```markdown
---
tipo: resumo-mensal
periodo: YYYY-MM
inicio: YYYY-MM-DD
fim: YYYY-MM-DD
origem: assistente
tags: []
fontes: [YYYY-Www, YYYY-Www, ...]
---
# YYYY-MM

## Visão geral
(3 a 5 frases)

## Por projeto / área
### [[Projeto A]]
- 

## Padrões
- (tema; semanas em que apareceu)

## Decisões que valem lembrar
- 

## Insights candidatos a nota própria
- 

## Fora do resumo
- 

## Semanas
- [[YYYY-Www]] · [[YYYY-Www]] · ...
```

## Formato: trimestre

Mesmas seções do mês, com **Visão geral** de até 3 frases, seção adicional **Começou / terminou / parou** (projetos), e a lista final apontando para os meses.

## O que esta skill não faz
- Não altera diários nem semanas existentes.
- Não gera período ainda em curso (semana atual, mês atual). Para a semana atual, é `weekly-review`.
- Não inventa padrões: cada padrão cita os períodos em que aparece.
- Não substitui a leitura: se o usuário quer saber o que aconteceu num dia, aponte o diário, não o resumo.
