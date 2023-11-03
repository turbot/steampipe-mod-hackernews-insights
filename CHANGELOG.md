## v0.4 [2023-11-03]

_Breaking changes_

- Updated the plugin dependency section of the mod to use `min_version` instead of `version`. ([#12](https://github.com/turbot/steampipe-mod-hackernews-insights/pull/12))

## v0.3 [2023-02-21]

_Bug fixes_

- Fixed syntax for `self.input.<input_name>` references to include `.value`, e.g., `self.input.<input_name>.value`.

## v0.2 [2022-08-16]

_Enhancements_

- Updated screenshots in README and index doc for better readability.

## v0.1 [2022-08-16]

_What's new?_

- New dashboards added:
  - [Hacker News Dashboard](https://hub.steampipe.io/mods/turbot/hackernews_insights/dashboards/dashboard.hackernews_dashboard) ([#1](https://github.com/turbot/steampipe-mod-hackernews-insights/pull/1))
  - [Hacker News Jobs](https://hub.steampipe.io/mods/turbot/hackernews_insights/dashboards/dashboard.hackernews_jobs) ([#1](https://github.com/turbot/steampipe-mod-hackernews-insights/pull/1))
  - [Hacker News Sources](https://hub.steampipe.io/mods/turbot/hackernews_insights/dashboards/dashboard.hackernews_sources) ([#1](https://github.com/turbot/steampipe-mod-hackernews-insights/pull/1))
  - [Hacker News Stories](https://hub.steampipe.io/mods/turbot/hackernews_insights/dashboards/dashboard.hackernews_stories) ([#1](https://github.com/turbot/steampipe-mod-hackernews-insights/pull/1))
