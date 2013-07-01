#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="Jenkins"

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi
    : ADD START ACTIONS HERE
QPKG_DIR=$(/sbin/getcfg $QPKG_NAME Install_Path -d "" -f $CONF)
mkdir -p /share/Multimedia/JenkinsHome
mkdir -p /share/Multimedia/JenkinsHome/log
export JENKINS_HOME=/share/Multimedia/JenkinsHome/
/usr/local/jre/bin/java -Dprocess=jenkins -XX:PermSize=128M -XX:MaxPermSize=128M -Xmn128M -Xms256M -Xmx512M -jar $QPKG_DIR/jenkins.war --httpPort=8888 >> /share/Multimedia/JenkinsHome/log/jenkins_log 2> /share/Multimedia/JenkinsHome/log/jenkins_log &

    ;;

  stop)
    : ADD STOP ACTIONS HERE
#killall -2 jenkins
for KILLPID in `ps -A | grep process=jenkins | awk ' { print $1;}'`; do
  kill $KILLPID 2> /dev/null
done
;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
