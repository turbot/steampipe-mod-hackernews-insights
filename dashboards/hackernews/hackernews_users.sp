dashboard "hackernews_users" {

  title         = "Hacker News Users"
  documentation = file("./dashboards/hackernews/docs/hacker_news_users.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
  })

  input "story_type" {
    title = "Stories:"
    option "New" {}
    option "Top" {}
    option "Best" {}
    width = 4
  }

  container {
    # Analysis

    chart {
      width = 6
      title = "Top 10 Active Users (Last 24 Hour)"
      query = query.hackernews_ten_most_active_users_by_story
      args = [
        self.input.story_type
      ]
    }

    chart {
      width = 6
      title = "Top 10 Users By Karma Points"
      args = [
        self.input.story_type
      ]
      query = query.hackernews_users_by_karma_point
    }

  }

  container {

    table {
      query = query.hackernews_people_list
      args = [
        self.input.story_type
      ]
      column "Id" {
        href = "https://news.ycombinator.com/user?id={{.'Id'}}"
      }
    }

  }

}

query "hackernews_people_list" {
  sql = <<-EOQ
    with test as (
      select distinct by as label from hackernews_new where $1 = 'New'
      union
      select distinct by as label from hackernews_top where $1 = 'Top'
      union
      select distinct by as label from hackernews_best where $1 = 'Best'
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
  param "story_type" {}
}


query "hackernews_ten_most_active_users_by_story" {
  sql = <<-EOQ
    with story_count as (
      select
        by,
        count(*) as story_count
      from
        hackernews_new
      where
        type = 'story'
        and time::timestamptz > now() - interval '1 day'
        and not deleted
        and $1 = 'New'
      group by
        by
      union
      select
        by,
        count(*) as story_count
      from
        hackernews_top
      where
        type = 'story'
        and time::timestamptz > now() - interval '1 day'
        and not deleted
        and $1 = 'Top'
      group by
        by
      union
        select
        by,
        count(*) as story_count
      from
        hackernews_best
      where
        type = 'story'
        and time::timestamptz > now() - interval '1 day'
        and not deleted
        and $1 = 'Best'
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
  param "story_type" {}
}

query "hackernews_users_by_karma_point" {
  sql = <<-EOQ
    with people as (
      (select distinct by as label from hackernews_new where $1 = 'New' order by by)
      union
      (select distinct by as label from hackernews_top where $1 = 'Top' order by by)
      union
      (select distinct by as label from hackernews_best where $1 = 'Best' order by by)
    )
    select
      u.id,
      u.karma as "Karma"
    from
      people as t left join
      hackernews_user as u on u.id = t.label
    where
      u.id is not null
    order by
      u.karma desc
    limit 10;
  EOQ
  param "story_type" {}
}
