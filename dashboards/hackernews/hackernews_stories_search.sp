dashboard "hackernews_stories_search" {

  title = "Hacker News Stories Search"
  documentation = file("./dashboards/hackernews/docs/hackernews_stories_search.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
   })

  container {

    input "search_term" {
      width = 4
      placeholder = "search_term (matches in urls or titles, can be regex)"
      type = "text"
    }

    text "search_examples" {
      width = 8
      value = <<-EOM
      Examples:
      [python](http://localhost:9194/hackernews_insights.dashboard.hackernews_stories_search?input.search_term=python)
      [github](http://localhost:9194/hackernews_insights.dashboard.hackernews_stories_search?input.search_term=github)
      [wikipedia/wiki](http://localhost:9194/hackernews_insights.dashboard.hackernews_stories_search?input.search_term=wikipedia.org%2Fwiki),
      [nytimes.+/technology](http://localhost:9194/hackernews_insights.dashboard.hackernews_stories_search?input.search_term=nytimes.%2b/technology)
      EOM
    }

  }

  table {
    args = [
      self.input.search_term
    ]
    sql = <<-EOQ
      select
        id as "ID",
        by as "By",
        title as "Title",
        to_char(time::timestamptz, 'MM-DD hHH24') as "Time",
        case
          when url = '<null>' then ''
          else url
        end as "URL",
        score as "Score",
        descendants as "Comments"
      from
        hackernews_item
      where
        type = 'story'
        and title ~* $1 or url ~* $1
      order by
        score::int desc
    EOQ
    column "URL" {
      wrap = "all"
    }
    column "ID" {
      href = "https://news.ycombinator.com/item?id={{.'ID'}}"
    }
    column "By" {
      href = "https://news.ycombinator.com/user?id={{.'By'}}"
    }

  }

}