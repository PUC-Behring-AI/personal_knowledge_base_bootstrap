---
tipo: permanente
origem: assistente
tags: [logs-diarios]
data: {{DATE}}
status: ativo
---
# Logs diários

**Objetivo**: registrar o dia (foco, o que aconteceu, capturas, próximo passo) e alimentar as revisões.
**Resultado esperado**: um diário por dia em `YYYY/YYYY-MM-DD.md`; resumos de semana, mês e trimestre em `Resumos/`.
**Prazo**: contínuo.
**Próximo passo**: escrever o primeiro diário (skill `daily-log`).

## Estrutura

```
Logs diários/
├── Logs diários.md        # esta nota
├── YYYY/YYYY-MM-DD.md     # um diário por dia; o nome é só a data
└── Resumos/
    ├── YYYY-Www.md        # semana ISO
    ├── YYYY-MM.md         # mês
    └── YYYY-Qn.md         # trimestre
```

Diários são imutáveis depois do dia; correções vão no dia seguinte ou no resumo da semana.

## Notas relacionadas
- 
