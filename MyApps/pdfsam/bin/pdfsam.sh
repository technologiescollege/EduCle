#!/bin/sh
# This file is part of the PDF Split And Merge source code
# Copyright 2014 by Andrea Vacondio (andrea.vacondio@gmail.com).
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`
BASEDIR=`cd "$PRGDIR/.." >/dev/null; pwd`

# Reset the REPO variable. If you need to influence this use the environment setup file.
REPO=


# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true
           if [ -z "$JAVA_VERSION" ] ; then
             JAVA_VERSION="CurrentJDK"
           else
             echo "Using Java version: $JAVA_VERSION"
           fi
		   if [ -z "$JAVA_HOME" ]; then
		      if [ -x "/usr/libexec/java_home" ]; then
			      JAVA_HOME=`/usr/libexec/java_home`
			  else
			      JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
			  fi
           fi       
           ;;
esac

if [ -z "$JAVA_HOME" ] ; then
  if [ -r /etc/gentoo-release ] ; then
    JAVA_HOME=`java-config --jre-home`
  fi
fi

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
fi

# If a specific java binary isn't specified search for the standard 'java' binary
if [ -z "$JAVACMD" ] ; then
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD="$JAVA_HOME/jre/sh/java"
    else
      JAVACMD="$JAVA_HOME/bin/java"
    fi
  else
    JAVACMD=`which java`
  fi
fi

if [ ! -x "$JAVACMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly." 1>&2
  echo "  We cannot execute $JAVACMD" 1>&2
  exit 1
fi

if [ -z "$REPO" ]
then
  REPO="$BASEDIR"/lib
fi

CLASSPATH="$BASEDIR"/etc:"$REPO"/commons-lang3-3.1.jar:"$REPO"/eventstudio-1.0.5.jar:"$REPO"/pdfsam-gui-3.0.0.M1.jar:"$REPO"/commons-io-2.4.jar:"$REPO"/sejda-model-1.0.0.RELEASE-SNAPSHOT.jar:"$REPO"/validation-api-1.0.0.GA.jar:"$REPO"/pdfsam-i18n-3.0.0.M1.jar:"$REPO"/gettext-commons-0.9.8.jar:"$REPO"/pdfsam-core-3.0.0.M1.jar:"$REPO"/sejda-conversion-1.0.0.RELEASE-SNAPSHOT.jar:"$REPO"/pdfsam-fx-3.0.0.M1.jar:"$REPO"/pdfsam-service-3.0.0.M1.jar:"$REPO"/sejda-core-1.0.0.RELEASE-SNAPSHOT.jar:"$REPO"/sejda-itext5-1.0.0.RELEASE-SNAPSHOT.jar:"$REPO"/itextpdf-5.5.3.jar:"$REPO"/bcprov-jdk15on-1.49.jar:"$REPO"/bcpkix-jdk15on-1.49.jar:"$REPO"/hibernate-validator-4.2.0.Final.jar:"$REPO"/jackson-jr-objects-2.4.1.jar:"$REPO"/jackson-core-2.4.1.jar:"$REPO"/javax.inject-1.jar:"$REPO"/spring-context-4.1.3.RELEASE.jar:"$REPO"/spring-aop-4.1.3.RELEASE.jar:"$REPO"/aopalliance-1.0.jar:"$REPO"/spring-beans-4.1.3.RELEASE.jar:"$REPO"/spring-core-4.1.3.RELEASE.jar:"$REPO"/commons-logging-1.2.jar:"$REPO"/spring-expression-4.1.3.RELEASE.jar:"$REPO"/fontawesomefx-8.0.10.jar:"$REPO"/pdfsam-merge-3.0.0.M1.jar:"$REPO"/pdfsam-simple-split-3.0.0.M1.jar:"$REPO"/pdfsam-split-by-size-3.0.0.M1.jar:"$REPO"/pdfsam-split-by-bookmarks-3.0.0.M1.jar:"$REPO"/pdfsam-alternate-mix-3.0.0.M1.jar:"$REPO"/pdfsam-rotate-3.0.0.M1.jar:"$REPO"/jcl-over-slf4j-1.7.7.jar:"$REPO"/logback-classic-1.1.2.jar:"$REPO"/logback-core-1.1.2.jar:"$REPO"/slf4j-api-1.7.7.jar:"$REPO"/pdfsam-community-3.0.0.M1.jar

ENDORSED_DIR=
if [ -n "$ENDORSED_DIR" ] ; then
  CLASSPATH=$BASEDIR/$ENDORSED_DIR/*:$CLASSPATH
fi

if [ -n "$CLASSPATH_PREFIX" ] ; then
  CLASSPATH=$CLASSPATH_PREFIX:$CLASSPATH
fi

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  [ -n "$HOME" ] && HOME=`cygpath --path --windows "$HOME"`
  [ -n "$BASEDIR" ] && BASEDIR=`cygpath --path --windows "$BASEDIR"`
  [ -n "$REPO" ] && REPO=`cygpath --path --windows "$REPO"`
fi

exec "$JAVACMD" $JAVA_OPTS -Xmx256M \
  -classpath "$CLASSPATH" \
  -Dapp.name="pdfsam" \
  -Dapp.pid="$$" \
  -Dapp.repo="$REPO" \
  -Dapp.home="$BASEDIR" \
  -Dbasedir="$BASEDIR" \
  org.pdfsam.community.App \
  "$@"
