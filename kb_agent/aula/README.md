# Material da aula: PKB com agentes

Material para o **primeiro ingest** da base (`SETUP.md`, passo 8). Não é uma nota da base: fica aqui, fora das pastas PARA, para que cada aluno faça a própria nota a partir dele.

| Arquivo | O que é |
|---|---|
| `2026-09-24-survey.csv` | Respostas da turma ao questionário de 2026-09-24 (25 respostas, separador `;`). Anonimizado: sem e-mail, nome, horários, gênero e faixa etária. |
| `2026-09-24-analise-survey.ipynb` | Análise inicial: hipóteses, familiaridade por ferramenta, quem consegue rodar modelo local, coerência das respostas e um exercício sobre correlações espúrias em amostras pequenas (cor favorita × familiaridade). |

Rodar, a partir desta pasta:

```
uv run --with jupyterlab --with pandas --with matplotlib jupyter lab
```

O notebook salva as figuras em `figuras/`. A última seção explica como transformar a análise numa nota da base.
