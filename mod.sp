mod "hackernews_insights" {
  # hub metadata
  title         = "Hacker News Insights"
  description   = "Create dashboards and reports for Hacker News using Steampipe."
  color         = "#FF6600"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/hackernews-insights.svg"
  categories    = ["hackernews", "dashboard"]

  opengraph {
    title       = "Steampipe Mod for Hacker News Insights"
    description = "Create dashboards and reports for Hacker News using Steampipe."
    image       = "/images/mods/turbot/hackernews-insights-social-graphic.png"
  }

  require {
    plugin "hackernews" {
      min_version = "0.4.0"
    }
  }
}

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

# https://steampipe.io/docs/reference/mod-resources/dashboard#color
chart "hackernews_dashboard_mentions_companies_base" {
  series "mentions" {
    point "Amazon" {
      color = "Purple"
    }
    point "AMD" {
      color = "SandyBrown"
    }
    point "Apple" {
      color = "Crimson"
    }
    point "CloudFlare" {
      color = "Brown"
    }
    point "Facebook" {
      color = "RoyalBlue"
    }
    point "Google" {
      color = "SeaGreen"
    }
    point "Intel" {
      color = "Wheat"
    }
    point "Microsoft" {
      color = "Blue"
    }
    point "Netflix" {
      color = "DarkRed"
    }
    point "Tesla" {
      color = "Gray"
    }
    point "Toshiba" {
      color = "Goldenrod"
    }
    point "Twitter" {
      color = "PaleTurquoise"
    }
    point "Sony" {
      color = "Gold"
    }
    point "SpaceX" {
      color = "Black"
    }
    point "Stripe" {
      color = "SaddleBrown"
    }
  }
}

chart "hackernews_dashboard_mentions_languages_base" {
  series "mentions" {
    point "C#" {
      color = "#823085"
    }
    point "C++" {
      color = "orange"
    }
    point "CSS" {
      color = "pink"
    }
    point "Erlang" {
      color = "DarkSalmon"
    }
    point "golang" {
      color = "#4B8BBE"
    }
    point "Haskell" {
      color = "rgb(94,80,134)"
    }
    point "HTML" {
      color = "GoldenRod"
    }
    point "Java " {
      color = "#f89820"
    }
    point "JavaScript" {
      color = "#F0DB4F"
    }
    point "JSON" {
      color = "DarkSalmon"
    }
    point "PHP" {
      color = "beige"
    }
    point "Python" {
      color = "#4B8BBE"
    }
    point "Rust " {
      color = "black"
    }
    point "Scala " {
      color = "Coral"
    }
    point "SQL" {
      color = "ForestGreen"
    }
    point "Swift" {
      color = "#F05138"
    }
    point "TypeScript" {
      color = "purple"
    }
    point "WebAssembly|WASM" {
      color = "#6856E7"
    }
    point "XML" {
      color = "DarkSeaGreen"
    }
  }
}

chart "hackernews_dashboard_mentions_os_base" {
  series "mentions" {
    point "Android" {
      color = "green"
    }
    point "iOS" {
      color = "crimson"
    }
    point "macOS" {
      color = "red"
    }
    point "Windows" {
      color = "blue"
    }
    point "Linux" {
      color = "gray"
    }
  }
}

chart "hackernews_dashboard_mentions_clouds_base" {
  series "mentions" {
    point "AWS" {
      color = "brown"
    }
    point "Azure" {
      color = "blue"
    }
    point "Google Cloud|GCP" {
      color = "#F4B400"
    }
  }
}

chart "hackernews_dashboard_mentions_dbs_base" {
  series "mentions" {
    point "DB2" {
      color = "brown"
    }
    point "Citus" {
      color = "green"
    }
    point "MongoDB" {
      color = "gray"
    }
    point "MySQL|MariaDB" {
      color = "orange"
    }
    point "Oracle" {
      color = "red"
    }
    point "Postgres" {
      color = "lightblue"
    }
    point "Steampipe" {
      color = "black"
    }
    point "Supabase" {
      color = "yellow"
    }
    point "Timescale" {
      color = "purple"
    }
    point "Scala" {
      color = "DarkCyan"
    }
    point "SQLite" {
      color = "blue"
    }
    point "Yugabyte" {
      color = "lightgreen"
    }

  }
}

