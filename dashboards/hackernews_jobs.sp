dashboard "hackernews_job_report" {

  title = "Hacker News Jobs"
  documentation = file("./dashboards/docs/hackernews_job_report.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
  })

  container {
    width = 12

    chart {
      title = "Jobs by Days (Last 10 Days)"
      width = 4
      query = query.hackernews_jobs_by_days
    }

    chart {
      width = 4
      type = "donut"
      title = "Jobs by Role"
      query = query.hackernews_job_by_type
    }

    chart {
      width = 4
      type = "donut"
      title = "Jobs by Technology"
      query = query.hackernews_job_by_technology
    }

  }

  container {
    title = "Job Search"

    input "job_search_term" {
      width       = 4
      placeholder = "job search term (matches in URLs or titles, can be regex)"
      type        = "text"
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
      href = "https://news.ycombinator.com/user?id={{.'By'}}"
    }

  }

}

query "hackernews_jobs_by_days" {
  sql = <<-EOQ
    select
      to_char(time::timestamptz, 'YYYY-MM-DD') as day,
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
      to_char(time::timestamptz, 'YYYY-MM-DD') as "Time",
      score as "Score",
      title as "Title",
      case
        when url = '<null>' then ''
        else url
      end as "URL"
      -- TODO: Cleanup HTML in text before re-adding
      --text as "Text"
    from
      hackernews_job
    where
      title ~* $1 or url ~* $1 or text ~* $1
    order by
      score::int desc;
  EOQ

  param "job_search_term" {}
}

query "hackernews_job_by_type" {
  sql = <<-EOQ
    select
      case
        when title ~* 'data.*analyst' then 'Data Analyst'
        when title ~* 'full.*stack' then 'Full Stack Engineer'
        when title ~* 'web.*developer' then 'Web Developer'
        when title ~* 'data.*engineer' then 'Data Engineer'
        when title ~* 'front.*end' then 'Front-end Engineer'
        when title ~* 'support.*engineer' then 'Support Engineer'
        when title ~* 'machine.*learning' or title ~* '\sML' then 'Machine Learning Engineer'
        when title ~* 'software.*engineers' then 'Software Engineer'
        when title ~* 'cloud.*engineer' then 'Cloud Engineer'
        when title ilike '%designer%' then 'Designer'
        else 'Other'
       end as job_type,
      count(*)
    from
      hackernews_job
    group by
      job_type
  EOQ
}

query "hackernews_job_by_technology" {
  sql = <<-EOQ
    select
      case
        when title ~* 'php' or text ~* 'php' then 'PHP'
        when title ~* 'react' or text ~* 'react' then 'React'
        when title ~* 'python' or text ~* 'python' then 'Python'
        when title ~* 'android' or text ~* 'android' then 'Android'
        when title ~* 'java' or text ~* 'java' then 'Java'
        when title ~* 'rust' or text ~* 'rust' then 'Rust'
        when title ~* 'kubernetes' or title ~* 'K8s' or text ~* 'kubernetes' or text ~* 'K8s'then 'Kubernetes'
        when title ~* '\sjavaScript\s' or text ~* '\sjavaScript\s' then 'JavaScript'
        else 'Other'
       end as job_technology,
      count(*)
    from
      hackernews_job
    group by
      job_technology
  EOQ
}
