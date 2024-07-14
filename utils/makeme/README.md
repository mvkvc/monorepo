---
name: makeme
desc: Generates the list of projects you are currently reading.
tech: Rust
---

# makeme

Generates the project list for monorepo `README.md`.

Looks for the following fields in frontmatter:

```yaml
---
name: string
desc: string
tech: string (optional)
link: string (optional)
show: boolean (default true)
---
```
