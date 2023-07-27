# Hacker News Insights Mod for Steampipe

A Hacker News dashboarding tool that can be used to view dashboards and reports across the latest Hacker News stories, jobs, and other items.

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-hackernews-insights/main/docs/images/hackernews_dashboard.png)

## Overview

Dashboards can help answer questions like:

- What companies, languages, and clouds were recently mentioned in stories?
- What roles and technologies were recently mentioned in jobs?
- What are the most popular domains among submitted stories?
- What are the latest Ask and Show HNs?

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

By default, the dashboard interface will then be launched in a new browser window at https://localhost:9194. From here, you can view dashboards and reports.

### Configuration

No extra configuration is required.

## Contributing

If you have an idea for additional dashboards or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join #steampipe on Slack → →](https://turbot.com/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-hackernews-insights/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Hacker News Insights Mod](https://github.com/turbot/steampipe-mod-hackernews-insights/labels/help%20wanted)
