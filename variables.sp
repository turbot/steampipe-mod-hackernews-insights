locals {
  companies = [
    "Amazon",
    "AMD",
    "Apple",
    "CloudFlare",
    "Facebook",
    "Google",
    "Intel ",
    "Microsoft",
    "Netflix",
    "Tesla",
    "Toshiba",
    "Twitter",
    "SpaceX",
    "Sony",
    "Stripe"
  ]

  languages = [
    "C#",
    "C\\+\\+",
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
    "macOS",
    "Windows"
  ]

  clouds = [
    "AWS",
    "Azure",
    "Google Cloud|GCP"
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
}
