locals {
  companies = [
    "Amazon",
    "AMD",
    "Apple",
    "CloudFlare",
    "Facebook",
    "GitLab",
    "Google",
    "IBM",
    "Intel ",
    "Microsoft",
    "Mozilla",
    "Netflix",
    "OpenAI",
    "Tesla",
    "TikTok",
    "Toshiba",
    "Twitter",
    "Sony",
    "SpaceX",
    "Stripe",
    "Uber",
    "Zendesk"
  ]

  languages = [
    "C#",
    "C\\+\\+",
    "Clojure",
    "CSS",
    "Erlang",
    "golang| go 1.| (in|with|using) go | go (.+)(compiler|template|monorepo|generic|interface|library|framework|garbage|module|range|source)",
    "Haskell",
    "HTML",
    "Java ",
    "JavaScript",
    "JSON",
    "PHP",
    "Python",
    "Rust ",
    "Scala ",
    "SQL",
    "Swift",
    "TypeScript",
    "WebAssembly|WASM",
    "XML"
  ]

  operating_systems = [
    "Android",
    "iOS",
    "Linux",
    "macOS| mac os ( *)x",
    "Windows"
  ]

  clouds = [
    "AWS",
    "Azure",
    "Google Cloud|GCP",
    "Oracle Cloud"
  ]

  dbs = [
    "DB2",
    "Citus",
    "CouchDB",
    "MongoDB",
    "MySQL|MariaDB",
    "Oracle",
    "Postgres",
    "Redis",
    "SQL Server",
    "Timescale",
    "SQLite",
    "Steampipe",
    "Supabase",
    "Yugabyte"
  ]

  editors = [
    " emacs ",
    " sublime ",
    "vscode| vs code |visual studio code",
    " vim "
  ]

}
