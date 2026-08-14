#!/bin/bash
# ============================================================
# Oracle Cloud Free Tier setup - Student Registration app
# Tested on Ubuntu 22.04 / 24.04 (Always Free VM)
# Run on the VM as the default ubuntu user:
#   curl -fsSL https://github.com/aravindayya/HelloWeb/raw/main/oracle/setup_oracle.sh -o setup_oracle.sh && bash setup_oracle.sh
# ============================================================
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "==> Updating packages"
sudo apt-get update -y
sudo apt-get install -y wget curl openjdk-21-jdk-headless mysql-server tomcat10

echo "==> Starting MySQL"
sudo systemctl enable --now mysql 2>/dev/null || sudo service mysql start
sudo systemctl is-active mysql || sudo service mysql start

echo "==> Creating database and app user"
sudo mysql <<'SQL'
CREATE DATABASE IF NOT EXISTS studentdb1 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE USER IF NOT EXISTS 'hello'@'localhost' IDENTIFIED BY 'H3llo@1727';
GRANT ALL PRIVILEGES ON studentdb1.* TO 'hello'@'localhost';
FLUSH PRIVILEGES;
SQL

echo "==> Detecting JAVA_HOME"
JAVA_HOME=$(update-alternatives --query java 2>/dev/null | sed -n 's/^Value: //p' | sed 's|/bin/java||')
[ -z "$JAVA_HOME" ] && JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

echo "==> Configuring Tomcat"
sudo bash -c "cat > /etc/default/tomcat10" <<EOF
MYSQLHOST=localhost
MYSQLPORT=3306
MYSQLUSER=hello
MYSQLPASSWORD=H3llo@1727
MYSQLDATABASE=studentdb1
JAVA_HOME=$JAVA_HOME
EOF

echo "==> Downloading registration app (ROOT.war) from GitHub"
sudo curl -fsSL -o /var/lib/tomcat10/webapps/ROOT.war \
  https://github.com/aravindayya/HelloWeb/raw/main/RailwayDeploy/ROOT.war
sudo rm -rf /var/lib/tomcat10/webapps/ROOT

echo "==> Starting Tomcat"
sudo systemctl enable --now tomcat10 2>/dev/null || sudo service tomcat10 restart
sleep 12

echo "==> Verifying app (tables are auto-created on first start)"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ || echo "000")
echo "Root URL HTTP code: $HTTP_CODE"

if [ "$HTTP_CODE" = "200" ]; then
  echo ""
  echo "====================================================="
  echo "SUCCESS! App is running on the VM."
  echo ""
  echo "Next: open port 8080 in the Oracle VCN security list,"
  echo "then students visit:  http://<PUBLIC_IP>:8080"
  echo "====================================================="
else
  echo ""
  echo "App not responding yet. Check with: sudo tail -f /var/log/tomcat10/catalina.out"
fi
