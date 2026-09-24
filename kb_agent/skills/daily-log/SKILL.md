---
name: daily-log
description: Cria ou atualiza a nota de diário do dia (01 Projects/Logs diários/YYYY/YYYY-MM-DD.md) e, no fim do dia, extrai itens acionáveis para o inbox. Use para "log de hoje", "diário", "registra que...", "fecha o dia", ou ao iniciar sessão quando o usuário mantém diário.
---

# daily-log

Uma nota por dia, com o que aconteceu, o que foi capturado e qual é o próximo passo. É a fonte das camadas de compressão (semana, mês, trimestre).

## Convenção
- **Antes de qualquer escrita, confira a estrutura** de `01 Projects/Logs diários/` contra a seção "Logs diários" do `AGENTS.md`: nota-raiz `Logs diários.md`, pasta do ano igual ao ano da data, nome do arquivo só a data, `Resumos/` separada. Se algo diverge (diário na pasta errada, nome com sufixo, sem `data:`), proponha a correção e só então crie a nota de hoje. Nunca crie uma segunda estrutura ao lado.
- Caminho: `01 Projects/Logs diários/YYYY/YYYY-MM-DD.md`. O nome do arquivo é só a data, para ordenar cronologicamente no explorador de arquivos e no Obsidian.
- Uma nota por dia. Se já existe, acrescente; nunca sobrescreva.
- Frontmatter: `tipo: diario`, `data: YYYY-MM-DD`, `origem: usuario+assistente`.
- As notas de diário são **imutáveis depois do dia**. Correções vão na nota do dia seguinte ou no resumo semanal.

## Modos

### Abrir o dia (`daily-log`, "log de hoje")
1. Se a nota de hoje não existe, crie a partir de `Templates/Diario.md` se houver; senão use o formato abaixo.
2. Preencha **Foco de hoje** com o próximo passo do projeto prioritário (leia `01 Projects/` como em `next-action`; se preferir, invoque `next-action`). Uma linha.
3. Mostre a nota e pare. O usuário escreve o resto durante o dia, ou dita para você.

### Registrar ("registra que...", "anota no diário")
1. Acrescente uma linha em **Registro** com hora (`HH:MM`) e o texto do usuário, com as palavras dele.
2. Se o texto contém algo acionável (um "preciso", "tenho que", "lembrar de"), pergunte se quer capturar no inbox agora. Se sim, crie a nota em `00 Inbox/` e linke a partir do diário.

### Fechar o dia ("fecha o dia", ou última sessão do dia)
1. Leia a nota de hoje.
2. Para cada item em **Capturas** que ainda não virou nota no inbox, crie uma (`tipo: transitoria`) e substitua a linha por `[[link]]`.
3. Preencha **Próximo passo** com uma ação para amanhã (pergunte se não estiver claro; use a lógica de `next-action`).
4. Se o dia teve decisão ou aprendizado explícito, marque com `> [!decision]` ou `> [!learning]` para que `compress` os encontre.
5. Ofereça commit: `git add "01 Projects/Logs diários" "00 Inbox" && git commit -m "Diário YYYY-MM-DD"`.
6. Registre em `_sistema/log.md`: `## [YYYY-MM-DD] skill | daily-log: fechado (N capturas → inbox)`.

## Formato da nota

```markdown
---
tipo: diario
data: YYYY-MM-DD
origem: usuario+assistente
tags: []
---
# YYYY-MM-DD

## Foco de hoje
- 

## Registro
- HH:MM — 

## Capturas
- 

## Próximo passo
- 
```

## O que esta skill não faz
- Não resume o dia por conta própria; o registro é do usuário. Você organiza e extrai ações.
- Não edita notas de dias anteriores.
- Não cria a nota de hoje se o usuário só perguntou algo sobre a base; só quando pedir ou quando o perfil diz que ele mantém diário.
