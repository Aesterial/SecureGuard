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

type Boot struct {
	Port int
}

type Config struct {
	Database Database
	Boot     Boot

	loaded bool
}

func (c *Config) IsLoaded() bool {
	return c.loaded == true
}

func (c *Config) MarkLoaded() {
	c.loaded = true
}