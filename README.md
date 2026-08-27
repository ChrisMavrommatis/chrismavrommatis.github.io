# chrismavrommatis.github.io

My personal site. Jekyll, deployed to GitHub Pages.

## Built with

[![Jekyll](https://img.shields.io/badge/-Jekyll-CC0000?logo=jekyll&logoColor=white&style=flat-square)](https://jekyllrb.com/)
[![Ruby](https://img.shields.io/badge/-Ruby-CC342D?logo=ruby&logoColor=white&style=flat-square)](https://www.ruby-lang.org/en/)
[![SCSS](https://img.shields.io/badge/-SCSS-CD6799?logo=sass&logoColor=white&style=flat-square)](https://sass-lang.com/)
[![Markdown](https://img.shields.io/badge/-Markdown-000000?logo=markdown&logoColor=white&style=flat-square)](https://daringfireball.net/projects/markdown/)
[![GitHub Actions](https://img.shields.io/badge/-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white&style=flat-square)](https://github.com/features/actions)
[![GitHub Pages](https://img.shields.io/badge/-GitHub%20Pages-222222?logo=githubpages&logoColor=white&style=flat-square)](https://pages.github.com/)

## Running it

```bash
npm run setup      # bundle install
npm run serve      # http://127.0.0.1:4002
npm run build      # build into _site
npm run drafts     # serve with drafts included
```

Ruby is pinned in `.ruby-version`, read by both rbenv and CI.

## Structure

Everything under `src/` becomes the website. Everything outside it builds or documents the repo.

```
src/
├── _data/            profile, ui strings, projects, certifications, tech, menus, icons
├── _includes/        partials
├── _layouts/         page > default > home | bloglist | blog_detail
├── _plugins/         gtm_tag, sanitization_filters, required_filter
├── _sass/            SCSS partials, plus pygments themes in pygments/
├── assets/           css, post images, profile picture, icons
├── collections/
│   └── _posts/       blog posts
├── pages/            home, blog index, 404, robots.txt, site verification, webmanifest
└── sitemap/          sitemaps for pages and posts
```

- **`source: ./src`** keeps site content separate from repo tooling.
- **`collections_dir: collections`** puts posts at `src/collections/_posts/`.
- The site sets `safe: false` and loads three custom plugins, so GitHub Pages cannot build it natively.
  `.github/workflows/site.yml` builds it and deploys the output. Nothing runs on a push: the workflow
  is dispatch only, and it publishes only when dispatched with `publish` on.

## Licence

Two licences, split by what a file is. There is no single SPDX identifier for that, so this section
is the authority.

- **Writing and its images** under [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/):
  `src/collections/_posts/` and `src/assets/posts/`.
  [CONTENT-TERMS.md](CONTENT-TERMS.md) is the plain-English summary.
- **Everything else under `src/`** under the MIT Licence: layouts, includes, SCSS, plugins, data
  files, icons. See [LICENSE.MIT](LICENSE.MIT).
- **My photograph is not licensed.** `src/assets/profile/profilepic-2024es_500px.jpg` is all rights
  reserved. It is on the site because it is mine, not because you may reuse it.

`src/_sass/pygments/` is not mine. Both files come from Pygments and keep its BSD 2-Clause notice.
