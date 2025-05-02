# HTML Parsing

The HTML parsing phase extracts structured data from previously fetched and rendered HTML documents. It is implemented as a Perl-based Lambda function using a custom runtime and is designed to convert raw DOM content into job listings.

## Purpose

After the fetcher Lambda stores raw HTML snapshots in S3, this phase consumes them and extracts job data (e.g. title, company, location, link). By isolating this responsibility, we can iterate on parsing logic independently of how the content is retrieved.

## Architecture

- Implemented as an AWS Lambda function using a **custom runtime**
- Written in **Perl**
- Reads HTML files from S3 (`web-scraper-output`)
- Uses [`Mojo::DOM`](https://metacpan.org/pod/Mojo::DOM) for HTML parsing

## Design Rationale

### Why Perl?

- ✅ Chosen as a learning objective: to understand modern Perl usage in backend contexts
- ✅ Enables experimentation with AWS Lambda’s **custom runtime API**
- ✅ Perl offers mature regex and DOM parsing capabilities with minimal dependencies
- ❌ No official Lambda runtime support (requires custom lambda handler)

### Why Mojo::DOM?

- Lightweight, pure-Perl HTML DOM parser
- Supports CSS selectors, text extraction, and attribute traversal

### Why a custom runtime?

- AWS does not natively support Perl as a Lambda runtime
- To understand the lambda runtime for future unsupported runtimes

### Why Amazon::S3 (not Paws)?

- ✅ Much smaller dependency footprint—minimized packaging size and complexity
- ✅ Easier to set up for fast prototyping
- ❌ Less feature-rich than [Paws](https://metacpan.org/pod/Paws), which offers full AWS SDK support

Now that Lambda supports larger deployment packages (up to 10 GB with container images), we may revisit using `Paws` in the future.

## Current Limitations

- Assumes all HTML files are consistent in structure
- Output is currently printed to stdout only (not persisted)
- No schema enforcement or job validation yet
- Minimal error handling for broken or malformed HTML

## Future Enhancements

- Store parsed jobs in DynamoDB for persistent, queryable access
- Implement event-driven invocation so the parser Lambda runs automatically when the fetcher uploads new HTML files
- Track job lifecycle by adding "active/inactive" status to detect when a listing is removed from a website
- Support multiple job site formats via pluggable parser modules
- Extract the custom runtime implementation into a reusable CPAN module for use in other Perl-based Lambdas

