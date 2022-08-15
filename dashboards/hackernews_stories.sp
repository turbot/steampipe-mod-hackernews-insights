dashboard "hackernews_stories" {

  title = "Hacker News Stories"
  documentation = file("./dashboards/docs/hackernews_stories.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
   })

  input "story_type" {
    title  = "Stories:"
    option "New" {}
    option "Top" {}
    option "Best" {}
    width  = 4
  }
  container {

    card {
      width = 2
      query = query.hackernews_max_score
      args = [
        self.input.story_type
      ]
    }

    card {
      width = 2
      query = query.hackernews_avg_score
      args = [
        self.input.story_type
      ]
    }

    card {
      width = 2
      query = query.hackernews_max_comments
      args = [
        self.input.story_type
      ]
    }

    card {
      width = 2
      query = query.hackernews_avg_comments
      args = [
        self.input.story_type
      ]
    }


  }

  container {

    table {
      args = [
        self.input.story_type
      ]
      query = query.hacker_news_stories

      column "By" {
        href = "https://news.ycombinator.com/user?id={{.'By'}}"
      }
      column "ID" {
        href = "https://news.ycombinator.com/item?id={{.'ID'}}"
      }
      column "URL" {
        wrap = "all"
      }
    }
  }

}

query "hackernews_max_comments" {
  sql = <<-EOQ
    with stories as (
      select * from hackernews_new where $1 = 'New'
      union
      select * from hackernews_top where $1 = 'Top'
      union
      select * from hackernews_best where $1 = 'Best'
      )
      select max(descendants) as "Max Comments" from stories
   EOQ
  param "story_type" {}
}

query "hackernews_avg_comments" {
  sql = <<-EOQ
    with stories as (
      select * from hackernews_new where $1 = 'New'
      union
      select * from hackernews_top where $1 = 'Top'
      union
      select * from hackernews_best where $1 = 'Best'
    )
    select
      round(avg(descendants), 1) as "Avg Comments" from hackernews_new
  EOQ
  param "story_type" {}
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
    to_char(time::timestamptz, 'YYYY-MM-DD HH24:MI:SS') as "Time",
    score as "Score",
    descendants as "Comments",
    title as "Title",
    url as "URL"
  from
    stories
  order by
    score desc,
    descendants desc;
  EOQ

  param "story_type" {}
}
