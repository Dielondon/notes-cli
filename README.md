# notes-cli

Una app de notas por línea de comandos, en TypeScript. Node corre el TypeScript directo, sin build.
Es uno de los repos del taller "Software factories with Claude Code".

## Preparar (antes del taller)

Necesitas Node 24 o más nuevo (`node --version`).

```zsh
gh repo fork sgomezahumada/notes-cli --clone && cd notes-cli
npm ci
node src/cli.ts add "mi primera nota" && node src/cli.ts list
./doctor.sh          # hasta que diga "doctor: all green"
```

## En el taller

```zsh
./factory.sh 1       # el ticket #1 entra, sale un PR (o un PR [REJECTED])
```

Este repo trae un gate: `gates/no-new-deps.sh` detiene código que importa un paquete que no está en
`package.json`, aunque esté en `node_modules`. El ticket #3 está pensado para chocar con él.

Lo que tú cambias: `AGENTS.md` (el contexto), `gates/` (tus revisiones), `prompts/` (las fases).
Haz commit en `main` antes de cada corrida. Nada se mergea: los PRs son para comparar.

## Tus gates

Lee [`gates/README.md`](gates/README.md): las reglas y cuatro ejemplos para copiar y adaptar.
