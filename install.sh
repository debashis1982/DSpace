apt-get update
apt-get -y install default-jdk
apt-get -y install maven
groupadd dspace
useradd -s /bin/false -g dspace -d /opt/dspace dspace
cd /tmp
mkdir /opt/tomcat
curl -O http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16.tar.gz
tar xzvf apache-tomcat-8.5.16.tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
chmod -R g+r conf
chmod g+x conf
chown -R dspace webapps/ work/ temp/ logs/ conf/ lib/ temp/ bin/
update-java-alternatives -l
cp /home/ubuntu/tomcat.service /etc/systemd/system/
systemctl daemon-reload
cd /tmp && git clone https://github.com/4Science/DSpace.git --branch dspace-5_x_x-cris dspace-parent/
cd /tmp/dspace-parent && mvn package && for war in $(find . -name *.war); do cp $war /opt/tomcat/webapps/; done
systemctl start tomcat.service
