dashboard "hackernews_sources" {

  title         = "Hacker News Sources"
  documentation = file("./dashboards/hackernews/docs/hackernews_sources.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
  })

  container {
    width = 12

    container {

      input "story_type" {
        title = "Stories:"
        option "New" {}
        option "Top" {}
        option "Best" {}
        width  = 4
      }

      input "domain" {
        title = "Select a domain:"
        width = 6
        query = query.hackernews_domain_input
        args  = {
          story_type = self.input.story_type.value
        }
      }

      table {
        args = [ self.input.story_type.value, self.input.domain ]
        query = query.hackernews_source_detail
        column "Id" {
          href = "https://news.ycombinator.com/item?id={{.'Id'}}"
        }
        column "URL" {
          wrap = "all"
        }
        column "Title" {
          wrap = "all"
        }
      }

    }

  }

  container {
    width = 12

    chart {
      title = "Top 10 Domains by Count"
      width = 6
      type = "donut"
       args = [ self.input.story_type ]
      query = query.hackernews_top_10_domains_by_count
    }

    chart {
      title = "Top 10 Domains by Max Score"
      type = "donut"
      width = 6
      args = [ self.input.story_type ]
      query = query.hackernews_top_10_domains_by_max_score
    }

  }

  container {
    table {
      width = 12
      query = query.hackernews_domains
      args = [ self.input.story_type ]
      column "Domain" {
        wrap = "all"
        href = "http://localhost:9194/hackernews_insights.dashboard.hackernews_sources_report?input.domain={{.'Domain'}}"
      }
    }
  }

}

query "hackernews_domain_input" {
  sql = <<-EOQ
    with domains as (
      select distinct
        substring(url from 'http[s]*://([^/$]+)') as domain
      from
        hackernews_new where $1 = 'New'
      union
      select distinct
        substring(url from 'http[s]*://([^/$]+)') as domain
      from
        hackernews_top where $1 = 'Top'
      union
      select distinct
        substring(url from 'http[s]*://([^/$]+)') as domain
      from
        hackernews_best where $1 = 'Best'
    )
    select
      domain as label,
      domain as value
    from
      domains
    order by
      domain
  EOQ
  param "story_type" {}
}

query "hackernews_domains" {
  sql = <<-EOQ
    with domains as (
      select
        url,
        substring(url from 'http[s]*://([^/$]+)') as domain
      from
        hackernews_new where $1 = 'New' and url != '<null>'
      union
      select
        url,
        substring(url from 'http[s]*://([^/$]+)') as domain
      from
        hackernews_top where $1 = 'Top' and url != '<null>'
      union
      select
        url,
        substring(url from 'http[s]*://([^/$]+)') as domain
      from
        hackernews_best where $1 = 'Best' and url != '<null>'
    ),
    avg_and_max as (
      select
        substring(url from 'http[s]*://([^/$]+)') as domain,
        avg(score::int) as avg_score,
        max(score::int) as max_score,
        avg(descendants::int) as avg_comments,
        max(descendants::int) as max_comments
      from
        hackernews_new
      where
        descendants is not null
      group by
        substring(url from 'http[s]*://([^/$]+)')
    ),
    counted as (
      select
        domain,
        count(*)
      from
        domains
      group by
        domain
      order by
        count desc
    )
    select
      a.domain as "Domain",
      c.count as "Count",
      a.max_score as "Max_Score",
      round(a.avg_score, 1) as "Avg_Score",
      a.max_comments as "Max_Comments",
      round(a.avg_comments, 1) as "Avg_Comments"
    from
      avg_and_max a
    join
      counted c
    using
      (domain)
    order by
      count desc
  EOQ
  param "story_type" {}
}

query "hackernews_source_detail" {
  sql = <<-EOQ
    with stories as (
      select * from hackernews_new where $1 = 'New'
      union
      select * from hackernews_top where $1 = 'Top'
      union
      select * from hackernews_best where $1 = 'Best'
    )
    select
      h.id as "Id",
      -- to_char(h.time::timestamptz, 'MM-DD hHH24') as "Time",
      h.time as "Time",
      h.score as "Score",
      h.url as "URL",
      h.title as "Title"
    from
      stories h
    where
      h.url ~ $2
    order by
      h.score::int desc
  EOQ

  param "story_type" {}
  param "domain" {}
}

query "hackernews_top_10_domains_by_count" {
  sql = <<-EOQ
    with stories as (
      select * from hackernews_new where $1 = 'New'
      union
      select * from hackernews_top where $1 = 'Top'
      union
      select * from hackernews_best where $1 = 'Best'
    )
    select
      substring(url from 'http[s]*://([^/$]+)') as "Domain",
      count(*)
    from
      hackernews_new
    where
      url != ''
    group by
      "Domain"
    order by
      count desc
    limit
      10
  EOQ
  param "story_type" {}
}

query "hackernews_top_10_domains_by_max_score" {
  sql = <<-EOQ
    with stories as (
      select * from hackernews_new where $1 = 'New'
      union
      select * from hackernews_top where $1 = 'Top'
      union
      select * from hackernews_best where $1 = 'Best'
    )
    select
      substring(url from 'http[s]*://([^/$]+)') as "Domain",
      max(score::int) as "Max Score"
    from
      hackernews_new
    where
      url != ''
    group by
      "Domain"
    order by
      "Max Score" desc
    limit
      10
  EOQ
  param "story_type" {}
}