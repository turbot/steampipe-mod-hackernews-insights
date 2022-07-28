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
      title = "Top 10 Active People By Comment (Last 7 Days)"
      query = query.hackernews_ten_most_active_users_by_comment
    }

    chart {
      width = 6
      title = "Top 10 Active People By Story (Last 7 Days)"
      query = query.hackernews_ten_most_active_users_by_story
    }

  }

  container {

    table {
      query = query.hackernews_people_list
      column "Id" {
        href = "https://news.ycombinator.com/user?id={{.'Id'}}"
      }
    }

  }

}

query "hackernews_people_list" {
  sql = <<-EOQ
    with test as (
      select distinct
        h.by as label
      from
        hackernews_item as h
      order by
        by
    )
    select
      u.id as "Id",
      to_timestamp(u.created::int) as "Created",
      u.karma as "Karma",
      jsonb_array_length(u.submitted) as "Submitted Items"
    from
      test as t left join
      hackernews_user as u on u.id = t.label
    where
      u.id is not null
    order by
      u.id
    limit 50;
  EOQ

}

query "hackernews_ten_most_active_users_by_comment" {
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
    )
    select
      by,
      (a.comment_count) as "Comment Count"
    from
      comment_num a
    order by
      a.comment_count desc
    limit 15
  EOQ
}

query "hackernews_ten_most_active_users_by_story" {
  sql = <<-EOQ
    with story_count as (
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
      (s.story_count) as "Story Count"
    from
      story_count s
    order by
      s.story_count desc
    limit 15
  EOQ
}