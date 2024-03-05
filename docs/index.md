---
repository: "https://github.com/turbot/steampipe-mod-hackernews-insights"
---

# Hacker News Insights Mod

Create dashboards and reports for Hacker News stories, jobs, and other items using Powerpipe and Steampipe.

<!-- <img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/main/docs/images/hackernews_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/main/docs/images/hackernews_stories.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/main/docs/images/hackernews_sources.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/main/docs/images/hackernews_jobs.png" width="50%" type="thumbnail"/> -->
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/add-new-checks/docs/images/hackernews_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/add-new-checks/docs/images/hackernews_stories.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/add-new-checks/docs/images/hackernews_sources.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/add-new-checks/docs/images/hackernews_jobs.png" width="50%" type="thumbnail"/>

## Documentation

- **[Benchmarks and controls →](https://hub.powerpipe.io/mods/turbot/hackernews_insights/controls)**
- **[Named queries →](https://hub.powerpipe.io/mods/turbot/hackernews_ng/queries)**

## Getting Started

### Installation

Install Powerpipe (https://powerpipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/powerpipe
```

This mod also requires [Steampipe](https://steampipe.io) with the [Hacker News plugin](https://hub.steampipe.io/plugins/turbot/hackernews) as the data source. Install Steampipe (https://steampipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/steampipe
steampipe plugin install hackernews
```

Finally, install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/steampipe-mod-hackernews-insights
```

### Browsing Dashboards

Start Steampipe as the data source:

```sh
steampipe service start
```

Start the dashboard server:

```sh
powerpipe server
```

Browse and view your dashboards at **https://localhost:9033**.

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [Hacker News Insights Mod](https://github.com/turbot/steampipe-mod-hackernews-insights/labels/help%20wanted)
