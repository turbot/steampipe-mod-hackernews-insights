dashboard "hackernews_stories" {

  title = "Hacker News Stories"
  documentation = file("./dashboards/hackernews/docs/hackernews_stories.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
   })

  input "story_type" {
    title    = "Stories:"
    option "New" {}
    option "Top" {}
    option "Best" {}
    width       = 4
  }

container {

  input "search_term" {
    width = 4
    placeholder = "search_term (matches in urls or titles, can be regex)"
    type = "text"
    args  = {
      story_type = self.input.story_type.value
    }
  }

  text "search_examples" {
    width = 8
    value = <<-EOM
    Examples:
    [python](http://localhost:9194/hackernews_insights.dashboard.hackernews_stories?input.story_type=New&input.search_term=python)
    [github](http://localhost:9194/hackernews_insights.dashboard.hackernews_stories?input.story_type=New&input.search_term=github)
    [wikipedia/wiki](http://localhost:9194/hackernews_insights.dashboard.hackernews_stories?input.story_type=New&input.search_term=wikipedia.org%2Fwiki),
    [nytimes.+/technology](http://localhost:9194/hackernews_insights.dashboard.hackernews_stories?input.story_type=New&input.search_term=nytimes.%2b/technology)
    EOM
  }

}

  container {

    table {
      args = [
        self.input.story_type,
        self.input.search_term
      ]
      sql = <<-EOQ
        with stories as (
          select * from hackernews_new where $1 = 'New'
          union
          select * from hackernews_top where $1 = 'Top'
          union
          select * from hackernews_best where $1 = 'Best'
        )
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
          stories
        where
          title ~* $2 or url ~* $2
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

  container {

    table {
      args = [
        self.input.story_type
      ]
      query = query.hacker_news_stories
      column "ID" {
        href = "https://news.ycombinator.com/item?id={{.'ID'}}"
      }

      column "By" {
        href = "http://localhost:9194/hackernews_insights.dashboard.hackernews_user_submissions?input.hn_user={{.'By'}}"
      }
    }
  }

}

query "hacker_news_stories" {
  sql = <<-EOQ
  with stories as (
    select * from hackernews_new where $1 = 'New'
    union
    select * from hackernews_top where $1 = 'Top'
    union
    select * from hackernews_best where $1 = 'Best'
  )
  select
    id as "ID",
    by as "By",
    to_char(time::timestamptz, 'MM-DD hHH24') as "Time",
    now()::date - time::date as "Age in Days",
    title as "Title",
    score::int as "Score",
    descendants::int as "Comments",
    dead as "Dead",
    deleted as "Deleted",
    url as "URL"
  from
    stories
  where
    score is not null
    and descendants is not null
  order by
    score desc,
    descendants desc;
  EOQ

  param "story_type" {}
}


