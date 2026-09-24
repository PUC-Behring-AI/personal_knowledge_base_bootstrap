# Personal Knowledge Base — Bootstrap

> "Remember kids, the only difference between screwing around and science is writing it down." — *MythBusters*

Este repositório é o ponto de partida para você construir a **sua** base de conhecimento pessoal (PKB): um conjunto de notas em Markdown, versionado com git, organizado por métodos consolidados (**GTD** e **PARA**) e mantido com a ajuda de um assistente de IA ([opencode](https://opencode.ai)).

A ideia não é entregar um sistema pronto, e sim um **esqueleto que cresce com você**. Você faz um fork, abre o assistente, e ele te guia: instala as ferramentas, monta a estrutura e, aos poucos, apresenta cada método quando fizer sentido para você.

---

## Por que ter uma base de conhecimento pessoal?

- **Registrar é o que transforma tentativa em ciência.** Um registro vira dado verificável, e dado verificável pode ser revisado, repetido e compartilhado.
- **É um processo, não um caderno.** Uma base só funciona se tiver um sistema: capturar, classificar, revisar.
- **É uma ferramenta.** Começa com um propósito (sua pesquisa, seu trabalho), mas é flexível o bastante para servir a vários.
- **É pessoal.** Ela reflete como *você* pensa. Os métodos aqui são sugestões, não regras.
- **Ideias acima de ferramentas.** Obsidian, Zotero e opencode são só instâncias de conceitos (capturar, analisar, registrar, referenciar, manter). Se uma ferramenta sair de cena, os conceitos e as suas notas em Markdown continuam.

### Por que digital (e não um caderno)?

- Busca, links entre ideias e histórico de versões.
- Texto puro (Markdown) é portável: não fica preso a nenhum aplicativo.
- Um assistente de IA pode assumir o **trabalho de manutenção** (indexar, linkar, resumir, arrumar), que é justamente o que faz a maioria das pessoas desistir de manter uma base.

---

## Como funciona

```
Você ──► captura ideias, papers, reuniões ──► 00 Inbox/
                                                 │
Assistente (opencode) ◄── lê AGENTS.md ──────────┤
   │                                             ▼
   ├── classifica (PARA) ──► 01 Projects / 02 Areas / 03 Resources / 04 Archive
   ├── mantém índices, links e log
   ├── conduz revisões (GTD)
   └── orquestra skills (ex.: as etapas de uma revisão sistemática PRISMA)
```

- **`README.md`** (este arquivo): para você, humano.
- **`AGENTS.md`**: instruções para o assistente. O opencode lê esse arquivo automaticamente sempre que é aberto nesta pasta. `CLAUDE.md` só importa o `AGENTS.md`, para quem prefere usar o Claude Code: os dois assistentes seguem as mesmas instruções e as mesmas skills.
- **`SETUP.md`**: o roteiro da primeira sessão. O assistente o lê quando percebe que a base ainda não foi configurada e o segue do início ao fim; depois disso, não é mais usado.
- **`kb_agent/`**: as skills (habilidades específicas que o assistente executa, como processar o inbox ou conduzir a revisão semanal) e o catálogo delas em `kb_agent/SKILLS.md`. Os assistentes as encontram por `.claude/skills/`, que é só um link para lá.
- **`_sistema/`**: criada durante o setup; guarda o seu perfil, o seu progresso na trilha e o log de operações. É aqui que a base fica "sua".

---

## Pré-requisitos

Você precisa de três coisas para começar: uma conta no GitHub, o opencode e um modelo para ele usar. O resto (git, Obsidian, Zotero, chave SSH) o assistente instala com você na primeira sessão.

### 1. Conta no GitHub

[github.com/signup](https://github.com/signup).

### 2. opencode

O opencode roda nativamente em macOS, Linux **e Windows**: não é preciso WSL. Isso importa porque, rodando nativo, o assistente consegue instalar e configurar os outros programas (Obsidian, Zotero, git) na sua máquina, e não numa máquina virtual à parte.

**macOS / Linux**

```bash
curl -fsSL https://opencode.ai/install | bash
```

**Windows** (PowerShell). Instale o Node.js LTS pelo instalador em [nodejs.org](https://nodejs.org) (ou `winget install OpenJS.NodeJS.LTS`), feche e reabra o PowerShell, e então:

```powershell
npm install -g opencode-ai
```

Alternativas no Windows: `scoop install opencode` ou `choco install opencode`, se você já usa um deles. Se preferir o [WSL](https://learn.microsoft.com/windows/wsl/install), siga as instruções de Linux; funciona, mas o assistente fica confinado ao Linux virtual.

Confira com `opencode --version`.

### 3. Um modelo

O opencode é só a interface; o "cérebro" é um modelo de linguagem, e você escolhe onde ele roda. Isso é a primeira decisão de privacidade da sua base (ver [Privacidade](#privacidade-quão-local-você-quer-ser)), e dá para ter os dois configurados e alternar com `/models`.

**Opção A: modelo local com Ollama** (`Inferência: local`). Nada sai da sua máquina; grátis; mais lento e menos capaz que os modelos de nuvem.

1. Instale o Ollama: [ollama.com/download](https://ollama.com/download) (Windows: `OllamaSetup.exe`, sem precisar de administrador; ou `winget install Ollama.Ollama`). Ele fica rodando em segundo plano, com ícone na bandeja.
2. Baixe um modelo que saiba usar ferramentas (*tool calling*), que é o que um agente precisa. Escolha pelo tamanho da sua memória: ~8 GB de RAM para modelos de 7–8B parâmetros, 16 GB ou mais para 14B+. Por exemplo:
   ```bash
   ollama pull qwen3:8b
   ```
3. Diga ao opencode que o Ollama existe. Crie `opencode.json` na pasta da sua base (ou em `~/.config/opencode/opencode.json`, para valer em toda a máquina):
   ```json
   {
     "$schema": "https://opencode.ai/config.json",
     "provider": {
       "ollama": {
         "npm": "@ai-sdk/openai-compatible",
         "name": "Ollama (local)",
         "options": { "baseURL": "http://localhost:11434/v1" },
         "models": {
           "qwen3:8b": { "name": "Qwen3 8B (local)" }
         }
       }
     }
   }
   ```
   Troque `qwen3:8b` pelo modelo que baixou. Abra o opencode, `/models`, escolha o modelo.

**Opção B: OpenCode Zen** (`Inferência: terceiros`). Modelos de nuvem (Claude, GPT, Gemini e outros) testados pela equipe do opencode, com cobrança por uso e alguns modelos gratuitos. Mais capaz e mais rápido; cada chamada envia ao provedor as notas que o modelo lê.

1. Abra o opencode e digite `/connect`.
2. Escolha **OpenCode Zen**; ele te manda para [opencode.ai/auth](https://opencode.ai/auth) para entrar, cadastrar cobrança e copiar a chave.
3. Cole a chave no opencode. `/models` mostra os modelos disponíveis.

Qualquer outro provedor (chave própria da Anthropic, OpenAI, Google etc.) também funciona pelo `/connect`.

Com os três prontos, siga para o [Início rápido](#início-rápido).

---

## Início rápido

### 1. Crie a sua cópia do repositório

Há duas formas. Escolha conforme a privacidade que você quer:

| Opção | Como | Quando usar |
|---|---|---|
| **Fork** | Botão *Fork* no GitHub | Você quer receber atualizações deste repositório com facilidade. **Atenção:** fork de repositório público é sempre público. |
| **Template / cópia privada** | Botão *Use this template* (ou crie um repositório privado e faça push de um clone) | Suas notas são pessoais ou sensíveis. **Recomendado para a maioria das pessoas.** |

### 2. Clone para o seu computador

```bash
git clone <URL-DA-SUA-COPIA> minha-kb
cd minha-kb
```

### 3. Abra o assistente

```bash
opencode
```

E diga algo como: **"Olá, quero começar a minha base de conhecimento."**

O assistente vai perceber que é a primeira vez (não existe `_sistema/perfil.md`) e vai conduzir o **setup inicial**:

1. Uma conversa curta para entender você: sistema operacional, familiaridade com as ferramentas, para que você quer a base e quanta privacidade precisa.
2. Verificação e instalação dos componentes, **sempre mostrando o comando e pedindo sua permissão antes**.
3. Criação da estrutura de pastas e dos arquivos de sistema.
4. Primeiro commit e configuração do GitHub (incluindo chave SSH, se necessário).
5. **Primeiro ingest**: o assistente pede algo para entrar na base agora (um paper, um dataset, uma reunião, uma ideia) e faz a primeira nota com você. A base não fica vazia nem por cinco minutos.

---

## O que o assistente pode instalar

Nada é instalado sem a sua confirmação. Os itens marcados como opcionais dependem do seu perfil.

| Componente | Para quê | Obrigatório? |
|---|---|---|
| **git** | Versionar as notas ("revisão rima com versão") | Sim |
| **Chave SSH + GitHub** | Sincronizar e fazer backup da base | Recomendado |
| **Obsidian** | Ler, escrever e navegar pelas notas (links, grafo, busca) | Recomendado |
| **Zotero** + Better BibTeX | Gerenciar referências bibliográficas | Recomendado para pesquisa |
| **GitHub CLI (`gh`)** | Facilitar autenticação e operações no GitHub | Opcional |
| **Python + uv** | Rodar scripts das skills (ex.: diagrama PRISMA) | Quando uma skill precisar |
| **Ollama** | Rodar modelos localmente (privacidade, custo zero por token). Se você escolheu modelo local, já instalou nos pré-requisitos; senão o assistente oferece como segunda opção | Opcional |
| **Skills do Obsidian** ([kepano/obsidian-skills](https://github.com/kepano/obsidian-skills)) | Ensinar o assistente o Markdown do Obsidian, Bases, Canvas e extração de páginas web. Você escolhe se ficam só nesta base (local) ou para todos os projetos da máquina (global) | Recomendado |

---

## Privacidade: quão local você quer ser?

São duas perguntas independentes, não uma:

1. **Onde roda a inferência?** Local (Ollama, LM Studio), nuvem privada (servidor próprio, GPU pessoal ou institucional) ou nuvem de terceiros (Claude, GPT, etc.).
2. **Onde ficam os dados?** Só na sua máquina, num repositório privado na nuvem, ou no serviço de terceiros.

| Inferência ↓ / Dados → | Só na máquina | Repositório privado | Serviço de terceiros |
|---|---|---|---|
| **Local** | Puramente local: privado, lento, menos capaz | Local + backup versionado | — |
| **Nuvem privada** | Servidor próprio; controle dos dois lados | Nuvem privada: controle dos dois lados | — |
| **Nuvem de terceiros** | *Local ≠ privado: cada chamada envia as notas ao provedor* | Local + nuvem pessoal: inferência conforme a tarefa | Yolo: nunca com dados sensíveis |

- **Puramente local**: nada sai da sua máquina. Mais lento e menos capaz, mas totalmente privado.
- **Nuvem privada**: a inferência roda num servidor seu ou da sua instituição (um cluster de pesquisa, por exemplo). Você controla os dois lados.
- **Local + nuvem pessoal**: notas na sua máquina com backup em repositório **privado**; inferência local ou em nuvem conforme a tarefa. Atenção ao ponto que passa despercebido: com inferência em nuvem de terceiros, o provedor recebe as notas que o modelo lê. Dados locais não são o mesmo que dados privados.
- **Yolo**: tudo na nuvem de terceiros, os agentes fazem a inferência *e* os dados ficam salvos lá. Máxima capacidade, mínimo atrito. Não use para dados de terceiros ou sensíveis (participantes de pesquisa, informações confidenciais).

Você escolhe durante o setup e pode mudar depois. O assistente respeita a escolha: fora do modo de terceiros, ele não envia conteúdo das suas notas para nenhum serviço que não seja seu.

**Local não significa offline.** Em qualquer modo o assistente pode buscar e baixar conteúdo público (artigos, datasets, documentação); é assim que a revisão de literatura funciona. A restrição é sobre o que *sai* da sua base, não sobre o que *entra* nela.

---

## Estrutura da base

Depois do setup, a sua base vai ficar mais ou menos assim:

```
minha-kb/
├── README.md               # Este arquivo
├── AGENTS.md               # Instruções do assistente (motor genérico)
├── CLAUDE.md               # Importa AGENTS.md (compatibilidade com Claude Code)
├── SETUP.md                # O que o assistente faz na primeira sessão
├── kb_agent/
│   ├── SKILLS.md           # Catálogo das skills e como instalá-las
│   └── skills/             # Uma pasta por skill, com SKILL.md
├── .claude/skills → ../kb_agent/skills   # Link simbólico: onde opencode e Claude Code procuram
├── 00 Inbox/               # Captura rápida (GTD): tudo entra aqui primeiro
├── 01 Projects/            # Projetos ativos, com objetivo e prazo
│   └── Logs diários/       # Projeto que toda base tem
│       ├── Logs diários.md
│       ├── 2026/2026-09-24.md   # Um diário por dia
│       └── Resumos/             # 2026-W39.md, 2026-09.md, 2026-Q3.md
├── 02 Areas/               # Responsabilidades contínuas (ex.: saúde, ensino, finanças)
├── 03 Resources/           # Material de referência, temas de interesse
│   ├── Algum dia.md        # Lista "algum dia / talvez" do GTD
│   └── Metodologia/        # GTD, PARA e Zettelkasten em uma nota curta cada
├── 04 Archive/             # O que foi concluído ou saiu de cena
├── Templates/              # Modelos de nota (configure como pasta de templates no Obsidian)
├── _sistema/
│   ├── perfil.md           # Quem você é, preferências, privacidade
│   ├── progresso.md        # Em que ponto da trilha você está
│   └── log.md              # Registro das operações feitas na base
├── Objetivos.md            # Mapa vivo dos objetivos, um nível acima dos projetos
└── index.md                # Catálogo das notas (mantido pelo assistente)
```

**Datas sempre em `YYYY-MM-DD`**, em nomes de arquivo e dentro das notas. Com esse formato, ordem alfabética é ordem cronológica: os diários aparecem na ordem certa em qualquer lugar. Notas que *são* um período levam só o período como nome (`2026-09-24`, `2026-W39`, `2026-09`, `2026-Q3`); outras notas datadas começam pela data (`2026-09-24 - Reunião com X`).

No Obsidian, aponte a pasta de templates para `Templates/`: *Settings → Core plugins → Templates → Template folder location*. Os modelos que vêm no repositório são os que as skills usam; adicione os seus.

---

## A trilha: implantando os métodos aos poucos

Ninguém adota um sistema inteiro de uma vez. O assistente acompanha seu progresso em `_sistema/progresso.md` e só propõe o próximo passo quando o anterior já faz parte da sua rotina.

| Nível | Tema | O que você ganha |
|---|---|---|
| 0 | **Fundação** | Ferramentas instaladas, repositório versionado, estrutura criada |
| 1 | **Captura** (GTD) | Anote onde estiver (papel, celular, e-mail); depois tudo chega a um lugar único e sem atrito: `00 Inbox/` |
| 2 | **Classificação** (PARA) | Esvaziar o inbox com o fluxo do GTD (é acionável? menos de 2 min? algum dia?) e cada nota no lugar certo, com base em *acionabilidade* |
| 3 | **Revisão** (GTD) | Revisão semanal; commits regulares ("revisão rima com versão") |
| 4 | **Estrutura** | Templates, tags e skills para as suas tarefas recorrentes |
| 5 | **Rituais** | Momentos em que o assistente é chamado: eventos seus e eventos recorrentes automáticos (hooks) — *em definição* |
| 6 | **Serendipidade e escala** | Links entre conceitos, perguntas à base, fluxos acadêmicos (PRISMA), ontologias |

### GTD em uma frase
*Getting Things Done*: tire tudo da cabeça (**capturar**), decida o que cada coisa é e onde vai (**classificar**), e olhe para o sistema regularmente para confiar nele (**revisar**).

### PARA em uma frase
Organize por **acionabilidade**, não por assunto: **P**rojetos (têm fim), **Á**reas (contínuas), **R**ecursos (referência), **A**rquivo (inativo). As notas circulam: projeto concluído vai para o arquivo, recurso vira insumo de um projeto.

### Zettelkasten em uma frase
Uma ideia por nota, com as próprias palavras, ligada a outras por links. Três tipos: **transitória** (captura rápida), **de leitura** (o que um texto diz, com a referência) e **permanente** (uma ideia sua na rede).

---

## Skills

Skills são instruções empacotadas que ensinam o assistente a executar uma tarefa específica. Ficam em `kb_agent/skills/<nome>/SKILL.md`, com o catálogo em `kb_agent/SKILLS.md`, e você pode criar as suas. O opencode e o Claude Code as encontram pelo link `.claude/skills/`; em macOS, Linux e WSL o clone já vem funcionando. Se o link não resolver na sua máquina, o assistente instala por cópia no setup.

| Skill | Status | O que faz |
|---|---|---|
| Revisão sistemática (PRISMA) | Em definição (rascunho) | Um conjunto de skills, **uma por etapa**. Você escreve antes: query, critérios de inclusão e exclusão, perguntas de avaliação. O assistente executa, um artigo por vez: busca e deduplicação via APIs públicas, triagem por título/abstract, triagem por texto completo, consolidação em CSV, contagens e diagrama de fluxo. Ele **para quando precisa de uma decisão sua**: aprovação do protocolo, casos duvidosos, checagem por amostra com medida de concordância. O Zotero é o destino final da lista incluída, para citar. |
| `process-inbox` | Disponível | Esvazia o inbox pelo fluxo do GTD: para cada item, o assistente propõe destino e justificativa; você decide |
| `next-action` | Disponível | "Estou travado" → uma ação só. Acha o projeto sem próximo passo e ajuda a definir um |
| `daily-log` | Disponível | Diário do dia em `01 Projects/Logs diários/YYYY/YYYY-MM-DD.md`; ao fechar o dia, capturas viram notas no inbox |
| `weekly-review` | Disponível | Revisão semanal guiada (~15 min) que termina com a nota da semana e um commit |
| `compress` | Disponível | Resumos de mês e trimestre a partir das camadas de baixo, sempre listando o que ficou de fora |
| Skills do Obsidian | Externas (instaladas no setup) | `obsidian-markdown`, `obsidian-bases`, `json-canvas`, `defuddle`, `knap`, `obsidian-cli`, de [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills). Locais ou globais, você escolhe |
| Ingestão, links, arquivo, lint | Planejadas | `ingest`, `link-suggest`, `archive`, `para-lint`. Não há skill de captura: capturar é seu, à mão, no `00 Inbox/` |

A busca de literatura usa APIs públicas (Semantic Scholar, arXiv, Crossref, OpenAlex), com queries genéricas: nenhuma nota sua precisa sair da máquina para alimentar a revisão.

---

## Cuidados

- **Vieses.** Tanto você quanto a IA introduzem vieses ao capturar, classificar e resumir. O assistente marca notas e trechos gerados por ele (campo `origem` no frontmatter) para que você saiba o que foi escrito por quem. Revise o que ele produz, especialmente resumos de papers e critérios de triagem.
- **Custo de tokens.** Uma base grande "come" muitos tokens se o assistente tiver que ler tudo. Por isso ele trabalha a partir do `index.md` e lê só o necessário. Mais adiante, ontologias e grafos ajudam a escalar.
- **Suas notas são suas.** O assistente pede confirmação antes de apagar, reescrever notas existentes ou fazer push.
- **Terceirize o pensamento, não o entendimento.** O assistente captura, classifica, resume e tria; entender continua sendo seu. Ele facilita iterar, não substitui ler.

---

## Recebendo atualizações deste repositório

Se você fez fork (ou quer puxar melhorias do repositório original):

```bash
git remote add upstream https://github.com/PUC-Behring-AI/personal_knowledge_base_bootstrap.git
git fetch upstream
git merge upstream/main
```

Para evitar conflitos, **não edite o `AGENTS.md` para personalizar o assistente**. Coloque suas preferências em `_sistema/perfil.md`, que o assistente lê em toda sessão e que nunca vem do repositório original.

---

## Roadmap

- [x] README e instruções do assistente (`AGENTS.md`)
- [ ] Skills do PRISMA (uma por etapa, orquestradas pelo assistente)
- [x] Skills de manutenção: `process-inbox`, `next-action`, `daily-log`, `weekly-review`, `compress`
- [ ] Skills de manutenção restantes: `ingest`, `link-suggest`, `archive`, `para-lint`
- [x] Templates iniciais: diário, resumos (semana, mês, trimestre), projeto, paper
- [ ] Templates restantes: reunião, pessoa
- [x] Script de estrutura (`kb_agent/scripts/bootstrap-structure`), idempotente, nunca apaga
- [ ] Definição dos rituais e hooks (eventos do usuário e eventos recorrentes)
- [ ] Skills específicas do Obsidian (links e tags)
- [ ] Integração com Zotero
