#!/bin/bash
set -euo pipefail

# Setup Catalina Opts
: ${CATALINA_CONNECTOR_PROXYNAME:=}
: ${CATALINA_CONNECTOR_PROXYPORT:=}
: ${CATALINA_CONNECTOR_SCHEME:=http}
: ${CATALINA_CONNECTOR_SECURE:=false}
: ${CATALINA_CONNECTOR_SSL:=false}
: ${CATALINA_CONNECTOR_REDIRECT:=false}
: ${CATALINA_CONNECTOR_REDIRECT_PORT:=8443}
: ${CATALINA_CONNECTOR_KEY_ALIAS:=tomcat}
: ${CATALINA_CONNECTOR_KEYSTORE:=/etc/ssl/tomcat.jks}
: ${CATALINA_CONNECTOR_KEYSTORE_PASSWORD:=}

: ${CATALINA_OPTS:=}

CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyName=${CATALINA_CONNECTOR_PROXYNAME}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyPort=${CATALINA_CONNECTOR_PROXYPORT}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorScheme=${CATALINA_CONNECTOR_SCHEME}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorSecure=${CATALINA_CONNECTOR_SECURE}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorRedirectPort=${CATALINA_CONNECTOR_REDIRECT_PORT}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorKeyAlias=${CATALINA_CONNECTOR_KEY_ALIAS}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorKeystore=${CATALINA_CONNECTOR_KEYSTORE}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorKeystorePassword=${CATALINA_CONNECTOR_KEYSTORE_PASSWORD}"

export CATALINA_OPTS

# Uncomment SSL connector in server.xml
if [ "${CATALINA_CONNECTOR_SSL}" = "true" ]; then
  sed -i -e 's/<!--SSL//' ${CONFLUENCE_INSTALL}/conf/server.xml
  sed -i -e 's/SSL-->//' ${CONFLUENCE_INSTALL}/conf/server.xml

  # Add redirect security constraints to web.xml
  if [ "${CATALINA_CONNECTOR_REDIRECT}" = "true" ]; then
    sed -i -e 's/<\/web-app>/<security-constraint><web-resource-collection><web-resource-name>Restricted URLs<\/web-resource-name><url-pattern>\/<\/url-pattern><\/web-resource-collection><user-data-constraint><transport-guarantee>CONFIDENTIAL<\/transport-guarantee><\/user-data-constraint><\/security-constraint><\/web-app>/' ${CONFLUENCE_INSTALL}/confluence/WEB-INF/web.xml
  fi
fi

# Start Confluence as the correct user
if [ "${UID}" -eq 0 ]; then
  echo "User is currently root. Will change directory ownership to ${RUN_USER}:${RUN_GROUP}, then downgrade permission to ${RUN_USER}"
  PERMISSIONS_SIGNATURE=$(stat -c "%u:%U:%a" "${CONFLUENCE_HOME}")
  EXPECTED_PERMISSIONS=$(id -u ${RUN_USER}):${RUN_USER}:700
  if [ "${PERMISSIONS_SIGNATURE}" != "${EXPECTED_PERMISSIONS}" ]; then
    chmod -R 700 "${CONFLUENCE_HOME}" &&
    chown -R "${RUN_USER}:${RUN_GROUP}" "${CONFLUENCE_HOME}"
  fi
  # Now drop privileges
  exec su -s /bin/bash "${RUN_USER}" -c "$CONFLUENCE_INSTALL/bin/start-confluence.sh $@"
else
  exec "$CONFLUENCE_INSTALL/bin/start-confluence.sh" "-Datlassian.dev.mode=true" "$@"
fi
