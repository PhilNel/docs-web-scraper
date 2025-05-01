# Web Scraper Docs

This repository hosts the documentation for the Web Scraper Lambda pipeline. The docs are written in Markdown, built with [MkDocs](https://www.mkdocs.org/) using the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme, and deployed via GitHub Pages.

## 🚀 Getting Started

Install dependencies (Python, MkDocs):

```bash
make install
```

Serve locally:

```bash
make serve
```

Regenerate architecture diagram:

```bash
make diagram
```

## 🧩 Related Repositories

- [📦 `perl-web-scraper`](https://github.com/PhilNel/perl-web-scraper) - Contains the Perl Lambda function that parses job listings from raw HTML using `Mojo::DOM`.

- [📦 `node-web-fetcher`](https://github.com/PhilNel/node-web-fetcher) - Headless browser Lambda that uses Puppeteer to fetch fully rendered HTML from dynamic websites.

- [📦 `infra-web-scraper`](https://github.com/PhilNel/infra-web-scraper) - Terraform configuration for deploying the infrastructure and managing Lambda permissions, S3 buckets, etc.
