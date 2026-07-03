# Notch Apps

**Playful little apps that live under your MacBook notch.** A single, SEO-optimized
landing page that highlights two free, open-source Mac apps by
[Vignesh Ramamoorthy](https://github.com/A-VigneshRamamoorthy-Code):

| App | What it does |
|-----|--------------|
| 🐾 **[NotchPaw](https://github.com/A-VigneshRamamoorthy-Code/NotchPaw)** | A springy paw pounces from your notch to **catch your cursor** — 8 critters, real spring physics. |
| 🔒 **[NotchLock](https://github.com/A-VigneshRamamoorthy-Code/NotchLock)** | A brass pull-cord hangs from your notch — **tug it to lock your Mac**, 4 cord styles. |

Both are native Swift + AppKit / CoreGraphics, drawn entirely in code, **0% CPU when
idle**, no Dock/menu-bar icon, and completely free.

Built to match the [NotchPaw site](https://a-vigneshramamoorthy-code.github.io/NotchPaw/)
design system.

## What's inside

```
index.html      # the landing page (both apps highlighted)
styles.css      # shared design tokens + two-app additions (amber accent for NotchLock)
favicon.svg     # notch + paw brand mark
assets/         # app demos, NotchLock icon & cord styles, generated OG image
robots.txt      # allows all crawlers, points to the sitemap
sitemap.xml     # home + #notchpaw + #notchlock
.nojekyll       # serve files verbatim on GitHub Pages
```

### Highlights

- **Both apps highlighted** — a side-by-side "Meet the apps" showcase, plus a deep
  feature section for each (NotchPaw in brand purple, NotchLock in a brass/amber accent).
- **Subtle live download counts in the footer** — all-time `.dmg` downloads for *both*
  apps, fetched from the GitHub Releases API (cached 1h in `localStorage`), shown as a
  quiet line: `● NotchPaw N downloads · NotchLock N downloads`. Compact per-app badges
  also appear next to each app's download button.
- **SEO-optimized** — descriptive title/description/keywords, canonical URL, Open Graph
  + Twitter cards with a generated `1200×630` preview image, `robots.txt`, `sitemap.xml`,
  and three JSON-LD blocks (`WebSite`, an `ItemList` of two `SoftwareApplication`s, and a
  `FAQPage`) so both apps can surface as rich results.
- **Light/dark theme** (persisted), scroll-reveal, and full `prefers-reduced-motion`
  support. No build step, no dependencies — plain HTML/CSS/JS.

## Deploy to GitHub Pages

This folder is a self-contained, root-based Pages site. To publish it as
`https://a-vigneshramamoorthy-code.github.io/NotchApps/`:

1. Create a new **public** GitHub repo named **`NotchApps`** (empty, no README).
2. Push this folder:
   ```bash
   git remote add origin https://github.com/A-VigneshRamamoorthy-Code/NotchApps.git
   git branch -M main
   git push -u origin main
   ```
3. In the repo: **Settings → Pages → Build and deployment → Deploy from a branch**,
   choose **`main`** / **`/ (root)`**, then Save.

Using a different repo name or a custom domain? Update the absolute URLs in
`index.html` (`<link rel="canonical">`, the `og:`/`twitter:` tags, and the JSON-LD
`url`s), plus `robots.txt` and `sitemap.xml`.

## Regenerating the Open Graph image

`assets/og-image.png` was rendered from a small HTML template with Playwright at
1200×630. Re-render it any time by screenshotting a matching template — nothing on the
live site depends on the template being present.

## License

MIT — same spirit as the apps it links to.
