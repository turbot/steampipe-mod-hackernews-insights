dashboard "hackernews_job_report" {

  title = "Hacker News Job Report"
  documentation = file("./dashboards/hackernews/docs/hackernews_job_report.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
  })

  container {
    width = 12

    chart  {
      title = "Jobs By Days (Last 10 days)"
      width = 6
      query = query.hackernews_jobs_by_days
    }

  }

  container  {
    title = "Job Search"

    input "job_search_term" {
      width = 4
      placeholder = "job_search_term (matches in urls or titles, can be regex)"
      type = "text"
    }

  }

  table {
    args = [
      self.input.job_search_term
    ]
    query = query.hackernews_job_search
    column "ID" {
      href = "https://news.ycombinator.com/item?id={{.'ID'}}"
    }
    column "By" {
      href = "http://localhost:9194/hackernews_insights.dashboard.hackernews_people_report?input.hn_user={{.'By'}}"
    }

  }

}

query "hackernews_jobs_by_days" {
  sql = <<-EOQ
    select
      to_char(time::timestamptz, 'MM-DD') as day,
      count(*)
    from
      hackernews_job
    where
      time::timestamptz > now() - interval '10 day'
    group by
      day
    order by
      day;
  EOQ
}

query "hackernews_job_search" {
  sql = <<-EOQ
    select
      id as "ID",
      by as "By",
      title as "Title",
      to_char(time::timestamptz, 'MM-DD hHH24') as "Time",
      case
        when url = '<null>' then ''
        else url
      end as "URL",
      score,
      descendants as "Comments",
      text as "Text"
    from
      hackernews_job
    where
      title ~* $1 or url ~* $1 or text ~* $1
    order by
      score::int desc;
  EOQ

  param "job_search_term" {}
}