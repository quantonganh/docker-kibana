#!bin/bash

CONF="/opt/kibana-$KIBANA_VERSION-linux-x86_64/config/kibana.yml"

sed -ri "s|elasticsearch.url:[^\r\n]*|elasticsearch.url: https://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT|" "$CONF"
sed -i "s;.*server\.host:.*;server\.host: ${KIBANA_HOST};" "$CONF"

sed -ri "s|elasticsearch.password:[^\r\n]*|elasticsearch.password: $KIBANA_PWD|" "$CONF"
sed -ri "s|elasticsearch.ssl.verify:[^\r\n]*|elasticsearch.ssl.verify: true|" "$CONF"
sed -ri "s|elasticsearch.ssl.ca:[^\r\n]*|elasticsearch.ssl.ca: /etc/elasticsearch/searchguard/ssl/ca/root-ca.pem|" "$CONF"
