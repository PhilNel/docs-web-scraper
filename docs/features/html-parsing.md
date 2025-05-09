# HTML Parsing

The HTML parsing phase extracts structured data from previously fetched and rendered HTML documents. It is implemented as a Perl-based Lambda function using a custom runtime and is designed to convert raw DOM content into job listings.

In addition to the Perl-based parser, a Go-based equivalent Lambda function was also developed. This was done with the intention of comparing development effort and performance between the two implementations.

## Purpose

After the fetcher Lambda stores raw HTML snapshots in S3, this phase consumes them and extracts job data (e.g. title, company, location, link). By isolating this responsibility, we can iterate on parsing logic independently of how the content is retrieved.

## Architecture

### Perl Lambda
- Implemented as an AWS Lambda function using a **custom runtime**
- Deployed as a Docker container to support the custom Perl runtime and required dependencies
- Uses [`Mojo::DOM`](https://metacpan.org/pod/Mojo::DOM) for HTML parsing

### Go Lambda
- Implemented as an AWS Lambda function using the provided.al2 (Amazon Linux 2) runtime
- Compiled as a statically-linked binary and packaged into a `.zip` for Lambda deployment
- Uses [`PuerkitoBio/goquery`](https://github.com/PuerkitoBio/goquery) (jQuery-like syntax) for HTML parsing

### Common
- Reads HTML files from S3 (`web-scraper-output`)
- Outputs structured job listings to DynamoDB (`job-store`)

## Design Rationale

### Why Perl?

- ✅ Chosen as a learning objective: to understand modern Perl usage in backend contexts
- ✅ Enables experimentation with AWS Lambda’s **custom runtime API**
- ✅ Perl offers mature regex and DOM parsing capabilities with minimal dependencies
- ❌ No official Lambda runtime support (requires custom lambda handler)

### Why Go?
- ✅ Familiarity with Go — The developer is more experienced with Go, allowing for faster iteration and debugging
- ✅ Performance comparison — Parsing performance and memory usage can be benchmarked between Perl and Go to determine optimal runtime characteristics
- ✅ Cross-language learning — Maintaining both versions showcases how different ecosystems approach clean architecture, HTML parsing, and AWS integration
- ❌ Duplication of effort since both implementations must be maintained

### Why Mojo::DOM?

- Lightweight, pure-Perl HTML DOM parser
- Supports CSS selectors, text extraction, and attribute traversal

### Why goquery?

- Lightweight and easy to use Go HTML parser
- Built on top of the Go standard library’s HTML tokenizer, ensuring performance and reliability
- Widely used and well-documented

### Why a custom runtime?

- AWS does not natively support Perl as a Lambda runtime
- To understand the lambda runtime for future unsupported runtimes

### Why Paws (instead of Amazon::S3 / Amazon::DynamoDB)?
We initially chose Amazon::S3 and Amazon::DynamoDB for their minimal dependency footprint and quick setup. However, we've now migrated to [Paws](https://metacpan.org/pod/Paws), the official Perl AWS SDK, for the following reasons:

- ✅ Supports temporary credentials, which are required for execution in AWS Lambda environments (unlike Amazon::DynamoDB, which lacks this support)
- ✅ Unified SDK for multiple AWS services, simplifying future integrations
- ✅ More consistent and complete API coverage for AWS services

The disadvantages of this decision are as listed below:

- ⚠️ Larger Docker image size, as Paws introduces more dependencies
- ⚠️ Slower CI builds, especially for linting and unit tests

However, with AWS Lambda now supporting larger deployment packages (up to 10 GB with container images), the increased size is an acceptable trade-off for improved functionality and long-term maintainability.

### Output Flexibility
The parser-lambdas support pluggable "sink" implementations to handle different output targets:

- ✅ DynamoDB — Currently supported. Parsed job listings are stored as structured records for easy querying and downstream consumption.
- ✅ Console output — A minimal sink used for debugging and local development.
- 🟡 S3 support — Planned. This would allow raw or structured job data to be archived in object storage (e.g., as newline-delimited JSON).

This design enables new sinks (e.g., for S3 or external APIs) to be added without modifying parser internals.

## Current Limitations

- Assumes all HTML files are consistent in structure
- Minimal error handling for broken or malformed HTML

## Future Enhancements

- Implement event-driven invocation so the parser Lambda runs automatically when the fetcher uploads new HTML files
- Track job lifecycle by adding "active/inactive" status to detect when a listing is removed from a website
- Support multiple job site formats via pluggable parser modules
- Extract the custom runtime implementation into a reusable CPAN module for use in other Perl-based Lambdas

