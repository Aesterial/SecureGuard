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

type Boot struct {
	Port int
}

type Config struct {
	Database Database
	Boot     Boot
	Logging  Logging
	Kafka    Kafka

	Debug  bool
	Loaded bool
}

func (c *Config) MarkLoaded() {
	c.Loaded = true
}
