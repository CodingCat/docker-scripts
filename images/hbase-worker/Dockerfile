FROM codingcat/dev:hadoop-master

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ENV HADOOP_PREFIX /root/hadoop-2.3.0/

ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop

ENV HADOOP_LIBEXEC_DIR $HADOOP_PREFIX/libexec/

ENV HBASE_PREFIX /root/hbase-0.98.7

ENV HBASE_CONF_DIR $HBASE_PREFIX/conf

EXPOSE 8010 9000 50010 50070 50075 60000 60010 60020 60030

ADD files /root/hadoop-scripts/

CMD ["/root/hadoop-scripts/start-hbase-worker.sh"]
