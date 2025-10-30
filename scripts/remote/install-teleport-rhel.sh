#!/bin/bash

set +x

SESSION_TOKEN=$(curl -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -X PUT "http://169.254.169.254/latest/api/token" -s)
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $SESSION_TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -H "X-aws-ec2-metadata-token: $SESSION_TOKEN" -s http://169.254.169.254/latest/meta-data/placement/region)

install_dependencies() {
    # Update system
    sudo dnf update -y

    # Enable EPEL repository (needed for jq and some utilities)
    sudo dnf install -y epel-release

    # Install dependencies
    sudo dnf install -y git nmap jq unzip curl ca-certificates postgresql gnupg2 hostname systemd
}

update_aws_cli() {
    # Remove old AWS CLI if exists
    sudo rm -rf /usr/local/aws-cli /usr/local/bin/aws || true

    # Install AWS CLI v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    rm -rf awscliv2.zip aws/
}

set_hostname() {
    if [[ -n "${EC2_INSTANCE_NAME}" ]]; then
        sudo hostnamectl set-hostname "$(echo "${EC2_INSTANCE_NAME}" | sed 's/'"${TELEPORT_DISPLAY_NAME_STRIP_STRING}"'//g')"
    fi
}

install_teleport() {
    TELEPORT_VERSION="$(curl -s https://${TELEPORT_ADDRESS}/v1/webapi/automaticupgrades/channel/default/version | sed 's/v//')"
    curl -s https://cdn.teleport.dev/install.sh | bash -s $TELEPORT_VERSION ${TELEPORT_EDITION}
    echo "${TELEPORT_JOIN_TOKEN}" | sudo tee /tmp/token > /dev/null
}

configure_teleport_yaml() {
    sudo tee /etc/teleport.yaml > /dev/null <<EOF
version: v3
teleport:
  auth_token: /tmp/token
  proxy_server: ${TELEPORT_ADDRESS}
  data_dir: /var/lib/teleport
  log:
    output: stderr
    severity: INFO
    format:
      output: text

ssh_service:
  enabled: true
  labels:
    env: ${ENVIRONMENT_TAG}

proxy_service:
  enabled: false

auth_service:
  enabled: false

db_service:
  enabled: true
  resources:
    - labels:
        "teleport-discovery": "${TELEPORT_DISCOVERY_TAG_VALUE}"

discovery_service:
    enabled: true
    discovery_group: "jasmit-test-discovery-group"
    poll_interval: 5m
    aws:
    - types: ["rds"]
      regions: ["$REGION"]
      tags:
        "teleport-discovery": "${TELEPORT_DISCOVERY_TAG_VALUE}"

    - types: ["eks"]
      regions: ["us-west-1"]
      tags:
        "teleport-discovery": "${TELEPORT_DISCOVERY_TAG_VALUE}"

kubernetes_service:
  enabled: true
  resources:
    - labels:
        "teleport-discovery": "${TELEPORT_DISCOVERY_TAG_VALUE}"

windows_desktop_service:
  enabled: true
  static_hosts:
    - name: "${WINDOWS_SERVER_RESOURCE_NAME}"
      ad: false
      addr: ${WINDOWS_SERVER_PRIVATE_IP}
EOF
}

# Main execution flow
install_dependencies
update_aws_cli
set_hostname
install_teleport
configure_teleport_yaml

# Enable and start Teleport
sudo systemctl enable teleport
sudo systemctl restart teleport
sudo systemctl status teleport --no-pager
