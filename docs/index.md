---
repository: "https://github.com/turbot/steampipe-mod-hackernews-insights"
---

# Hacker News Insights Mod

Create dashboards and reports for Hacker News stories, jobs, and other items using Steampipe.

<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/main/docs/images/hackernews_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/main/docs/images/hackernews_stories.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/main/docs/images/hackernews_sources.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/main/docs/images/hackernews_jobs.png" width="50%" type="thumbnail"/>

## Overview

Dashboards can help answer questions like:

- What companies, languages, and clouds were recently mentioned in stories?
- What roles and technologies were recently mentioned in jobs?
- What are the most popular domains among submitted stories?
- What are the latest Ask and Show HNs?

## References

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration, and `dashboards` that organize and display key pieces of information.

## Documentation

- **[Dashboards →](https://hub.steampipe.io/mods/turbot/hackernews_insights/dashboards)**

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the Hacker News plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install hackernews
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-hackernews-insights.git
cd steampipe-mod-hackernews-insights
```

### Usage

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser window at http://localhost:9194. From here, you can view dashboards and reports.

### Configuration

No extra configuration is required.

## Contributing

If you have an idea for additional dashboards or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-hackernews-insights/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Hacker News Insights Mod](https://github.com/turbot/steampipe-mod-hackernews-insights/labels/help%20wanted)
