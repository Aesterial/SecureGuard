package cfgdomain

type Database struct {
	URL      string
	Name     string
	Host     string
	Port     string
	Tls      bool
	User     string
	Password string
}

type Logging struct {
	Service string
	Level   string
}

type Kafka struct {
	Enabled  bool
	Brokers  []string
	Topic    string
	ClientID string
}

type Redis struct {
	Addr     string
	Password string
	DB       int
}

type RateLimit struct {
	Enabled                bool
	Prefix                 string
	AuthorizeLimit         int
	AuthorizeWindowSeconds int
	RegisterLimit          int
	RegisterWindowSeconds  int
	MetaLimit              int
	MetaWindowSeconds      int
}

type Metadata struct {
	ServerName string
}

type Crypt struct {
	Pepper        string
	SessionLength int
}

type Boot struct {
	Port int
}

type Config struct {
	Database  Database
	Boot      Boot
	Logging   Logging
	Kafka     Kafka
	Redis     Redis
	RateLimit RateLimit
	Metadata  Metadata
	Crypt     Crypt

	Debug  bool
	Loaded bool
}

func (c *Config) MarkLoaded() {
	c.Loaded = true
}
