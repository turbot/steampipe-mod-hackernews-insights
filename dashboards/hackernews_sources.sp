dashboard "hackernews_sources" {

  title         = "Hacker News Sources"
  documentation = file("./dashboards/docs/hackernews_sources.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
  })

  container {
    width = 12

    input "story_type" {
      title = "Stories:"
      option "New" {}
      option "Top" {}
      option "Best" {}
      width  = 4
    }

  }

  container {
    width = 12

    chart {
      title = "Top 10 Domains by Count"
      width = 6
      type = "donut"
       args = [ self.input.story_type ]
      query = query.hackernews_sources_top_10_domains_by_count
    }

    chart {
      title = "Top 10 Domains by Max Score"
      type = "donut"
      width = 6
      args = [ self.input.story_type ]
      query = query.hackernews_sources_top_10_domains_by_max_score
    }

  }

  container {
    width = 12

    container {

      input "domain" {
        title = "Select a domain:"
        width = 6
        query = query.hackernews_sources_domain_input
        args  = {
          story_type = self.input.story_type.value
        }
      }

      table {
        args  = [ self.input.story_type.value, self.input.domain ]
        query = query.hackernews_sources_detail

        column "By" {
          href = "https://news.ycombinator.com/user?id={{.'By'}}"
        }
        column "ID" {
          href = "https://news.ycombinator.com/item?id={{.'Id'}}"
        }
        column "Title" {
          wrap = "all"
        }
        column "URL" {
          wrap = "all"
        }
      }

    }

  }

  container {
    table {
      width = 12
      query = query.hackernews_sources_domains
      args = [ self.input.story_type ]
      column "Domain" {
        wrap = "all"
        href = "https://{{.'Domain'}}"
      }
    }
  }

}

query "hackernews_sources_domain_input" {
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

query "hackernews_sources_domains" {
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
        avg(score) as avg_score,
        max(score) as max_score,
        avg(descendants) as avg_comments,
        max(descendants) as max_comments
      from
        hackernews_new
      --where
        --descendants is not null
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
      a.max_score as "Max Score",
      round(a.avg_score, 1) as "Avg Score",
      a.max_comments as "Max Comments",
      round(a.avg_comments, 1) as "Avg Comments"
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

query "hackernews_sources_detail" {
  sql = <<-EOQ
    with stories as (
      select * from hackernews_new where $1 = 'New'
      union
      select * from hackernews_top where $1 = 'Top'
      union
      select * from hackernews_best where $1 = 'Best'
    )
    select
      h.id as "ID",
      h.by as "By",
      to_char(h.time::timestamptz, 'YYYY-MM-DD HH24:MI:SS') as "Time",
      h.score as "Score",
      h.descendants as "Comments",
      h.title as "Title",
      h.url as "URL"
    from
      stories h
    where
      h.url ~ $2
    order by
      h.score desc
  EOQ

  param "story_type" {}
  param "domain" {}
}

query "hackernews_sources_top_10_domains_by_count" {
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

query "hackernews_sources_top_10_domains_by_max_score" {
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
      max(score) as "Max Score"
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
