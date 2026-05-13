---
description: Consulta Claude Code en modo plan seguro
agent: plan
---

Consulta a Claude Code con el prompt de `$ARGUMENTS` usando un modo conservador.

Antes de ejecutar, muestra el comando exacto y pide confirmacion explicita.

Comando base:

```bash
claude -p --permission-mode plan "$ARGUMENTS"
```

Reglas:

1. No uses `--dangerously-skip-permissions`, `--allow-dangerously-skip-permissions`, `--permission-mode bypassPermissions` ni flags equivalentes.
2. No uses `--add-dir` salvo que el usuario lo pida explicitamente e indique el directorio.
3. No copies secretos, tokens, credenciales ni ficheros sensibles al prompt.
4. Si el prompt implica editar, borrar, commitear, pushear o ejecutar acciones externas, no lo delegues: explica que este comando es para consulta segura.
5. Resume la respuesta de Claude y separa claramente cualquier recomendacion de cualquier accion ejecutada.
