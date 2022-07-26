dashboard "hackernews_top_rated_stories_report" {

  title         = "Hacker News Top Rated Stories Report"
  documentation = file("./dashboards/hackernews/docs/hackernews_top_rated_stories_report.md")

  tags = merge(local.hackernews_common_tags, {
    type = "Report"
  })


  table {
    query = query.hackernews_top_stories_report_table
    column "ID" {
      href = "https://news.ycombinator.com/item?id={{.'ID'}}"
    }

    column "By" {
      href = "http://localhost:9194/hackernews_insights.dashboard.hackernews_user_submissions?input.hn_user={{.'By'}}"
    }
  }

}

# Assessments Queries

query "hackernews_top_stories_report_table" {
  sql = <<-EOQ
    select
      id as "ID",
      by as "By",
      to_char(time::timestamptz, 'MM-DD hHH24') as time,
      now()::date - time::date  as "Age in Days",
      title as "Title",
      score::int as "Score",
      descendants::int as comments,
      dead as "Dead",
      deleted as "Deleted",
      url as "URL"
    from
      hackernews_new
    where
      score is not null
      and descendants is not null
    order by
      score desc,
      descendants desc;

  EOQ

}

