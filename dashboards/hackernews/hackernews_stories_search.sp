dashboard "hackernews_stories_search" {

  title = "Hacker News Stories Search"
  documentation = file("./dashboards/hackernews/docs/hackernews_stories_search.md")

  tags = merge(local.hackernews_common_tags, {
      type = "Report"
    })

  container  {

    input "search_term" {
      width = 4
      placeholder = "search_term (matches in urls or titles, can be regex)"
      type = "text"
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
          score,
          descendants as "Comments"
        from
          hackernews_new
        where
          title ~* $1 or url ~* $1
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
        href = "http://localhost:9194/hackernews_insights.dashboard.hackernews_user_submissions?input.hn_user={{.'By'}}"
      }

  }


}