# HTML Fetching

The HTML fetching phase is responsible for retrieving dynamic, JavaScript-rendered web pages and storing the fully rendered HTML in an S3 bucket for downstream parsing.

## Purpose

Many job listing sites (and other dynamic content sources) rely on client-side JavaScript to render their content. Traditional HTTP fetches or curl-style requests are insufficient because they return only the raw HTML shell, not the complete page. Our fetcher solves this by executing the JavaScript and extracting the fully rendered DOM.

## Architecture

- Implemented as an AWS Lambda function and written in Node.js
- Uses [Puppeteer](https://pptr.dev/) in combination with [`sparticuz/chrome-aws-lambda`](https://github.com/Sparticuz/chromium) to run headless Chromium
- Outputs the rendered HTML to an S3 bucket (`web-scraper-output`)

## Design Rationale

### Why Node.js?

- ✅ Availability of a precompiled, Lambda-optimized Chromium binary via `sparticuz/chrome-aws-lambda`
- ✅ Integration with Puppeteer for headless browsing and DOM evaluation
- ❌ Perl was not selected due to the lack of modern headless browser libraries and prebuilt Chromium support

### Why Puppeteer?

- Provides full browser context (JS execution, cookies, network hooks)
- Battle-tested for scraping, automation, and rendering use cases
- Easily configurable to run in headless mode, with timeout control and page event hooks

### Why use S3 as an intermediate step?

- ✅ Decouples the fetch and parse stages, allowing each to be triggered, retried, and debugged independently
- ✅ Makes raw HTML available for inspection or reuse without re-running Puppeteer

## Current Limitations

- No built-in retry or exponential backoff—failures are logged and discarded
- Currently stores all output to a flat S3 namespace; tagging or metadata may be needed later

## Future Enhancements

- Add support for fetching multiple pages/sites in a single execution
- Integrate error reporting and retry logic for failed fetches
- Store hash of fetched websites to avoid storing duplicate data
- TypeScript support
- Unit tests if required