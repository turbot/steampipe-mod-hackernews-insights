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

  table {
    query = query.hackernews_job_search
    column "By" {
      href = "https://news.ycombinator.com/user?id={{.'By'}}"
    }
    column "ID" {
      href = "https://news.ycombinator.com/item?id={{.'ID'}}"
    }
    column "URL" {
      wrap = "all"
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
    order by
      time desc,
      score desc;
  EOQ
}

query "hackernews_job_by_type" {
  sql = <<-EOQ
    select
      case
        when title ilike '%designer%' then 'Designer'
        when title ~* 'cloud.*engineer' then 'Cloud Engineer'
        when title ~* 'data.*analyst' then 'Data Analyst'
        when title ~* 'data.*engineer' then 'Data Engineer'
        when title ~* 'front.*end' then 'Front-end Engineer'
        when title ~* 'full.*stack' then 'Full Stack Engineer'
        when title ~* 'machine.*learning' or title ~* '\sML' then 'Machine Learning Engineer'
        when title ~* 'software.*engineer' then 'Software Engineer'
        when title ~* 'support.*engineer' then 'Support Engineer'
        when title ~* 'web.*developer' then 'Web Developer'
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
        when title ~* '\sjavaScript\s' or text ~* '\sjavaScript\s' then 'JavaScript'
        when title ~* 'android' or text ~* 'android' then 'Android'
        when title ~* 'java' or text ~* 'java' then 'Java'
        when title ~* 'kubernetes' or title ~* 'K8s' or text ~* 'kubernetes' or text ~* 'K8s'then 'Kubernetes'
        when title ~* 'php' or text ~* 'php' then 'PHP'
        when title ~* 'python' or text ~* 'python' then 'Python'
        when title ~* 'react' or text ~* 'react' then 'React'
        when title ~* 'rust' or text ~* 'rust' then 'Rust'
        when title ~* 'sql' or text ~* 'sql' then 'SQL'
        else 'Other'
       end as job_technology,
      count(*)
    from
      hackernews_job
    group by
      job_technology
  EOQ
}
