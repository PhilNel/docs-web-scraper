# Web Scraper Lambda

This documentation outlines the architecture and design of the Lambda functions used to fetch rendered HTML and parse it into structured job listings for storage in downstream systems.

Explore the tabs to see how it works.

## Related Repositories

📦 [perl-web-scraper](https://github.com/PhilNel/perl-web-scraper) - Contains the Perl Lambda function that parses job listings from raw HTML using Mojo::DOM.

📦 [go-web-scraper](https://github.com/PhilNel/go-web-scraper) – Contains the Go-based Lambda function that parses job listings from raw HTML using goquery.

📦 [node-web-fetcher](https://github.com/PhilNel/node-web-fetcher) - Headless browser Lambda that uses Puppeteer to fetch fully rendered HTML from dynamic websites.

📦 [terraform-web-scraper](https://github.com/PhilNel/terraform-web-scraper) - Terraform configuration for deploying the infrastructure and managing Lambda permissions, S3 buckets, etc.