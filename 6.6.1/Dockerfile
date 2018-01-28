FROM openjdk:8

ARG CONFLUENCE_VERSION=6.6.1

ENV CONFLUENCE_HOME='/var/atlassian/confluence'
ENV CONFLUENCE_INSTALL='/opt/atlassian/confluence'

RUN \
  set -x && \
  echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list && \
  apt-get update --quiet && \
  apt-get install --quiet --yes --no-install-recommends xmlstarlet && \
  apt-get install --quiet --yes --no-install-recommends -t jessie-backports libtcnative-1 && \
  mkdir -p                "${CONFLUENCE_HOME}" && \
  mkdir -p                "${CONFLUENCE_HOME}/caches/indexes" && \
  chmod -R 700            "${CONFLUENCE_HOME}" && \
  mkdir -p                "${CONFLUENCE_INSTALL}/conf/Catalina &&" && \
  curl -Ls                "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz" | tar -xz --directory "${CONFLUENCE_INSTALL}" --strip-components=1 --no-same-owner && \
  curl -Ls                "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz" | tar -xz --directory "${CONFLUENCE_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar" && \
  curl -Ls                "https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar" -o "${CONFLUENCE_INSTALL}/lib/postgresql-9.4.1212.jar" && \
  rm -f                   "${CONFLUENCE_INSTALL}/lib/postgresql-9.1-903.jdbc4-atlassian-hosted.jar" && \
  apt-get remove --purge --quiet --yes curl && \
  apt-get autoremove --quiet --yes && \
  apt-get clean

RUN \
  chmod -R 700            "${CONFLUENCE_INSTALL}/conf" && \
  chmod -R 700            "${CONFLUENCE_INSTALL}/logs" && \
  chmod -R 700            "${CONFLUENCE_INSTALL}/temp" && \
  chmod -R 700            "${CONFLUENCE_INSTALL}/work" && \
  chown -R daemon:daemon  "${CONFLUENCE_INSTALL}/conf" && \
  chown -R daemon:daemon  "${CONFLUENCE_INSTALL}/logs" && \
  chown -R daemon:daemon  "${CONFLUENCE_INSTALL}/temp" && \
  chown -R daemon:daemon  "${CONFLUENCE_INSTALL}/work" && \
  # sed --in-place          "s/java version/openjdk version/g" "${CONFLUENCE_INSTALL}/bin/check-java.sh" && \
  echo -e                 "\nconfluence.home=$CONFLUENCE_HOME" >> "${CONFLUENCE_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties" && \
  touch -d "@0"           "${CONFLUENCE_INSTALL}/conf/server.xml"

EXPOSE 8090

VOLUME ["${CONFLUENCE_HOME}", "${CONFLUENCE_INSTALL}/logs"]

WORKDIR $CONFLUENCE_HOME

COPY "docker-entrypoint.sh" "/docker-entrypoint.sh"
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/opt/atlassian/confluence/bin/catalina.sh", "run"]

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
# https://github.com/adenix/docker-confluence/issues
