---
name: process-inbox
description: Processa o inbox da base de conhecimento (GTD esclarecer → organizar), item por item, propondo destino PARA com justificativa e movendo só com confirmação. Use quando o usuário pedir para processar, esvaziar ou organizar o inbox, ou quando o healthcheck encontrar inbox cheio ou antigo.
---

# process-inbox

Transforma `00 Inbox/` em zero itens, um de cada vez, sem decidir pelo usuário.

## Pré-condições
- `_sistema/perfil.md` existe (setup feito).
- Há ao menos um item em `00 Inbox/`. Se não houver, diga "Inbox vazio" e pare.

## Passos

1. **Liste** os itens do inbox em ordem cronológica (mais antigo primeiro), numerados, com título e data de captura. Diga quantos são.
2. **Para cada item**, leia a nota e responda em três linhas:
   - **O que é**: uma frase.
   - **É acionável?** Não → descartar, `03 Resources/` (nota de leitura ou referência) ou linha em `03 Resources/Algum dia.md`. Sim → mais de um passo é projeto (`01 Projects/`, novo ou existente); um passo curto (<2 min) sugira fazer agora; senão vai como próxima ação de um projeto ou área.
   - **Proposta**: destino exato (pasta e, se for o caso, nota-alvo) e o `tipo` que a nota vai receber (`leitura` ou `permanente`; ela deixa de ser `transitoria`).
3. **Espere a decisão** do usuário. Aceite respostas em lote ("tudo ok menos o 3", "3 vai para o projeto X"). Se ele pedir, discuta o item; não passe ao próximo sem decisão.
4. **Execute** o que foi aprovado, item a item:
   - Mover a nota (ou acrescentar a linha na nota-alvo, quando é uma próxima ação).
   - Atualizar `tipo` e `origem` no frontmatter; se reescrever o conteúdo com as próprias palavras, marcar `origem: usuario+assistente`.
   - Adicionar `[[links]]` para notas relacionadas que você conhece pelo `index.md`. Não invente relações: só linke o que você leu.
   - Atualizar `index.md`.
5. **Descartar** só com confirmação explícita daquele item. Descartar = `git rm`; o histórico preserva.
6. **Relate** em até 5 linhas: quantos processados, para onde foram, o que ficou pendente.
7. **Registre** em `_sistema/log.md`: `## [YYYY-MM-DD] skill | process-inbox: N itens (P projetos, R recursos, D descartados)`.
8. Se o usuário está no nível 1 da trilha e este é o primeiro processamento, marque o nível 2 como iniciado em `_sistema/progresso.md`.

## O que esta skill não faz
- Não move nada sem confirmação.
- Não cria projeto novo sem próximo passo definido. Se o item é um projeto, pergunte "qual é o primeiro passo concreto?" antes de criar a nota.
- Não elabora o conteúdo da nota além do necessário para classificar. Elaborar é trabalho de outra sessão.
- Não processa itens capturados hoje se o usuário preferir deixá-los "assentar"; pergunte uma vez, respeite a resposta.

## Formato da nota de projeto (quando criar uma)

Use `Templates/Projeto.md` (preenchendo `{{date}}` e `{{title}}`). Se o template não existir, este é o formato:

```markdown
---
tipo: permanente
origem: usuario+assistente
tags: []
data: YYYY-MM-DD
status: ativo
---
# Título do projeto

**Objetivo**: 
**Resultado esperado**: 
**Prazo**: 
**Próximo passo**: 

## Notas relacionadas
- 
```
