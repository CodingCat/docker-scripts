FROM codingcat/dev:cassandra

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ENV HADOOP_PREFIX /root/cassandra/

EXPOSE 7000 7001 9160 9042

ADD files /root/cassandra/

CMD ["/root/cassandra/start-cassandra-node.sh"]
