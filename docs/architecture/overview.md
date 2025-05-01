# Architecture Overview

This project implements a two-phase web scraping pipeline using AWS Lambda functions written in Node.js and Perl. The system is designed to handle dynamic, JavaScript-rendered pages and convert them into structured data.

## High-Level Flow

This diagram is generated from YAML using [`awsdac`](https://github.com/awslabs/diagram-as-code).

<img src="../web-scraper-pipeline.png" alt="Web Scraper Architecture Diagram" style="max-width: 100%; border: 1px solid #ccc; border-radius: 6px;">

## Components
1. **fetcher-lambda**
    - A Node.js Lambda function responsible for fetching HTML content
    - Uses headless Chromium (via Puppeteer) to render JavaScript-heavy pages
    - Stores the fully rendered HTML in an intermediate S3 bucket

2. **web-scraper-output**
    - Acts as a bridge between the fetch and parse phases
    - Receives raw HTML from the fetcher

3. **parser-lambda**
    - A Perl-based Lambda function that parses the stored HTML
    - Uses a custom runtime implemented with a `bootstrap` script
    - Parses the HTML using `Mojo::DOM` to extract structured job listings

