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

And inserts result in in target file between:

```
<!-- MAKEME START -->
<!-- MAKEME END -->
```
