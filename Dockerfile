FROM alpine:3.6

ENV KIBANA_VERSION 6.0.0
ENV SG_VERSION 6.beta1

RUN apk --update add bash curl wget && \
	# Kibana
    mkdir /opt && \
    curl -s https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar zx -C /opt && \
    apk add nodejs && \
    rm -rf /opt/kibana-${KIBANA_VERSION}-linux-x86_64/node && \
    mkdir -p /opt/kibana-${KIBANA_VERSION}-linux-x86_64/node/bin && \
    ln -sf /usr/bin/node /opt/kibana-${KIBANA_VERSION}-linux-x86_64/node/bin/node && \
	# Plugins
		/opt/kibana-${KIBANA_VERSION}-linux-x86_64/bin/kibana-plugin install "https://oss.sonatype.org/content/repositories/releases/com/floragunn/search-guard-kibana-plugin/$KIBANA_VERSION-$SG_VERSION/search-guard-kibana-plugin-$KIBANA_VERSION-$SG_VERSION.zip" && \
	# cleanup
    rm -rf /var/cache/apk/*


ENV PATH /opt/kibana-${KIBANA_VERSION}-linux-x86_64/bin:$PATH

RUN mkdir -p /.backup/kibana
COPY config/kibana.yml /.backup/kibana/kibana.yml
RUN rm -f "/opt/kibana-$KIBANA_VERSION/config/kibana.yml"

ADD ./src/ /run/
RUN chmod +x -R /run/

ENV KIBANA_PWD="changeme" \ 
    ELASTICSEARCH_HOST="0-0-0-0" \ 
    ELASTICSEARCH_PORT="9200" \ 
		KIBANA_HOST="0.0.0.0" 
		
EXPOSE 5601

ENTRYPOINT ["/run/entrypoint.sh"]
CMD ["kibana"]
