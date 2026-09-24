# Skills do assistente

Fonte única das skills desta base. Cada skill é uma pasta em `kb_agent/skills/<nome>/` com um `SKILL.md` (frontmatter `name` e `description`, depois as instruções). O nome da pasta é o nome da skill: minúsculas, números e hífens.

## Instalação

Os assistentes procuram skills em caminhos próprios; o Claude Code e o opencode leem `.claude/skills/`. O repositório já traz o link simbólico `.claude/skills → ../kb_agent/skills`, então em macOS, Linux e WSL não há nada a fazer.

Verificação (o assistente faz no setup e no healthcheck):

```bash
ls .claude/skills/*/SKILL.md
```

Se o comando falha (Windows sem WSL, ou clone que não preservou o link), instalar por cópia:

```bash
rm -rf .claude/skills && cp -r kb_agent/skills .claude/skills
```

Nesse caso, depois de editar ou puxar skills novas, repita a cópia. Para outros assistentes, aponte o caminho de skills deles para `kb_agent/skills/` ou repita o link (`ln -s ../kb_agent/skills <caminho>`).

## Catálogo

| Skill | Nível da trilha | Gatilho | Produz |
|---|---|---|---|
| `process-inbox` | 2 | "processa o inbox", inbox cheio ou antigo | Inbox vazio; notas movidas para o PARA com `tipo` e links |
| `next-action` | 2–3 | "o que eu faço agora", "estou travado" | Uma ação; campo `Próximo passo` do projeto atualizado |
| `daily-log` | 3 | "log de hoje", "registra que...", "fecha o dia" | `01 Projects/Logs diários/YYYY/YYYY-MM-DD.md`; capturas do dia no inbox |
| `weekly-review` | 3 | "revisão semanal", semana encerrada sem nota | `01 Projects/Logs diários/Resumos/YYYY-Www.md`; commit da semana |
| `compress` | 4+ | "comprime", "resumo do mês", períodos sem nota | `01 Projects/Logs diários/Resumos/YYYY-MM.md`, `YYYY-Qn.md` e semanas faltantes |

O nível indica quando o assistente pode **oferecer** a skill. O usuário pode pedir qualquer uma a qualquer momento.

## Skills externas: Obsidian

Fonte: [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) (MIT, mantido pelo criador do Obsidian). Instaladas no setup (`SETUP.md`, passo 2), **local** (submódulo em `kb_agent/vendor/obsidian-skills`, com um link por skill em `kb_agent/skills/`) ou **global** (`~/.claude/obsidian-skills`, links em `~/.claude/skills/`). A escolha está em `_sistema/perfil.md`.

| Skill | Nível da trilha | Para quê |
|---|---|---|
| `obsidian-markdown` | 1 | Escrever no dialeto do Obsidian: wikilinks, embeds, callouts, propriedades. Use sempre que criar ou editar uma nota |
| `defuddle` | 2 | Extrair Markdown limpo de uma página web ao ingerir um link que está no inbox (menos tokens, menos lixo) |
| `obsidian-bases` | 4 | Criar arquivos `.base` (tabelas e visões sobre as notas, com filtros e fórmulas), por exemplo um painel dos projetos com próximo passo |
| `json-canvas` | 4 | Criar e editar `.canvas` (diagramas de nós e arestas) |
| `knap` | 4 | Gerar notas em lote a partir de JSON/CSV com um template, por exemplo uma nota por artigo de uma revisão |
| `obsidian-cli` | 6 | Operar o vault pela CLI do Obsidian; desenvolvimento de plugins |

Não edite essas skills dentro de `vendor/` ou de `~/.claude/obsidian-skills`: elas são atualizadas do repositório original (`git submodule update --remote` ou `git pull`). Se precisar de um comportamento diferente, escreva uma skill própria que referencie a externa.

## Previstas

`ingest` (usando `defuddle` para páginas web), `link-suggest`, `archive`, `para-lint`, e as etapas do PRISMA (ver rascunho em `AGENTS.md`, seção 6). Não há skill de captura: capturar é manual, do usuário.

## Convenções para escrever uma skill

As skills seguem a especificação aberta **Agent Skills** ([agentskills.io/specification](https://agentskills.io/specification)), que é o que o Claude Code, o opencode e outros agentes leem. Resumo do que importa:

- Estrutura: `<nome>/SKILL.md` obrigatório; `scripts/` (código executável), `references/` (documentação longa, carregada só quando necessário) e `assets/` (recursos estáticos) opcionais.
- Frontmatter: `name` (1–64 caracteres, `a-z0-9` e hífens, igual ao nome da pasta) e `description` (até 1024 caracteres) obrigatórios; `license`, `compatibility` (ex.: `Requires Python 3.12+ and uv`), `metadata` e `allowed-tools` opcionais.
- Só `name` e `description` ficam sempre no contexto do assistente; o corpo é carregado quando a skill ativa, e `references/` só sob demanda. Corpo abaixo de 500 linhas; o que for longo vai para `references/`.
- Validação: `skills-ref validate kb_agent/skills/<nome>` (biblioteca de referência da spec).

Além da spec, nesta base:

- `description` diz **quando** usar (gatilhos, em linguagem do usuário), não só o que faz. É o que o assistente lê para decidir carregar.
- Passos numerados, com as **paradas para decisão do usuário** explícitas.
- Formato da nota que produz, e qual template de `Templates/` usa (com fallback embutido).
- A linha que registra em `_sistema/log.md`.
- Seção **"O que esta skill não faz"**: é o que impede o assistente de ajudar demais.
- Skills próprias do usuário vão na mesma pasta; adicione uma linha no catálogo.
