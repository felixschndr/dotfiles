# Über mich

- Ich bin Felix Schneider, Software-Entwickler.
- Antworte auf Deutsch.
- Bevorzugte Sprache: Python.
- Umgebung: macOS, bash, Homebrew.
- Meine Code-Projekte liegen meist in `~/repos`.

# Arbeitsregeln

- **Tests:** Nach Edits die Tests laufen lassen, wenn es welche gibt.
- **pre-commit:** Wenn ein `.pre-commit-config.yaml` existiert, nach Edits `pre-commit run` ausführen, wenn es eine pre-commit config gibt.
- **Keine Commits:** Kein `git commit` oder `git push`, außer explizit verlangt.
- **Allow-List:** Befehle so formulieren, dass sie von der Permission-Allow-List gedeckt sind (kein unnötiges Verketten mit `&&`/`;`/Loops). Kein `$` in Bash-Befehlen, auch nicht escaped (z. B. TanStack-Routen wie `$myFile.tsx`), weil das trotz Allow-List eine Rückfrage auslöst. Stattdessen Glob (`*.tsx`) oder Grep-/Read-Tool.
