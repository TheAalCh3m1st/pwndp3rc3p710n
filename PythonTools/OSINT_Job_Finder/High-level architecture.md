job-osint/
├── core/
│      ├── models.py            # Job, Company dataclasses / pydantic models
│      ├── provider.py          # abstract JobProvider     base class (interface)
│      ├── search_engine.py     # orchestrates search across providers + filtering
│      └── enrichment.py        # company enrichment helpers (optional external APIs)
├── providers/
│      ├── mock_provider.py     # returns sample jobs (for tests & offline dev)
│      ├── rss_provider.py      # fetch jobs from RSS/Atom feeds
│      └── adzuna_provider.py   # example provider using Adzuna API (if key provided)
├── utils/
│      ├── http_client.py       # wrapper over requests / aiohttp + rate-limiting
│      ├── cache.py             # optional caching layer (simple file/ttl cache)
│      └── synonyms.py          # mapping of job title synonyms
├── cli.py                   # simple CLI (search CLI + export)
├── config.py                # configuration (API keys, rate limits)
└── tests/
    ├── test_providers.py
    └── test_search_engine.py
