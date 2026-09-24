---
origem: assistente
tipo: leitura
tags: [prisma, revisao-sistematica, skill]
data: 2026-09-24
---
# Diagrama de fluxo PRISMA 2020: ferramentas, objeto de dados e formato de saída

Pesquisa feita em 2026-09-24 para a skill de consolidação do PRISMA (AGENTS.md, seção 6, passo 6). Decisão proposta ao final; nada foi implementado ainda.

## O problema

O diagrama precisa (a) nascer dos números levantados pelas skills, sem digitação manual, (b) entrar em Word, PowerPoint e Google Slides e (c) continuar editável lá dentro, para o autor ajustar texto e caixas sem voltar ao gerador.

## Ferramentas existentes

| Ferramenta | O que é | Saída | Editável no Office/Google? | Veredito |
|---|---|---|---|---|
| [PRISMA2020](https://github.com/prisma-flowdiagram/PRISMA2020) (R, Haddaway et al. 2022; [Shiny](https://estech.shinyapps.io/prisma_flowdiagram/)) | Referência da área; cobre os 4 templates oficiais (nova/atualizada, com/sem outras fontes) e meta-análise; entrada por CSV | HTML interativo, PDF, PNG, SVG, PS, WEBP (via DiagrammeR/Graphviz) | SVG entra em Word/PowerPoint com "Converter em forma"; não entra no Google Slides | Boa referência de **vocabulário e layout**; depende de R e Graphviz, e não gera PPTX |
| [prisma-flow](https://pypi.org/project/prisma-flow/) (Python, OSL, v0.6.1 de 2026-06) | Gerador puro-Python a partir de JSON/YAML, com validação aritmética das contagens | SVG, PNG, HTML, Mermaid, JSON | Idem SVG | Mais próximo do nosso stack, mas **só cobre revisão nova sem "outras fontes"**; sem PPTX |
| Templates oficiais em Word ([prisma-statement.org](https://www.prisma-statement.org/prisma-2020-flow-diagram), CC BY 4.0) | 4 arquivos `.docx` com caixas desenhadas em DrawingML (`rect`, `straightConnector1`, caixas de texto) | `.docx` | Sim, no Word; PowerPoint aceita colar; Google Slides não importa `.docx` | Preencher via XML é possível, mas os textos vêm fragmentados em runs ("W", "ebsites (", "n =") e há duplicação por fallback VML; remover caixas cinzas ou adicionar linhas de bases exige mexer no layout. Frágil |
| Graphviz / Mermaid / draw.io | Motores de layout genéricos | SVG/PNG (draw.io também XML próprio) | Idem SVG | Layout automático **atrapalha**: o PRISMA tem posições fixas; e nenhum gera PPTX |
| Geradores web (SciFig, ConceptViz, prismaflowdiagramgenerator) | SaaS | alguns prometem "PPTX editável" | Sim | Envolvem mandar os dados para terceiros e não são scriptáveis; fora do modelo da base |
| Aspose.Words / Aspose.Slides | Bibliotecas comerciais | DOCX/PPTX nativos | Sim | Pagas; desnecessárias |

## Como cada destino importa diagramas editáveis

- **PowerPoint**: abre `.pptx` nativamente. Também insere SVG e converte em formas (Microsoft 365).
- **Google Slides**: importa `.pptx` **preservando formas, conectores e texto**. **Não** aceita SVG (erro no upload). Caminho oficial da comunidade: SVG → PowerPoint → converter em forma → salvar `.pptx` → subir.
- **Word**: insere SVG e converte em formas (Microsoft 365, 2016+). Colar formas do PowerPoint mantém tudo editável (mesmo DrawingML). `python-docx` não desenha formas; seria XML à mão.
- **Google Docs**: só Google Drawings é editável. Nem SVG nem `.pptx` entram editáveis. Alternativa: inserir o slide do Google Slides como imagem vinculada (atualiza, mas não edita no Docs).

Conclusão: **PPTX com formas nativas é o único formato que entra editável nos três destinos pedidos** (PowerPoint direto, Google Slides por importação, Word por colar do PowerPoint ou pelo SVG). SVG é o segundo formato, para Word/LaTeX/Obsidian/Markdown e para publicação.

## Decisão proposta

1. **Objeto de dados único**: `prisma-flow.schema.json` (neste diretório), exemplo em `exemplo-prisma-flow.json`. As skills de busca, triagem e consolidação escrevem nele; o gerador só lê. Vocabulário do PRISMA 2020 e do CSV do pacote R, para que o mesmo objeto sirva de entrada ao PRISMA2020 R ou ao `prisma-flow` se um dia quisermos.
2. **Gerador próprio em Python com `python-pptx`**, layout determinístico (grade fixa dos templates oficiais, sem motor de layout), cobrindo os 4 variantes + meta-análise. Uma forma por caixa, um conector por seta, texto como texto. Saídas na mesma execução:
   - `.pptx` (slide único, A4 paisagem ou 16:9): PowerPoint, Google Slides, e origem para colar no Word;
   - `.svg` do mesmo layout (mesmas coordenadas, texto em `<text>`): Word "Converter em forma", Obsidian, LaTeX, submissão;
   - `.png` opcional via `resvg`/`cairosvg` para pré-visualização na nota.
   - Rodar com `uv run --with python-pptx`, sem instalar nada no sistema (compatível com README, "Python + uv").
3. **Validação antes de desenhar**: mesmas checagens aritméticas do PRISMA2020/prisma-flow (identificados − removidos = triados; triados − excluídos = buscados; buscados − não obtidos = avaliados; avaliados − excluídos = incluídos; soma dos motivos = excluídos). Erro para inconsistência; aviso quando o objeto não fecha por design (estudo com vários relatos).
4. **Caixas cinzas** (as "só se aplicável" do template oficial) somem quando o campo está ausente ou zero, como o template manda.

## O que fica de fora do objeto e por quê

- Motivos de exclusão da fase 1 (título/resumo): o PRISMA não os exibe no diagrama; ficam no CSV por artigo (`audit.per_record_csv`).
- Query, filtros e datas por base: entram no objeto (`identification.databases[].query`) mas não no diagrama; alimentam a seção de métodos.
- Concordância humano–agente (`audit.sample_check`): também não vai ao diagrama; vai à nota de métodos e ao log.

## Próximos passos

1. Protótipo do gerador (`kb_agent/skills/prisma-flow-diagram/scripts/`) a partir do exemplo, e teste real: abrir o `.pptx` no PowerPoint, importar no Google Slides, colar no Word.
2. Definir os rótulos em pt-BR e en (o PRISMA tem tradução oficial? conferir antes de traduzir).
3. Escrever a `SKILL.md` de consolidação que produz o objeto e chama o gerador; registrar no catálogo `kb_agent/SKILLS.md`.

## Fontes

- Page MJ et al. (2021). The PRISMA 2020 statement. BMJ 372:n71. [Templates do diagrama](https://www.prisma-statement.org/prisma-2020-flow-diagram).
- Haddaway NR, Page MJ, Pritchard CC, McGuinness LA (2022). PRISMA2020: An R package and Shiny app. *Campbell Systematic Reviews* 18:e1230. [doi:10.1002/cl2.1230](https://onlinelibrary.wiley.com/doi/full/10.1002/cl2.1230). [Repositório](https://github.com/prisma-flowdiagram/PRISMA2020); [PRISMA_save](https://prisma-flowdiagram.github.io/PRISMA2020/reference/PRISMA_save.html).
- [prisma-flow no PyPI](https://pypi.org/project/prisma-flow/) (osl-incubator).
- Microsoft: [Edit SVG images in Microsoft 365](https://support.microsoft.com/en-us/office/graphics-visuals/edit-svg-images-in-microsoft-365).
- Google Slides e SVG: [Plus AI](https://plusai.com/blog/guide-how-to-import-an-svg-into-google-slides/), [Learning in Hand](https://learninginhand.com/blog/2025/1/12/svg).
- Google Docs: [How-To Geek](https://www.howtogeek.com/442036/how-to-add-flowcharts-and-diagrams-to-google-docs-or-slides/).
- python-docx sem formas: [issue #1269](https://github.com/python-openxml/python-docx/issues/1269).
