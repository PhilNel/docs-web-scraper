# Architecture Overview

This project implements a two-phase web scraping pipeline using AWS Lambda functions written in Node.js, Go and Perl. The system is designed to handle dynamic, JavaScript-rendered pages and convert them into structured data.

## High-Level Flow

This diagram is generated from YAML using [`awsdac`](https://github.com/awslabs/diagram-as-code).

<img src="../web-scraper-pipeline.png" alt="Web Scraper Architecture Diagram" style="max-width: 100%; border: 1px solid #ccc; border-radius: 6px;">

## Components
1. **fetcher-lambda**
    - A [Node.js Lambda function](https://github.com/PhilNel/node-web-fetcher) responsible for fetching HTML content
    - Uses headless Chromium (via Puppeteer) to render JavaScript-heavy pages
    - Stores the fully rendered HTML in an intermediate S3 bucket

2. **web-scraper-output**
    - Acts as a bridge between the fetch and parse phases
    - Receives raw HTML from the fetcher

3. **parser-lambda**
    - A [Perl-based Lambda function](https://github.com/PhilNel/perl-web-scraper) and a [Go Lambda function](https://github.com/PhilNel/go-web-scraper) that parse the stored HTML
    - The Perl function uses a custom runtime implemented via a `bootstrap` script and is deployed as a Docker container, while the Go function uses a zip-based deployment with the `provided.al2` runtime
    - Parses HTML using `Mojo::DOM` (Perl) or `PuerkitoBio/goquery` (Go) to extract structured job listings

4. **job-store**
    - Stores structured job listings parsed by the Lambda functions

## Infrastructure

- [**terraform-web-scraper**](https://github.com/PhilNel/terraform-web-scraper)  
Terraform project for managing infrastructure: S3 buckets, Lambda deployment, IAM roles, and CI/CD wiring.