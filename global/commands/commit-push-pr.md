---
description: Commit, push y abre PR con el cambio actual
---

Sigue los pasos en orden:

1. `git status` — ver qué ha cambiado
2. `git diff` — revisar cambios
3. Si hay una rama separada: confirmar. Si no y el cambio lo merece, crear rama `git checkout -b <descriptiva>`
4. Stagea los ficheros apropiados con `git add` (evita secrets y binarios grandes)
5. Crea commit con mensaje claro en formato conventional commits
6. Push a remoto (crea branch remoto si hace falta con `-u origin <branch>`)
7. Crea PR con `gh pr create`:
   - Título claro resumiendo el cambio
   - Descripción con: Summary de qué cambió y por qué, testing hecho, notas para reviewers

Si hay problemas en cualquier paso, paras y reportas. No fuerces.
