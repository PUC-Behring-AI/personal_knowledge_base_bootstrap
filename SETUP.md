# SETUP.md — Primeira interação com o usuário

Este arquivo é lido pelo assistente quando `_sistema/perfil.md` não existe (ver `AGENTS.md`, seção 0). Ele descreve a **primeira sessão**: sair de uma cópia recém-baixada da base para uma base funcional, versionada localmente, com o usuário entendendo o que aconteceu.

**Ponto de partida.** A sessão começa com a base já na máquina: uma cópia feita a partir do template (*Use this template*), baixada com `git clone` ou como ZIP, e o opencode aberto nessa pasta. O setup **não** configura repositório remoto, chave SSH nem autenticação no GitHub: os commits ficam locais. Ligar a base a um repositório privado é um passo posterior, feito com o assistente quando o usuário pedir.

Conduza como uma conversa, não como um formulário. Faça poucas perguntas por vez. Ao terminar, `_sistema/perfil.md` existe e este arquivo não é mais lido no início da sessão.

---

## Checklist do setup

**Antes de qualquer outra coisa**, mostre ao usuário a lista abaixo, com uma frase dizendo que o setup leva uns 15 minutos e que ele pode interromper e retomar. Depois de **cada passo concluído**, mostre a lista de novo com o novo check e uma linha dizendo o que foi feito.

```
Setup da base · 0 de 8
[ ] 1. Reconhecer o sistema
[ ] 2. Conhecer você
[ ] 3. Instalar o que falta
[ ] 4. Preparar o repositório local
[ ] 5. Criar a estrutura da base
[ ] 6. Obsidian
[ ] 7. Primeiro commit
[ ] 8. Primeira nota
```

Regras:
- `[x]` passo concluído; `[ ]` pendente; `[!]` falhou ou foi pulado, sempre com o motivo na mesma linha (ex.: `[!] 6. Obsidian — usuário prefere outro editor`). Não esconda falha.
- **O check vem do estado da máquina, não da memória da conversa.** Cada passo tem uma *verificação*; marque `[x]` só quando ela passa. Se a sessão for interrompida, rode as verificações de novo e retome do primeiro passo que não passa.
- Um passo por vez. Não comece o seguinte enquanto o atual depende de uma resposta do usuário.
- **Nunca fique em silêncio.** Antes de um comando que pode demorar (instalação, download, clone), diga em uma linha o que vai rodar e quanto costuma levar (ex.: "Instalando o git, 1–3 min"). Se uma janela pode abrir na tela do usuário (instalador, UAC, Obsidian), avise antes.

---

## 1. Reconhecer o sistema

Silencioso: não pergunte o que dá para descobrir. Levante:
- sistema operacional e shell (macOS, Linux, Windows nativo com PowerShell, WSL);
- se há privilégio de administrador (no Windows: `([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)`);
- o que já está instalado: `git`, `winget`/`brew`/`apt`, `python`, `uv`, `ollama`, Obsidian;
- a pasta atual: é a base? (`AGENTS.md` e `kb_agent/` presentes); tem `.git`?; o link `.claude/skills` resolve (`ls .claude/skills/*/SKILL.md`)?

Reporte em até 5 linhas. **Se o opencode não foi aberto dentro da pasta da base**, pergunte onde ela está, trabalhe nela com caminhos absolutos e lembre no passo 8 de reabrir o opencode lá.

*Verificação:* você sabe SO, admin sim/não e onde está a base.

## 2. Conhecer você

Pergunte, em linguagem natural, e adapte o resto às respostas:

- **Idioma** da conversa e das notas. Pergunte primeiro e use-o daqui em diante.
- **Nome e e-mail** para os commits. Ficam gravados em cada commit e aparecem se a base for publicada um dia; sugira o e-mail *noreply* do GitHub (*Settings → Emails*) para quem tem conta.
- **Máquina própria ou compartilhada** (laboratório, computador da família). Em máquina compartilhada, as notas ficam no disco para quem usar a mesma conta depois, e podem sumir se a máquina for formatada; diga isso agora, sem alarme, e registre no perfil.
- **Propósito principal** da base (pesquisa acadêmica, trabalho, estudo, vida pessoal, mistura). A base começa com um propósito, mas deve ficar flexível.
- **Familiaridade** com git, Obsidian, gerenciadores de pacotes, Zotero, modelos locais, MCP/skills. Uma escala simples basta: *nunca ouvi falar / já usei / uso com frequência*. É opcional: se o usuário não quiser responder, siga.
- **Privacidade**. São duas perguntas independentes; faça as duas:
  - *Onde roda a inferência?* `local` (Ollama/LM Studio), `nuvem-privada` (servidor próprio ou institucional) ou `terceiros` (Claude, GPT, OpenCode Zen...). Você já está rodando com algum modelo: confirme qual é e se é isso que o usuário quer.
  - *Onde ficam os dados?* `maquina` (só aqui), `repo-privado` (backup num GitHub privado, configurado depois do setup) ou `servico` (tudo no provedor).
  - Se a inferência é em terceiros, diga explicitamente: cada chamada envia ao provedor as notas que você lê. Dados locais não são dados privados. Para dados de terceiros ou sensíveis, recomende inferência local ou uma pasta excluída da sua leitura (registrada em `perfil.md` e `.gitignore`).
  - Local não significa offline. Em qualquer modo você pode buscar e baixar conteúdo público. A restrição é sobre o que *sai* da base, não sobre o que *entra*.

Se o usuário pular uma pergunta, use um padrão razoável e diga qual; não marque o campo como "(preencher)" sem avisar.

*Verificação:* idioma, nome, e-mail, máquina, propósito e as duas respostas de privacidade definidos.

## 3. Instalar o que falta

**Sem privilégio de administrador por padrão.** Suponha que o usuário não tem admin (laboratório, máquina corporativa) a menos que o passo 1 mostre o contrário. Instale tudo no escopo do usuário. Se um instalador pedir elevação (UAC no Windows, `sudo` no Linux) e for cancelado, **não tente de novo**: proponha a alternativa sem admin ou deixe o componente para depois, marcando `[!]`.

Para cada componente: diga em uma frase para que serve, mostre o comando e peça permissão. Uma permissão do usuário para "instalar o que precisar" vale para os itens desta tabela, não para outros.

| Componente | Verificação | Quando | Instalação sem admin |
|---|---|---|---|
| git | `git --version` | Sempre | Windows: `winget install --id Git.Git -e --scope user`. macOS: `xcode-select --install` ou Homebrew |
| Obsidian | app instalado | Recomendar; o usuário pode preferir outro editor | Windows: `winget install --id Obsidian.Obsidian -e --scope user`. macOS: `brew install --cask obsidian` |
| Zotero + Better BibTeX | app instalado | Se o propósito envolve pesquisa/literatura; pode ficar para depois | instalador de [zotero.org](https://www.zotero.org/download/) |
| Python + uv | `python --version`; `uv --version` | Adiar até uma skill precisar | uv: instalador oficial no escopo do usuário |
| Ollama | `ollama --version` | Se `Inferência: local` ou o usuário quiser experimentar | instalador nativo, não pede admin |

Não instale Node.js para a base: ela não precisa dele.

*Verificação:* `git --version` responde num shell novo; os demais componentes aceitos respondem ou estão marcados `[!]` com motivo.

## 4. Preparar o repositório local

1. **Repositório git.** Se não existe `.git` (base baixada como ZIP): `git init -b main`.
2. **Identidade, só nesta base** (não use `--global`, para não afetar outros projetos nem o próximo usuário de uma máquina compartilhada):
   ```
   git config user.name "<nome>"
   git config user.email "<email>"
   ```
3. **Remotos.** Se `origin` aponta para o repositório original (`PUC-Behring-AI/personal_knowledge_base_bootstrap`), renomeie para `upstream` (`git remote rename origin upstream`): deixa claro que ali não é onde as notas do usuário vão, e prepara o recebimento de atualizações. Não crie remoto novo.
4. **Skills da base.** O repositório traz `.claude/skills` como link simbólico para `kb_agent/skills`. Em macOS, Linux e WSL ele já funciona. No Windows o git costuma materializá-lo como um arquivo de texto; nesse caso, crie uma *junction*, que não exige admin nem Modo de Desenvolvedor, e esconda a diferença do git só nesta máquina:
   ```powershell
   Remove-Item -Force .claude\skills
   New-Item -ItemType Junction -Path .claude\skills -Target (Resolve-Path kb_agent\skills)
   git update-index --skip-worktree .claude/skills      # só se .git já existia
   Add-Content .git\info\exclude ".claude/skills/"
   ```
   A junction acompanha `kb_agent/skills`: skills novas ou editadas aparecem sem recopiar. Se nem a junction funcionar, use a cópia descrita em `kb_agent/SKILLS.md`. Registre em `perfil.md` qual foi usada (`link | junction | cópia`).

*Verificação:* `git config user.email` responde; `ls .claude/skills/*/SKILL.md` lista as skills; `git status --short` não mostra nada sobre `.claude/skills`.

## 5. Criar a estrutura da base

A estrutura inicial está em **`kb_agent/seeds/`**, uma árvore-espelho da raiz com o conteúdo inicial de cada arquivo (READMEs das pastas PARA, `_sistema/*`, `index.md`, `03 Resources/Algum dia.md`, a nota-raiz de `01 Projects/Logs diários/` e `.obsidian/templates.json`, que aponta a pasta de templates do Obsidian para `Templates/`). Não crie a estrutura à mão: rode o script, que só cria o que falta e **nunca sobrescreve nem apaga**.

```bash
# macOS, Linux, WSL, Git Bash
bash kb_agent/scripts/bootstrap-structure.sh --dry-run
bash kb_agent/scripts/bootstrap-structure.sh
```

```powershell
# Windows nativo
powershell -ExecutionPolicy Bypass -File kb_agent\scripts\bootstrap-structure.ps1 -DryRun
powershell -ExecutionPolicy Bypass -File kb_agent\scripts\bootstrap-structure.ps1
```

Mostre o resumo do dry-run (quantos `criaria`, quantos `pulado`) e **espere o usuário confirmar** antes de rodar de verdade. Depois:

- `criado` é o esperado numa cópia nova; `pulado` significa que o arquivo já existia e foi preservado. Não "corrija" arquivos pulados.
- **Preencha `_sistema/perfil.md`** com as respostas do passo 2 e o que foi instalado no passo 3. É o único arquivo gerado que você edita no setup.
- `Templates/` e `.gitignore` já vêm do repositório. Acrescente ao `.gitignore` o que o usuário indicar como sensível.
- Se o usuário quiser mudar a estrutura padrão da *sua* base, ele edita `kb_agent/seeds/` (o script continua idempotente). Não invente pastas fora disso sem combinar.

*Verificação:* `_sistema/perfil.md`, `index.md`, `Objetivos.md` e `01 Projects/Logs diários/Logs diários.md` existem; o perfil não tem campo vazio sem explicação.

## 6. Obsidian

Se o usuário recusou o Obsidian no passo 3, marque `[!]` e siga.

**Abrir a base como vault.** O jeito mais simples é o usuário fazer: *Abrir pasta como cofre* → escolher a pasta da base. Se ele preferir que você faça, no Windows:
1. feche o Obsidian (`Get-Process Obsidian | Stop-Process`), avisando antes;
2. leia `%APPDATA%\obsidian\obsidian.json` se existir e **acrescente** uma entrada em `vaults` (id: 16 caracteres hex aleatórios; `path`: caminho absoluto da base; `ts`: agora em ms; `open: true`), sem apagar os cofres que já estão lá;
3. grave em **UTF-8 sem BOM** (`[IO.File]::WriteAllText($p, $json, [Text.UTF8Encoding]::new($false))`; `Set-Content -Encoding UTF8` do PowerShell 5 grava BOM e o Obsidian pode não ler);
4. abra o Obsidian de novo.

Passar o caminho da pasta como argumento do executável **não** registra o cofre.

Confira com o usuário: *Settings → Core plugins → Templates → Template folder location* = `Templates`.

**Skills do Obsidian** ([kepano/obsidian-skills](https://github.com/kepano/obsidian-skills), MIT): seis skills mantidas pelo criador do Obsidian que ensinam o assistente a escrever Markdown no dialeto do Obsidian (wikilinks, embeds, callouts, propriedades), a montar Bases e Canvas, a extrair Markdown limpo de páginas web (`defuddle`) e a gerar notas a partir de dados (`knap`). Explique em duas frases e **pergunte onde instalar**:

- **Local** (nesta base; versionado com ela; recomendado em macOS/Linux se o usuário tem ou terá mais de um assistente ou máquina):
  ```bash
  git submodule add https://github.com/kepano/obsidian-skills kb_agent/vendor/obsidian-skills
  for d in kb_agent/vendor/obsidian-skills/skills/*/; do n=$(basename "$d"); ln -s "../vendor/obsidian-skills/skills/$n" "kb_agent/skills/$n"; done
  ```
  Atualizar depois: `git submodule update --remote kb_agent/vendor/obsidian-skills`. Num clone novo: `git submodule update --init`.
- **Global** (para todas as bases e projetos desta conta; não entra no repositório; **recomendado no Windows**, onde os links da opção local não são versionáveis):
  ```bash
  git clone https://github.com/kepano/obsidian-skills ~/.claude/obsidian-skills
  mkdir -p ~/.claude/skills
  for d in ~/.claude/obsidian-skills/skills/*/; do n=$(basename "$d"); ln -s "$d" ~/.claude/skills/"$n"; done
  ```
  ```powershell
  # Windows nativo
  git clone https://github.com/kepano/obsidian-skills "$HOME\.claude\obsidian-skills"
  New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
  Get-ChildItem "$HOME\.claude\obsidian-skills\skills" -Directory | ForEach-Object {
    New-Item -ItemType Junction -Path "$HOME\.claude\skills\$($_.Name)" -Target $_.FullName }
  ```
  `~/.claude/skills/` é lido pelo Claude Code e pelo opencode. Atualizar depois: `git -C ~/.claude/obsidian-skills pull`.

Registre a escolha em `perfil.md` e a instalação em `log.md` (`install | obsidian-skills (local|global)`). Se o usuário recusar, registre `não` e siga; a base funciona sem elas.

*Verificação:* o cofre aparece aberto no Obsidian (pergunte ao usuário); `obsidian-markdown` aparece em `.claude/skills/` ou `~/.claude/skills/`, ou a recusa está registrada.

## 7. Primeiro commit

1. Mostre o que vai entrar (`git status --short`) e confirme que nada de `.claude/skills` aparece.
2. `git add -A && git commit -m "Setup inicial da base de conhecimento"`.
3. Não há push: a base é local. Diga em uma frase que, quando o usuário quiser backup num GitHub privado, basta pedir ao assistente.

*Verificação:* `git log --oneline -1` mostra o commit; `git status --short` vazio.

## 8. Primeira nota

A base não deve terminar o setup vazia. Peça ao usuário **uma** coisa para entrar agora: um paper que ele está lendo, um dataset, a ata de uma reunião, uma ideia que está na cabeça dele. Se ele não tiver nada à mão, sugira uma nota com o propósito da base e a primeira pergunta que ele quer que ela responda.

Faça a operação **Ingerir** (`AGENTS.md`, seção 5) com ele, em voz alta: mostre a nota criada, o frontmatter com `origem`, a entrada no `index.md` e a linha no `log.md`. Esse é o modelo de tudo que vem depois. Faça um commit com a nota.

Se o usuário está seguindo a aula, o primeiro ingest é o survey da turma e o notebook de análise: crie a nota-resumo, guarde o notebook junto, e ao reportar correlações lembre que com amostra pequena elas aparecem por acaso. Pergunte quais ele esperaria antes de ver os dados.

*Verificação:* a nota existe, está no `index.md`, há linha `ingest` no `log.md` e o commit foi feito.

---

## Encerramento

Mostre o checklist final. Só marque o nível 0 como concluído em `progresso.md` se os passos 4, 5, 7 e 8 estão `[x]`; senão, registre o que ficou pendente. Registre no `log.md` e explique em poucas linhas:
- o que foi criado e instalado;
- que o próximo passo é a **captura** (nível 1): tudo entra em `00 Inbox/` sem preocupação com organização. Um hábito por vez: na primeira semana, só capturar;
- que, se o opencode não estava aberto dentro da pasta da base, ele deve fechá-lo e abrir de novo **lá dentro**; só assim as próximas sessões leem o `AGENTS.md`;
- em máquina compartilhada: onde as notas estão no disco, que elas ficam para o próximo usuário da conta e podem sumir se a máquina for formatada, e que o backup num GitHub privado resolve isso quando ele quiser.

A partir da próxima sessão, `AGENTS.md` conduz sozinho: healthcheck, trilha, skills.

---

## Notas para o Windows nativo

Aprendidas em setups reais; valem para todo comando que você rodar no PowerShell.

- **PATH não se atualiza no seu shell** depois de instalar algo. Recarregue antes de usar o programa novo:
  `$env:Path = [Environment]::GetEnvironmentVariable('Path','User') + ';' + [Environment]::GetEnvironmentVariable('Path','Machine')`.
- **winget**: sempre com `--scope user --accept-source-agreements --accept-package-agreements --disable-interactivity`. Sem os dois `--accept`, até `winget list` trava esperando resposta. Código de saída `1602` ou "cancelado pelo usuário" = UAC recusado; não repita.
- **git escreve progresso em stderr**, e o PowerShell mostra como erro em vermelho. Decida pelo `$LASTEXITCODE`, não pela cor.
- **Acentos no console** (`Logs di�rios`): rode `[Console]::OutputEncoding = [Text.Encoding]::UTF8` no início. Os arquivos estão certos; é só a exibição.
- **Não há `wc`, `grep`, `ls -la`** no PowerShell puro: use `Measure-Object`, `Select-String`, `Get-ChildItem -Force`.
- **Links simbólicos** exigem admin ou Modo de Desenvolvedor; **junctions** (`New-Item -ItemType Junction`) não, e servem para pastas. Prefira junction a pedir elevação.
