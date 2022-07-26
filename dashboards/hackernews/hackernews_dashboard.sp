dashboard "hackernews_dashboard" {

  title         = "Hacker News Dashboard"
  documentation = file("./dashboards/hackernews/docs/hackernews_dashboard.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Dashboard"
  })


  container {
    # Analysis
    card {
      query = query.hackernews_stories_count
      width = 2
    }

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
    }

    card {
      width = 2
      query = query.hackernews_avg_score
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
      title = "Users Posts (> 50)"
      query = query.hackernews_user_with_greater_than_50_post
      type  = "column"
      width = 6
    }

    chart {
      title = "Users Score (> 50)"
      query = query.hackernews_user_with_greater_than_50_score
      type  = "column"
      width = 6
    }
  }

  container {

    chart {
      width = 6
      title = "Stories by Hour (Last 14 Days)"
      query = query.hackernews_stories_by_hour_last_14_days
    }

    chart {
      width = 6
      title = "Ask and Show by Hour (Last 14 Days)"
      query = query.hackernews_ask_and_show_by_hou_last_14_days
    }

  }

  container {

    chart {
      base = chart.companies_base
      width = 4
      type = "donut"
      title = "Company Mentions: Last 4 Hours"
      query = query.mentions
      args = [ local.companies, 240, 0 ]
    }

    chart {
      base = chart.companies_base
      width = 4
      type = "donut"
      title = "Company Mentions: Last 24 Hours"
      query = query.mentions
      args = [ local.companies, 1440, 0 ]
    }

    chart {
      base = chart.companies_base
      width = 4
      type = "donut"
      title = "Company Mentions: Last 14 Days"
      query = query.mentions
      args = [ local.companies, 20160, 0 ]
    }
  }

   container {

    chart {
      base = chart.languages_base
      width = 4
      type = "donut"
      title = "Language Mentions: Last 4 Hours"
      query = query.mentions
      args = [ local.languages, 240, 0 ]
    }

    chart {
      base = chart.languages_base
      width = 4
      type = "donut"
      title = "Language Mentions: Last 24 Hours"
      query = query.mentions
      args = [ local.languages, 1440, 0 ]
    }

    chart {
      base = chart.languages_base
      width = 4
      type = "donut"
      title = "Language Mentions: Last 14 Days"
      query = query.mentions
      args = [ local.languages, 20160, 0 ]
    }

  }

  container {

    chart {
      base = chart.os_base
      width = 4
      type = "donut"
      title = "OS Mentions: Last 4 Hours"
      query = query.mentions
      args = [ local.operating_systems, 240, 0 ]
    }

    chart {
      base = chart.os_base
      width = 4
      type = "donut"
      title = "OS Mentions: Last 24 Hours"
      query = query.mentions
      args = [ local.operating_systems, 1440, 0 ]
    }

    chart {
      base = chart.os_base
      width = 4
      type = "donut"
      title = "OS Mentions: Last 14 Days"
      query = query.mentions
      args = [ local.operating_systems, 20160, 0 ]
    }

  }

  container {

    chart {
      base = chart.cloud_base
      width = 4
      type = "donut"
      title = "Cloud Mentions: Last 4 Hours"
      query = query.mentions
      args = [ local.clouds, 240, 0 ]
    }

    chart {
      base = chart.cloud_base
      width = 4
      type = "donut"
      title = "Cloud Mentions: Last 24 Hours"
      query = query.mentions
      args = [ local.clouds, 1440, 0 ]
    }

    chart {
      base = chart.cloud_base
      width = 4
      type = "donut"
      title = "Cloud Mentions: Last 14 Days"
      query = query.mentions
      args = [ local.clouds, 20160, 0 ]
    }

  }

  container {

    chart {
      base = chart.db_base
      width = 4
      type = "donut"
      title = "DB Mentions: Last 4 Hours"
      query = query.mentions
      args = [ local.dbs, 240, 0 ]
    }

    chart {
      base = chart.db_base
      width = 4
      type = "donut"
      title = "DB Mentions: Last 24 Hours"
      query = query.mentions
      args = [ local.dbs, 1440, 0 ]
    }

    chart {
      base = chart.db_base
      width = 4
      type = "donut"
      title = "DB mentions: Last 14 Days"
      query = query.mentions
      args = [ local.dbs, 20160, 0 ]
    }

  }

}

# Card Queries

query "hackernews_stories_count" {
  sql = <<-EOQ
    select
      count(*) as "Stories"
    from
      hackernews_new
  EOQ
}

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
    select max(score::int) as "Max Score" from hackernews_new
  EOQ
}

query "hackernews_avg_score" {
  sql = <<-EOQ
    select
      round(avg(score::int), 1) as "Avg Score"
    from hackernews_new
  EOQ
}

query "hackernews_avg_ask_score" {
  sql = <<-EOQ
    select
      round(avg(score::int), 1) as "Avg Ask Score"
    from
      hackernews_ask_hn
  EOQ
}

query "hackernews_avg_show_score" {
  sql = <<-EOQ
    select
      round(avg(score::int), 1) as "Avg Show Score"
    from
      hackernews_show_hn
  EOQ
}

# Analysis Queries

query "hackernews_user_with_greater_than_50_post" {
  sql = <<-EOQ
    with data as (
      select
        by,
        count(*) as posts
      from
        hackernews_new
      group by
        by
      order by
        posts desc
    )
    select
      *
    from
      data
    where
      posts > 50
    limit
      25
  EOQ
}

query "hackernews_user_with_greater_than_50_score" {
  sql = <<-EOQ
    select
      by,
      max(score::int) as max_score
    from
      hackernews_new
    where
      score::int > 50
    group by
      by
    order by
      max_score desc
    limit
      25
  EOQ
}

query "hackernews_stories_by_hour_last_14_days" {
  sql = <<-EOQ
    with data as (
      select
        time::timestamptz
      from
        hackernews_new
      where
        time::timestamptz > now() - interval '14 day'
    )
    select
      to_char(time,'MM:DD HH24') as hour,
      count(*)
    from
      data
    group by
      hour
    order by
      hour
  EOQ
}

query "hackernews_ask_and_show_by_hou_last_14_days" {
  sql = <<-EOQ
    with ask_hn as (
      select
        to_char(time::timestamptz,'MM:DD HH24') as hour
      from
        hackernews_new
      where
        time::timestamptz > now() - interval '14 day'
        and title ~ '^Ask HN:'
    ),
    show_hn as (
      select
        to_char(time::timestamptz,'MM:DD HH24') as hour
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
    with names as (
      select
        unnest( $1::text[] ) as name
    ),
    counts as (
      select
        name,
        (
          select
            count(*)
          from
            hackernews_new
          where
            title ~* name
            and (extract(epoch from now() - time::timestamptz) / 60)::int between symmetric $2 and $3
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
  param "names" {}
  param "min_minutes_ago" {}
  param "max_minutes_ago" {}
}

