# Supported tags

- `6.7.0`, `6.7`, `6`, `latest` [(6.7.0/Dockerfile)](https://github.com/adenix/docker-atlassian-confluence/blob/master/6.7.0/Dockerfile)

# Reverse Proxy Settings

If Confluence is run behind a reverse proxy server, then you need to specify extra options to make Confluence aware of the setup. They can be controlled via the below environment variables.

* `CATALINA_CONNECTOR_PROXYNAME` (default: NONE)

The reverse proxy's fully qualified hostname.

* `CATALINA_CONNECTOR_PROXYPORT` (default: NONE)

The reverse proxy's port number via which Confluence is accessed.

* `CATALINA_CONNECTOR_SCHEME` (default: http)

The protocol via which Confluence is accessed.

* `CATALINA_CONNECTOR_SECURE` (default: false)

Set 'true' if CATALINA_CONNECTOR_SCHEME is 'https'.

# SSL Settings

* `CATALINA_CONNECTOR_SSL` (default: false)

Set 'true' if specifying SSL certificates.

* `CATALINA_CONNECTOR_KEY_ALIAS` (default: tomcat)

The JKS certificate alias. Requires `CATALINA_CONNECTOR_SSL`

* `CATALINA_CONNECTOR_KEYSTORE` (default: /etc/ssl/tomcat.jks)

The JKS certificate path. Requires `CATALINA_CONNECTOR_SSL`

* `CATALINA_CONNECTOR_KEYSTORE_PASSWORD` (default: NONE)

The JKS certificate password. Requires `CATALINA_CONNECTOR_SSL`

* `CATALINA_CONNECTOR_REDIRECT` (default: false)

Set 'true' to redirect http to https. Requires `CATALINA_CONNECTOR_SSL`

* `CATALINA_CONNECTOR_REDIRECT_PORT` (default: 8443)

The port to redirect to if `CATALINA_CONNECTOR_REDIRECT` is true. Requires `CATALINA_CONNECTOR_SSL`

# Quick Reference

-	**Maintained by**:  
	[Austin Nicholas](https://adenix.me/)

- **Where to file issues:**
  [GitHub](https://github.com/adenix/docker-atlassian-confluence/issues)
