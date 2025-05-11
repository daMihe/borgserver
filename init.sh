#!/bin/ash
# Copyright 2025 Michael Wodniok
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Initscript setting up borg users authentication

if [[ -z "${CLIENT_PUBKEY}" ]]; then
    echo "CLIENT_PUBKEY is not set. Please set it as environment variable in OpenSSH oneline format, e.g. 'ssh-ed25519 ABCDX...'"
    exit 1
fi
HOSTKEY_FILE=${HOSTKEY_FILE:-/home/borg/ssh_host_ed5519_key}
if [[ ! -r "$HOSTKEY_FILE" ]]; then
    echo "No host key found, generating new one to ${HOSTKEY_FILE}..."
    ssh-keygen -N '' -t ed25519 -f "${HOSTKEY_FILE}"
    chmod 0400 "${HOSTKEY_FILE}"
    chmod 0444 "${HOSTKEY_FILE}.pub"
fi
echo "Hosts public key fingerprint is: $(ssh-keygen -l -f "${HOSTKEY_FILE}.pub")"
rm -rf /home/borg/run
mkdir -p /home/borg/run
mkdir -p /home/borg/.ssh
echo "command="'"'"/usr/bin/borg serve --restrict-to-path /repo"'"'" ${CLIENT_PUBKEY}" >/home/borg/.ssh/authorized_keys
/usr/sbin/sshd -De -f /etc/ssh/sshd_config -h "${HOSTKEY_FILE}" 
exit 0
