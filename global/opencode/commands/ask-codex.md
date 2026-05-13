---
description: Consulta Codex en sandbox read-only
agent: plan
---

Consulta a Codex con el prompt de `$ARGUMENTS` usando sandbox de solo lectura.

Antes de ejecutar, muestra el comando exacto y pide confirmacion explicita.

Comando base:

```bash
codex exec --sandbox read-only --ask-for-approval on-request "$ARGUMENTS"
```

Reglas:

1. No uses `--dangerously-bypass-approvals-and-sandbox`, `--sandbox danger-full-access` ni flags equivalentes.
2. No uses `--add-dir` salvo que el usuario lo pida explicitamente e indique el directorio.
3. No copies secretos, tokens, credenciales ni ficheros sensibles al prompt.
4. Si el prompt implica editar, borrar, commitear, pushear o ejecutar acciones externas, no lo delegues: explica que este comando es para consulta segura.
5. Resume la respuesta de Codex y separa claramente cualquier recomendacion de cualquier accion ejecutada.
