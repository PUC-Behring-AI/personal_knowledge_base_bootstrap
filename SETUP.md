# SETUP.md — Primeira interação com o usuário

Este arquivo é lido pelo assistente quando `_sistema/perfil.md` não existe (ver `AGENTS.md`, seção 0). Ele descreve a **primeira sessão**: sair de um clone vazio para uma base funcional, versionada, com o usuário entendendo o que aconteceu.

Conduza como uma conversa, não como um formulário. Faça poucas perguntas por vez. Ao terminar, `_sistema/perfil.md` existe e este arquivo não é mais lido no início da sessão.

---

## 1. Conheça o usuário

Pergunte, em linguagem natural, e vá adaptando o resto do setup às respostas:

- Idioma preferido para a conversa e para as notas.
- Sistema operacional (macOS, Linux, Windows nativo ou Windows com WSL). No Windows nativo, o gerenciador de pacotes é o `winget` (vem com o sistema) e os comandos são PowerShell; você pode instalar Obsidian, git e Zotero por ele. No WSL, você está num Linux: programas gráficos como o Obsidian precisam ser instalados no Windows, pelo usuário.
- Familiaridade com: git/GitHub, Obsidian, gerenciadores de pacotes, Zotero, modelos locais (Ollama/LM Studio), Jupyter, interfaces de chat de IA, MCP/skills, workflows agênticos. Uma escala simples basta: *nunca ouvi falar / já usei uma vez / uso com frequência*.
- **Propósito principal** da base (pesquisa acadêmica, trabalho, estudo, vida pessoal, mistura). A base começa com um propósito, mas deve ficar flexível.
- **Privacidade**. São duas perguntas independentes; faça as duas e registre as duas no perfil:
  - *Onde roda a inferência?* `local` (Ollama/LM Studio), `nuvem-privada` (servidor próprio ou institucional, GPU pessoal) ou `terceiros` (Claude, GPT...).
  - *Onde ficam os dados?* `maquina` (só aqui), `repo-privado` (backup no GitHub privado) ou `servico` (tudo no provedor).
  - Combinações com nome: `local` = inferência local + dados na máquina; `nuvem-privada` = inferência no servidor do usuário, controle dos dois lados; `local+nuvem-pessoal` = dados na máquina com backup em repo privado, inferência à escolha; `yolo` = inferência em terceiros e dados salvos lá.
  - Se a inferência é em terceiros, diga explicitamente: cada chamada envia ao provedor as notas que você lê. Dados locais não são dados privados. Se o usuário quiser guardar dados de terceiros ou sensíveis, recomende inferência local ou uma pasta excluída da sua leitura (registre em `perfil.md` e `.gitignore`).
  - Local não significa offline. Em qualquer modo você pode buscar e baixar conteúdo público (literatura, datasets, documentação). A restrição é sobre o que *sai* da base, não sobre o que *entra*.

## 2. Verifique e instale os componentes

Para cada componente: verifique se já existe (`which`, `--version`), explique em uma frase para que serve, **mostre o comando exato e peça permissão antes de executar**. Nunca instale nada sem confirmação explícita. Adapte o gerenciador de pacotes ao sistema (Homebrew, apt, dnf, winget, etc.).

| Componente | Verificação | Quando propor |
|---|---|---|
| git | `git --version` | Sempre |
| Identidade git (`user.name`, `user.email`) | `git config --get user.name` | Sempre |
| Chave SSH + GitHub | `ls ~/.ssh/*.pub`; `ssh -T git@github.com` | Se `Dados` ≠ `maquina` |
| GitHub CLI (`gh`) | `gh --version` | Opcional; facilita autenticação |
| Obsidian | app instalado (varia por SO) | Recomendar; o usuário pode preferir outro editor |
| Zotero + Better BibTeX | app instalado | Se propósito envolve pesquisa/literatura |
| Python + uv | `python3 --version`; `uv --version` | Adiar até uma skill precisar |
| Ollama | `ollama --version`; `ollama list` | Se `Inferência: local` ou o usuário quiser experimentar. Windows: instalador nativo, sem WSL |
| Provedor de modelo no opencode | `opencode.json` na base ou em `~/.config/opencode/`; ou `/connect` já feito | Você já está rodando, então um existe. Se é só um: ofereça o outro (Ollama local para privacidade, OpenCode Zen para capacidade), conforme o README, seção "Um modelo". Registre em `perfil.md` qual é o padrão |

Se o usuário não sabe o que é chave SSH: explique em duas frases (é a sua "identidade" para o GitHub; evita digitar senha) e conduza passo a passo (`ssh-keygen -t ed25519`, copiar a chave pública, colar no GitHub).

**Skills da base**: verifique que `ls .claude/skills/*/SKILL.md` lista as skills. Se não (o link simbólico `.claude/skills → ../kb_agent/skills` não foi preservado no clone), instale por cópia como descrito em `kb_agent/SKILLS.md`, e registre em `perfil.md` que a instalação é por cópia, para repetir depois de cada `git pull`.

**Skills do Obsidian** ([kepano/obsidian-skills](https://github.com/kepano/obsidian-skills), MIT): seis skills mantidas pelo criador do Obsidian que ensinam o assistente a escrever Markdown no dialeto do Obsidian (wikilinks, embeds, callouts, propriedades), a montar Bases e Canvas, a extrair Markdown limpo de páginas web (`defuddle`) e a gerar notas a partir de dados (`knap`). Explique isso em duas frases e **pergunte onde instalar**:

- **Local** (nesta base; versionado com ela; recomendado se o usuário tem ou terá mais de um assistente ou máquina):
  ```bash
  git submodule add https://github.com/kepano/obsidian-skills kb_agent/vendor/obsidian-skills
  for d in kb_agent/vendor/obsidian-skills/skills/*/; do n=$(basename "$d"); ln -s "../vendor/obsidian-skills/skills/$n" "kb_agent/skills/$n"; done
  ```
  Atualizar depois: `git submodule update --remote kb_agent/vendor/obsidian-skills`. Num clone novo: `git submodule update --init`.
- **Global** (para todas as bases e projetos desta máquina; não entra no repositório):
  ```bash
  git clone https://github.com/kepano/obsidian-skills ~/.claude/obsidian-skills
  mkdir -p ~/.claude/skills
  for d in ~/.claude/obsidian-skills/skills/*/; do n=$(basename "$d"); ln -s "$d" ~/.claude/skills/"$n"; done
  ```
  `~/.claude/skills/` é lido pelo Claude Code e pelo opencode. Atualizar depois: `git -C ~/.claude/obsidian-skills pull`.

Se a instalação das skills da base é por cópia (link não funciona nesta máquina), copie em vez de linkar. Confirme com `ls .claude/skills/` (local) ou `ls ~/.claude/skills/` (global) que `obsidian-markdown` aparece. Registre a escolha em `perfil.md` e a instalação em `log.md` (`install | obsidian-skills (local|global)`). Se o usuário recusar, registre `não` e siga; a base funciona sem elas.

## 3. Crie a estrutura

A estrutura inicial está em **`kb_agent/seeds/`**, uma árvore-espelho da raiz com o conteúdo inicial de cada arquivo (READMEs das pastas PARA, `_sistema/*`, `index.md`, `03 Resources/Algum dia.md`, a nota-raiz de `01 Projects/Logs diários/` e `.obsidian/templates.json`, que aponta a pasta de templates do Obsidian para `Templates/`). Não crie a estrutura à mão: rode o script, que só cria o que falta e **nunca sobrescreve nem apaga**.

```bash
# macOS, Linux, WSL, Git Bash
bash kb_agent/scripts/bootstrap-structure.sh --dry-run   # mostra o que faria
bash kb_agent/scripts/bootstrap-structure.sh
```

```powershell
# Windows nativo
powershell -ExecutionPolicy Bypass -File kb_agent\scripts\bootstrap-structure.ps1 -DryRun
powershell -ExecutionPolicy Bypass -File kb_agent\scripts\bootstrap-structure.ps1
```

Mostre o dry-run ao usuário antes de rodar. Depois:

- Leia o relatório: `criado` é o esperado num clone novo; `pulado` significa que o arquivo já existia (base que já estava em uso, ou setup repetido) e foi preservado. Não "corrija" arquivos pulados.
- **Preencha `_sistema/perfil.md`** com as respostas do passo 1 (o script cria o formulário vazio). É o único arquivo gerado que você edita no setup.
- Se o Obsidian já estava aberto nesta pasta, `.obsidian/templates.json` pode ter sido pulado; nesse caso, peça ao usuário para conferir *Settings → Core plugins → Templates → Template folder location* = `Templates`.
- `Templates/` e `.gitignore` já vêm do repositório. Acrescente ao `.gitignore` qualquer coisa que o usuário indicar como sensível.
- Se o usuário quiser mudar a estrutura padrão da *sua* base, ele edita `kb_agent/seeds/` (e o script continua idempotente). Não invente pastas fora disso sem combinar.

## 4. Primeiro commit

1. `git add -A && git commit -m "Setup inicial da base de conhecimento"`.
2. Se `Dados` ≠ `maquina` e o usuário tem remoto configurado: ofereça `git push`. Peça confirmação.
3. Se o usuário fez **fork público** e `Dados: repo-privado`: avise que forks de repositório público são públicos e ofereça a alternativa (repositório privado novo + `git remote set-url origin ...`).

## 5. Primeiro ingest

A base não deve terminar o setup vazia. Peça ao usuário **uma** coisa para entrar agora: um paper que ele está lendo, um dataset, a ata de uma reunião, uma ideia que está na cabeça dele. Se ele não tiver nada à mão, sugira uma nota com o propósito da base e a primeira pergunta que ele quer que ela responda.

Faça a operação **Ingerir** (`AGENTS.md`, seção 5) com ele, em voz alta: mostre a nota criada, o frontmatter com `origem`, a entrada no `index.md` e a linha no `log.md`. Esse é o modelo de tudo que vem depois.

Se o usuário está seguindo a aula, o primeiro ingest é o survey da turma e o notebook de análise: crie a nota-resumo, guarde o notebook junto, e ao reportar correlações lembre que com amostra pequena elas aparecem por acaso. Pergunte quais ele esperaria antes de ver os dados.

## 6. Encerramento do setup

Marque o nível 0 como concluído em `progresso.md`, registre no `log.md` e explique em poucas linhas:
- o que foi criado;
- que o próximo passo é a **captura** (nível 1): tudo entra em `00 Inbox/` sem preocupação com organização. Um hábito por vez: na primeira semana, só capturar;
- que ele pode abrir a pasta como vault no Obsidian.

A partir da próxima sessão, `AGENTS.md` conduz sozinho: healthcheck, trilha, skills.
