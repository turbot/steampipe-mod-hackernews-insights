dashboard "hackernews_sources_report" {

  title         = "Hacker News Sources Report"
  documentation = file("./dashboards/hackernews/docs/hackernews_sources_report.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
  })

  container {
    width = 6

    chart  {
      title = "Top 10 Domains by Count"
      width = 6
      type = "donut"
      query = query.hackernews_top_10_domains_by_count
    }

    chart  {
      title = "Top 10 Domains by Max Score"
      type = "donut"
      width = 6
      query = query.hackernews_top_10_domains_by_max_score
    }

    container {
      table {
        width = 12
        query = query.hackernews_domains
        column "Domain" {
          wrap = "all"
          href = "http://localhost:9194/hackernews_insights.dashboard.hackernews_sources_report?input.domain={{.'Domain'}}"
        }
      }
    }

  }


  container {
    width = 6

    container  {

      input "domain" {
        width = 6
        query =  query.hackernews_domain_input
      }

      chart {
        title = "Timeline of Hacker News Per Domain"
        query = query.hackernews_domain_detail
        args = [
          self.input.domain
        ]
      }

      table {
        title = "Domain Detail"
        args = [ self.input.domain  ]
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

}

query "hackernews_domain_input" {
  sql = <<-EOQ
    with domains as (
      select distinct
        substring(url from 'http[s]*://([^/$]+)') as domain
      from
        hackernews_new
    )
    select
      domain as label,
      domain as value
    from
      domains
    order by
      domain
  EOQ
}

query "hackernews_domains" {
  sql = <<-EOQ
    with domains as (
      select
        url,
        substring(url from 'http[s]*://([^/$]+)') as domain
    from
      hackernews_new
    where
      url != '<null>'
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
}

query "hackernews_domain_detail" {
  sql = <<-EOQ
    with items_by_day as (
      select
        to_char(time::timestamptz, 'MM-DD') as day,
        substring(url from 'http[s]*://([^/$]+)') as domain
    from
      hackernews_new
    where
      substring(url from 'http[s]*://([^/$]+)') = $1
    )
    select
      day,
      count(*)
    from
      items_by_day
    group by
      day
    order by
      day
  EOQ
  param "domain" {}
}

query "hackernews_source_detail" {
  sql = <<-EOQ
    select
      h.id as "Id",
      to_char(h.time::timestamptz, 'MM-DD hHH24') as "Time",
      h.score as "Score",
      h.url as "URL",
      ( select count(*) from hackernews_new where url = h.url ) as "URL Occurrences",
      h.title as "Title"
    from
      hackernews_new h
    where
      h.url ~ $1
    order by
      h.score::int desc
  EOQ

  param "domain" {}
}

query "hackernews_top_10_domains_by_count" {
  sql = <<-EOQ
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
}

query "hackernews_top_10_domains_by_max_score" {
  sql = <<-EOQ
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
}

