---
name: memoria-audit
description: Auditoria read-only del sistema de memoria nativa de TODOS los proyectos: inventario en vivo, links rotos, indices grandes, candidatos a condensar y duplicados. Nunca borra ni edita sin OK.
argument-hint: (sin argumentos)
disable-model-invocation: true
---

Audita el sistema de memoria nativa de Claude Code (`~/.claude/projects/*/memory/`) en TODOS los proyectos. Es **read-only**: solo inventaria, detecta problemas y PROPONE acciones. Nunca borres ni edites una memoria sin mi confirmacion explicita.

Responde en espanol, conciso. No narres deliberacion interna; ve directo al reporte.

## Algoritmo de resolucion de wiki-links (CLAVE; evita falsos positivos)

Un `[[target]]` apunta a otra memoria DEL MISMO proyecto. Para decidir si resuelve, NORMALIZA target y cada nombre de fichero asi, **en este orden**:

1. minusculas y quita la extension `.md`;
2. **unifica separadores: convierte `-` en `_` PRIMERO** (antes de tocar el prefijo);
3. quita el prefijo de tipo si lo hay (`feedback_`, `project_`, `reference_`, `user_`).

Hay match si las formas normalizadas coinciden. El orden importa: si quitas el prefijo antes de unificar separadores, `[[project-foo]]` no casa con `project_foo.md` (falso positivo). Un `[[target]]` que apunta a una memoria que vive en OTRO proyecto NO resuelve (la memoria nativa esta aislada por proyecto): es roto real; arreglalo sustituyendolo por texto plano con referencia explicita al proyecto donde vive.

## Que chequear (por proyecto)

- **Indice <-> ficheros:** cada entrada de `MEMORY.md` apunta a un fichero existente; lista ficheros `.md` (que no sean `MEMORY.md`) sin entrada en el indice (huerfanos).
- **Frontmatter:** cada memoria tiene `name`, `description` y `metadata.type` (uno de `user|feedback|project|reference`). Marca frontmatter ausente o plano (p.ej. `type:` fuera de `metadata:`) o `name` con espacios (deberia ser kebab-slug).
- **Tamanos:** `MEMORY.md > 3 KB` aviso (salvo que sea solo indice con muchas memorias: ~1 linea por memoria es normal; un indice grande con N aprox lineas no es bloat). Fichero individual `> 8 KB` aviso (candidato a trocear).
- **Marcadores de cierre** (`COMPLETADA`, `CERRADA`, `RESUELTO`, `HECHO`, `MERGEADA`, `RELEASED`) en el indice o el frontmatter: candidatos a condensar a <=5 lineas. Tambien `*-pendiente.md` / `*-en-curso.md` cuyo contenido ya este cerrado (nombre enganoso).
- **Wiki-links** con el algoritmo de arriba: lista solo los rotos REALES.
- **Duplicados:** agrupa ficheros por similitud de slug (prefijo comun largo o solape de tokens del nombre > ~60%) y LISTA candidatos para revision humana. NUNCA auto-fusiones.

## Bonus claude-mem

- Tamano de la BD: `ls -lh ~/.claude-mem/claude-mem.db`.
- Lee `~/.claude-mem/settings.json` (con `python3 -m json.tool`, **jq no esta instalado**) y ALERTA si `CLAUDE_MEM_CONTEXT_OBSERVATIONS` / `_FULL_COUNT` / `_SESSION_COUNT` != `20`/`3`/`5` (config optimizada de arranque; valores altos queman tokens de SessionStart).

## Como ejecutarlo

Corre este script (read-only) y construye el reporte con su salida. Si algo no cuadra, verifica a mano antes de concluir.

```python
import os, re, glob, json

BASE = os.path.expanduser("~/.claude/projects")
PREFIXES = ("feedback_", "project_", "reference_", "user_")
CLOSURE = ("COMPLETADA", "CERRADA", "RESUELTO", "HECHO", "MERGEADA", "RELEASED")

def norm(s):
    s = s.lower()
    if s.endswith(".md"): s = s[:-3]
    s = s.replace("-", "_")            # unificar separadores PRIMERO
    for p in PREFIXES:                 # luego quitar prefijo de tipo
        if s.startswith(p): return s[len(p):]
    return s

link_re = re.compile(r"\[\[([^\]]+)\]\]")
fm_re = re.compile(r"^---\n(.*?)\n---", re.S)

for memdir in sorted(glob.glob(os.path.join(BASE, "*", "memory"))):
    proj = os.path.basename(os.path.dirname(memdir))
    files = [os.path.basename(f) for f in glob.glob(os.path.join(memdir, "*.md"))
             if os.path.basename(f) not in ("MEMORY.md", "CLAUDE.md")]  # not-in evita el != (Bash escapa ! en heredocs)
    normset = {norm(f) for f in files}
    idx = os.path.join(memdir, "MEMORY.md")
    idx_txt = open(idx, encoding="utf-8", errors="replace").read() if os.path.exists(idx) else ""
    idx_size = len(idx_txt.encode())
    orphans = [f for f in files if f not in idx_txt and f[:-3] not in idx_txt]
    idx_links = re.findall(r"\]\(([^)]+\.md)\)", idx_txt)
    dead_idx = [l for l in idx_links if not os.path.exists(os.path.join(memdir, l))]
    big, bad_fm, closure, broken = [], [], [], []
    for f in files:
        p = os.path.join(memdir, f)
        t = open(p, encoding="utf-8", errors="replace").read()
        if len(t.encode()) > 8192: big.append(f)
        m = fm_re.match(t)
        fm = m.group(1) if m else ""
        # acepta type plano o bajo metadata: solo marca frontmatter genuinamente roto
        has_type = re.search(r"type:\s*(user|feedback|project|reference)\b", fm)
        if not (m and "name:" in fm and "description:" in fm and has_type):
            bad_fm.append(f)
        if any(c in t for c in CLOSURE) or "-pendiente" in f or "-en-curso" in f:
            closure.append(f)
        for ln, line in enumerate(t.splitlines(), 1):
            for tgt in link_re.findall(line):
                if norm(tgt.split("|")[0].strip()) not in normset:
                    broken.append(f"{f}:{ln} [[{tgt}]]")
    dups = []
    base = sorted(norm(f) for f in files)
    for i in range(len(base)):
        for j in range(i+1, len(base)):
            a, b = base[i].split("_"), base[j].split("_")
            common = 0
            for x, y in zip(a, b):
                if x == y: common += 1
                else: break
            if common >= 2: dups.append((base[i], base[j]))
    flag = "AVISO" if idx_size > 3072 else " "
    print(f"\n[{proj}] memorias={len(files)} MEMORY.md={idx_size}b {flag} (lineas indice~{idx_txt.count(chr(10))})")
    if dead_idx: print(f"  indice->inexistente: {dead_idx}")
    if orphans: print(f"  huerfanos (sin entrada en indice): {orphans}")
    if bad_fm:  print(f"  frontmatter dudoso: {bad_fm}")
    if big:     print(f"  fichero >8KB: {big}")
    if closure: print(f"  candidatos a condensar (cierre/pendiente): {closure}")
    if broken:  print(f"  wiki-links ROTOS: {broken}")
    if dups:    print(f"  posibles duplicados (revisar a mano): {dups}")
```

## Formato del reporte

1. **Tabla por proyecto:** memorias, tamano MEMORY.md, flags. Marca lo accionable.
2. **Hallazgos accionables** agrupados por tipo (rotos, huerfanos, condensar, frontmatter, duplicados), con el proyecto y fichero concreto.
3. **claude-mem:** tamano BD + estado de la config (OK / desviada de 20/3/5).
4. **Propuestas:** una linea por accion sugerida. **No ejecutes ninguna sin mi OK.**
