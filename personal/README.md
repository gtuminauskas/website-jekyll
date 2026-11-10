# Pillar

> This theme is designed by Xiaoying Riley at [3rd Wave Media](http://themes.3rdwavemedia.com/).
> Visit her [website](http://themes.3rdwavemedia.com/) for more themes.

## Installation

## Skins

## License

This project is licensed under the [MIT license](LICENSE.txt).

## Modern résumé and content ownership

The active page uses `layout: modern` in `index.markdown`. The original Pillar
`home` layout and its assets remain available. The modern layout has its own CSS
and uses system fonts, local assets, and no external scripts or font services.

Edit `_data/data.yml` for résumé content; edit `_data/labels.yaml` for section
names. Keep employer descriptions, job titles, dates, technologies, and contact
details out of layout files. `_config.yml` owns the site author, SEO metadata,
and deployment URL/base path. The optional `header.headline` controls the displayed
headline; keep `tagline` in `_config.yml` consistent for search metadata.

### Content contract for future templates

New layouts should consume these existing fields without renaming them:

| Section | Fields |
| --- | --- |
| `header` | Optional `headline`, `location`, `avatar`, `email`, `phone`, `website`, and social usernames |
| `summary` | Markdown text (existing HTML line breaks remain supported) |
| `experiences[]` | `role`, `company`, `time`; optional `subrole`, `location`, Markdown `details`, `technologies[]`, `achievements.desc`, `achievements.highlights[]` |
| `skills[]` | `category`, `tools[]`; tools can be strings or objects with `name` and optional `level` |
| `education[]` | `degree`, `university`, `time`, optional Markdown `details` |
| `languages[]` | `idiom`, `level` |
| `interests[]` | `name`, optional `link` |
| `awards[]` | `name`, optional Markdown `description` |

Optional sections may be omitted or empty. Preserve both skill representations,
optional achievement fields, and all social platforms when replacing a template.
Keep new content as plain Markdown rather than adding template CSS classes or
presentation HTML. Existing skill levels remain in the data for compatibility with the original
layout; the modern layout displays skill names without percentages or ratings.

To change designs later, add another layout and its assets, then change only
`layout` in `index.markdown`. A theme with a different schema needs a Liquid
adapter in the presentation layer; do not reshape the canonical data for it.
This keeps content stable, although arbitrary third-party themes are not drop-in
compatible without that adapter.

### Preview and print

Use Ruby 4.0.9 for the same runtime as CI, with Bundler 4.0.24 from the
lockfile. The updated build dependencies require Ruby 3.2 or newer, so CentOS
Stream 9's system Ruby 3.0 cannot run this stack. Use a separately managed Ruby
installation; the deployment workflow does not change workstation packages.

From the repository root:

```bash
bash run-locally.sh
```

The script installs missing locked dependencies once, then starts Jekyll's watch
server. Initial dependency installation needs internet access; later starts reuse
the cached gems. The lockfile is frozen, so the script cannot update versions.
Gems are stored under `$XDG_CACHE_HOME/website-jekyll/bundle` (or
`$HOME/.cache/website-jekyll/bundle`); an explicit `BUNDLE_PATH` is respected.

Open <http://127.0.0.1:4000/>. Leave the terminal running and refresh your browser
after editing YAML, layouts, CSS, or JavaScript. Jekyll rebuilds automatically;
there is no manual build command per edit. Polling is enabled for reliable file
change detection. Changes to `_config.yml` or dependencies require restarting the
script. Stop with Ctrl+C. If the old Python preview is running on port 4000,
stop it before starting this script.

The generated preview is written outside the repository, under
`$TMPDIR/website-jekyll-preview` (default `/tmp/website-jekyll-preview`). The
checked-in `_site` snapshot and the separate `testing/` directory are untouched.

Use **Print / Save PDF** or the browser's print command. The print stylesheet uses
A4 margins, black text, a single column, and hides navigation and the portrait.
It includes the entire career history and qualifications, so this is a full CV,
not a guaranteed two-page résumé. Browser headers/footers can be disabled in the
print dialog. Review page breaks in your browser before sending a PDF.

### Content sources and review

The LinkedIn PDF supplied in November 2026 provides the current headline,
Accenture and Danske Bank roles, earlier career entries, additional education,
and the IPv6 award. Existing repository skills and technologies are retained.
The incorrect Intermedix employer description was replaced from that PDF.
London Community College (2004–2006), absent from the PDF, is retained from the
old PHP site. University studies are explicitly marked as not completed, based
on the existing content. The public contact email remains the site's existing
address rather than substituting the LinkedIn-specific address.

The PDF's auto-generated employment durations are not stored or recalculated.
Accenture and Danske Bank have no responsibility descriptions in that export;
none have been invented. Concurrent employment/contract entries are preserved.

### GitHub Pages deployment

The repository workflow `.github/workflows/pages.yml` builds this `personal/`
directory with the locked gems, uploads only its generated output, and deploys
through the `github-pages` environment. It does not publish the repository root,
`testing/`, or the checked-in `_site` snapshot. All actions are pinned to commits.
The runner installs Ruby and all locked dependencies itself; no local build or
installed gems are uploaded. CI defaults to Ruby 4.0.9 on Ubuntu 26.04; local
Ruby configuration is unchanged. The first run installs gems; later runs can
reuse the setup action's cache. Missing caches are valid and cause installation.

The workflow's top-level `env` block defines the source directory, generated
output directory name, and Ruby version default. To override runtime settings
without editing workflow code, use **Settings → Secrets and variables → Actions
→ Variables**:

| Repository variable | Default | Purpose |
| --- | --- | --- |
| `RUBY_VERSION` | `4.0.9` | Ruby version installed by `ruby/setup-ruby` |
| `PAGES_RUNNER` | `ubuntu-26.04` | GitHub-hosted runner label for both jobs |

These are ordinary configuration variables, not secrets. If unset, the explicit
workflow defaults apply. Choose a runner supported by `ruby/setup-ruby` and
compatible with the lockfile's Linux x86-64 platform. Verify version direction
and dependency compatibility before changing either runtime setting.

Jekyll, plugins, and Bundler are resolved from `personal/Gemfile.lock`; their
versions are not duplicated in the workflow. Dependencies install in frozen mode,
so a lockfile mismatch fails instead of silently resolving different versions.
The default branch comes from GitHub's repository context. The production origin
and URL prefix come from `actions/configure-pages`, and the deployment URL comes
from `actions/deploy-pages`.

GitHub does not support expressions in action `uses:` references or push path
filters. Action commit pins therefore remain literal at each action step. If the
source directory is renamed, update its `env` value and the push path filter.
The `github-pages` environment and matching concurrency group are fixed workflow
identifiers; keep them aligned with the repository's deployment protection rules.

One-time setup, performed by the repository owner:

1. In the GitHub repository, open **Settings → Pages**.
2. Under **Build and deployment → Source**, select **GitHub Actions**.
3. Review, commit, and push the website source and workflow to the repository's
   default branch. Include the new modern layout, CSS, and JavaScript files.
4. Open **Actions → Deploy résumé to GitHub Pages** and inspect the run.
   Subsequent default-branch pushes affecting `personal/` or this workflow deploy
   automatically. **Run workflow** also deploys from the default branch; other
   branches are skipped. Changes only under `testing/` do not trigger deployment.
5. Follow the URL shown by the deployment job or **Settings → Pages**.

The configured project URL is <https://gtuminauskas.github.io/website-jekyll/>.
The workflow uses Pages metadata for the actual production origin and base path,
including a custom domain if one is configured later. It needs no personal access
token: GitHub supplies the job token and deployment identity. Only the deploy job
receives Pages write and OIDC permissions. If environment approval is configured,
GitHub will wait for the owner's approval before deployment.

GitHub Pages availability depends on repository visibility and the account plan.
Publishing this site makes its rendered résumé and contact details available to
visitors. The existing personal-domain redirect is unchanged; moving that domain
requires a separate DNS/Pages configuration step.

References: [GitHub Pages custom workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)
and [publishing source settings](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site).

Action pins were checked against official stable releases. Dependabot checks
GitHub Actions weekly and proposes updates for review; it does not auto-merge.
Ruby's default remains an explicit workflow variable and must be reviewed against
supported releases separately. An existing repository `RUBY_VERSION` variable
overrides the workflow default, so update it when adopting Ruby 4.

The Ruby 4 migration upgrades Bundler to 4.0.24, Jekyll to 4.4.1, the Sass
converter to 3.1.0, Sass Embedded to 1.108.1, and Rake to 13.4.2. `logger` is an
explicit dependency because Ruby 4 no longer includes it among default gems.
The retained Pillar Sass sources still emit deprecation warnings; their build
and layout remain supported without editing those original sources.
