dashboard "hackernews_people_report" {

  title         = "Hacker News People Report"
  documentation = file("./dashboards/hackernews/docs/hackernews_people_report.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
  })

  container {
    # Analysis

    chart {
      width = 6
      title = "Top 10 Active Hacker News User (Last 7 Days)"
      query = query.hackernews_ten_most_active_users
    }

  }

  container {

    title = "Hacker News People Detail"
     input "hn_user" {
      type = "select"
      sql   = query.hackernews_hn_user_input.sql
      width = 6
      }


    table {
      args = [
        self.input.hn_user.value
      ]

      query  = query.hackernews_people_detail
      column "Id" {
        href = "https://news.ycombinator.com/user?id={{.'Id'}}"
      }
    }

  }

}

query "hackernews_hn_user_input" {
  sql = <<-EOQ
    select distinct
      h.by as label,
      h.by as value
    from
      hackernews_item as h
    order by
      by
  EOQ
}

query "hackernews_people_detail" {
  sql = <<-EOQ
    select
      id as "Id",
      created as "Created",
      karma as "Karma",
      JSONB_ARRAY_LENGTH(submitted) as "Submitted Items",
      about as "About"
    from
      hackernews_user
    where
      id = $1;
  EOQ
  param "hn_user" {}
}

query "hackernews_ten_most_active_users" {
  sql = <<-EOQ
    with comment_num as (
      select
        by as BY,
        count(*) as comment_count
      from
        hackernews_item
      where
        type = 'comment'
        and time::timestamptz > now() - interval '7 day'
        and not deleted
      group by
        BY
    ),
    story_count as (
      select
        by,
        count(*) as story_count
      from
        hackernews_item
      where
        type = 'story'
        and time::timestamptz > now() - interval '7 day'
        and not deleted
      group by
        by
    )
    select
      by,
      (a.comment_count) as "Comment Count",
      (s.story_count) as "Story  Count"
    from
      comment_num a
    left join
      story_count s
    using
      (by)
    order by
      a.comment_count desc,
      s.story_count desc
    limit 15
  EOQ
}