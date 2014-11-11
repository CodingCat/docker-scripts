FROM codingcat/dev:basic

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ENV HADOOP_PREFIX /root/hadoop-2.3.0/

ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop

ENV HADOOP_LIBEXEC_DIR $HADOOP_PREFIX/libexec/

EXPOSE 8010 9000 50010 50070 50075

ADD files /root/hadoop-scripts/

CMD ["/root/hadoop-scripts/start-hdfs-worker.sh"]
