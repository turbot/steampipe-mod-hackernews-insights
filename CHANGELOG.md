## v1.0.0 [2024-10-22]

This mod now requires [Powerpipe](https://powerpipe.io). [Steampipe](https://steampipe.io) users should check the [migration guide](https://powerpipe.io/blog/migrating-from-steampipe).

## v0.5 [2024-03-06]

_Powerpipe_

[Powerpipe](https://powerpipe.io) is now the preferred way to run this mod!  [Migrating from Steampipe →](https://powerpipe.io/blog/migrating-from-steampipe)

All v0.x versions of this mod will work in both Steampipe and Powerpipe, but v1.0.0 onwards will be in Powerpipe format only.

_Enhancements_

- Focus documentation on Powerpipe commands.
- Show how to combine Powerpipe mods with Steampipe plugins.

## v0.4 [2023-11-03]

_Breaking changes_

- Updated the plugin dependency section of the mod to use `min_version` instead of `version`. ([#12](https://github.com/turbot/steampipe-mod-hackernews-insights/pull/12))

_Bug fixes_

- Fixed dashboard localhost URLs in README and index doc. ([#8](https://github.com/turbot/steampipe-mod-hackernews-insights/pull/8))

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
