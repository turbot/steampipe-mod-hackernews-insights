dashboard "hackernews_dashboard" {

  title         = "Hacker News Dashboard"
  documentation = file("./dashboards/docs/hackernews_dashboard.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Dashboard"
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
    card {
      query = query.hackernews_ask_count
      width = 2
    }

    card {
      query = query.hackernews_show_count
      width = 2
    }

    # Assessments
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
      query = query.hackernews_avg_ask_score
    }

    card {
      width = 2
      query = query.hackernews_avg_show_score
    }

  }

  container {

    title = "Analysis"

    chart {
      title = "Users Posts (> 5)"
      query = query.hackernews_user_with_greater_than_5_post
      type  = "column"
      args  = [
        self.input.story_type
      ]
      width = 6
    }

    chart {
      title = "Users Score (> 50)"
      query = query.hackernews_user_with_greater_than_50_score
      type  = "column"
      args  = [
        self.input.story_type
      ]
      width = 6
    }
  }

  container {

    chart {
      width = 6
      title = "Stories by Hour"
      query = query.hackernews_stories_by_hour
      args  = [
        self.input.story_type
      ]
    }

    chart {
      width = 6
      title = "Asks and Shows by Hour"
      query = query.hackernews_ask_and_show_by_hour
    }

  }

  container {

    chart {
      base = chart.companies_base
      width = 4
      type = "donut"
      title = "Company Mentions: Last 4 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.companies, 240, 0 ]
    }

    chart {
      base = chart.companies_base
      width = 4
      type = "donut"
      title = "Company Mentions: Last 24 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.companies, 1440, 0 ]
    }

    chart {
      base = chart.companies_base
      width = 4
      type = "donut"
      title = "Company Mentions: Last 2 Days"
      query = query.mentions
      args = [ self.input.story_type, local.companies, 2880, 0 ]
    }
  }

   container {

    chart {
      base = chart.languages_base
      width = 4
      type = "donut"
      title = "Language Mentions: Last 4 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.languages, 240, 0 ]
    }

    chart {
      base = chart.languages_base
      width = 4
      type = "donut"
      title = "Language Mentions: Last 24 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.languages, 1440, 0 ]
    }

    chart {
      base = chart.languages_base
      width = 4
      type = "donut"
      title = "Language Mentions: Last 2 Days"
      query = query.mentions
      args = [ self.input.story_type, local.languages, 2880, 0 ]
    }

  }

  container {

    chart {
      base = chart.os_base
      width = 4
      type = "donut"
      title = "OS Mentions: Last 4 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.operating_systems, 240, 0 ]
    }

    chart {
      base = chart.os_base
      width = 4
      type = "donut"
      title = "OS Mentions: Last 24 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.operating_systems, 1440, 0 ]
    }

    chart {
      base = chart.os_base
      width = 4
      type = "donut"
      title = "OS Mentions: Last 2 Days"
      query = query.mentions
      args = [ self.input.story_type, local.operating_systems, 2880, 0 ]
    }

  }

  container {

    chart {
      base = chart.cloud_base
      width = 4
      type = "donut"
      title = "Cloud Mentions: Last 4 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.clouds, 240, 0 ]
    }

    chart {
      base = chart.cloud_base
      width = 4
      type = "donut"
      title = "Cloud Mentions: Last 24 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.clouds, 1440, 0 ]
    }

    chart {
      base = chart.cloud_base
      width = 4
      type = "donut"
      title = "Cloud Mentions: Last 2 Days"
      query = query.mentions
      args = [ self.input.story_type, local.clouds, 2880, 0 ]
    }

  }

  container {

    chart {
      base = chart.db_base
      width = 4
      type = "donut"
      title = "DB Mentions: Last 4 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.dbs, 240, 0 ]
    }

    chart {
      base = chart.db_base
      width = 4
      type = "donut"
      title = "DB Mentions: Last 24 Hours"
      query = query.mentions
      args = [ self.input.story_type, local.dbs, 1440, 0 ]
    }

    chart {
      base = chart.db_base
      width = 4
      type = "donut"
      title = "DB mentions: Last 2 Days"
      query = query.mentions
      args = [ self.input.story_type, local.dbs, 2880, 0 ]
    }

  }

}

# Card Queries

query "hackernews_ask_count" {
  sql = <<-EOQ
    select
      count(*) as "Ask HN" from hackernews_ask_hn
  EOQ
}

query "hackernews_show_count" {
  sql = <<-EOQ
    select
      count(*) as "Show HN" from hackernews_show_hn
  EOQ
}

# Assessments Queries

query "hackernews_max_score" {
  sql = <<-EOQ
  with stories as (
    select * from hackernews_new where $1 = 'New'
    union
    select * from hackernews_top where $1 = 'Top'
    union
    select * from hackernews_best where $1 = 'Best'
    )
    select max(score) as "Max Score" from stories
  EOQ
  param "story_type" {}
}

query "hackernews_avg_score" {
  sql = <<-EOQ
    with stories as (
      select * from hackernews_new where $1 = 'New'
      union
      select * from hackernews_top where $1 = 'Top'
      union
      select * from hackernews_best where $1 = 'Best'
    )
    select
      round(avg(score), 1) as "Avg Score"
    from hackernews_new
  EOQ
  param "story_type" {}
}

query "hackernews_avg_ask_score" {
  sql = <<-EOQ
    select
      round(avg(score), 1) as "Avg Ask Score"
    from
      hackernews_ask_hn
  EOQ
}

query "hackernews_avg_show_score" {
  sql = <<-EOQ
    select
      round(avg(score), 1) as "Avg Show Score"
    from
      hackernews_show_hn
  EOQ
}

# Analysis Queries

query "hackernews_user_with_greater_than_5_post" {
  sql = <<-EOQ
    with data as (
      (select
      by,
      count(*) as posts
      from
        hackernews_new where $1 = 'New'
      group by
        by
      order by
        posts desc)
      union
      (select
        by,
      count(*) as posts
      from
        hackernews_top where $1 = 'Top'
      group by
        by
      order by
        posts desc)
      union
      (select
        by,
      count(*) as posts
      from
        hackernews_best where $1 = 'Best'
      group by
        by
      order by
        posts desc)
    )
    select
      *
    from
      data
    where
      posts > 5
    limit
      25
  EOQ
  param "story_type" {}
}

query "hackernews_user_with_greater_than_50_score" {
  sql = <<-EOQ
    with stories as (
      select * from hackernews_new where $1 = 'New'
      union
      select * from hackernews_top where $1 = 'Top'
      union
      select * from hackernews_best where $1 = 'Best'
    )
    select
      by,
      max(score) as max_score
    from
      stories
    where
      score > 50
    group by
      by
    order by
      max_score desc
    limit
      25
  EOQ
  param "story_type" {}
}

query "hackernews_stories_by_hour" {
  sql = <<-EOQ
    with data as (
      (select * from hackernews_new where $1 = 'New')
      union
      (select * from hackernews_top where $1 = 'Top')
      union
      (select * from hackernews_best where $1 = 'Best')
    )
    select
      to_char(time,'MM-DD HH24:00') as hour,
      count(*)
    from
      data
    group by
      hour
    order by
      hour;
  EOQ
  param "story_type" {}
}

query "hackernews_ask_and_show_by_hour" {
  sql = <<-EOQ
    with ask_hn as (
      select
        to_char(time::timestamptz,'MM-DD HH24:00') as hour
      from
        hackernews_new
      where
        time::timestamptz > now() - interval '14 day'
        and title ~ '^Ask HN:'
    ),
    show_hn as (
      select
        to_char(time::timestamptz,'MM-DD HH24:00') as hour
      from
        hackernews_new
      where
        time::timestamptz > now() - interval '14 day'
        and title ~ '^Show HN:'
    )
    select
      hour,
      count(a.*) as "Ask HN",
      count(s.*) as "Show HN"
    from
      ask_hn a
    left join
      show_hn s
    using
      (hour)
    group by
      hour
    order by
      hour
  EOQ
}

query "mentions" {
  sql = <<-EOQ
    with data as (
      (select * from hackernews_new where $1 = 'New')
      union
      (select * from hackernews_top where $1 = 'Top')
      union
      (select * from hackernews_best where $1 = 'Best')
    ),
     names as (
      select
        unnest( $2::text[] ) as name
    ),
    counts as (
      select
        name,
        (
          select
            count(*)
          from
            data
          where
            title ~* name
            and (extract(epoch from now() - time::timestamptz) / 60)::int between symmetric $3 and $4
        ) as mentions
        from
          names
    )
    select
      replace(name, '\', '') as name,
      mentions
    from
      counts
    where
      mentions > 0
    order by
      mentions desc
  EOQ
  param "story_type" {}
  param "names" {}
  param "min_minutes_ago" {}
  param "max_minutes_ago" {}
}
