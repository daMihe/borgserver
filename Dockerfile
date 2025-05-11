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

FROM alpine:3
ARG PUID=1000
ARG PGID=1000
RUN apk update && \
 apk add openssh-server borgbackup && \
 addgroup -g ${PGID} borg && \
 adduser -h /home/borg -s /bin/ash -G borg -D -u ${PUID} borg && \
 mkdir /repo && \
 chown borg:borg /repo && \
 chmod 0700 /repo
COPY --chmod=755 init.sh healthcheck.sh /
COPY --chmod=644 additional_sshd_config.conf /etc/ssh/sshd_config.d/
USER borg:borg
WORKDIR /repo
VOLUME /repo
EXPOSE 22
ENTRYPOINT ["/bin/ash"]
CMD ["/init.sh"]
HEALTHCHECK CMD /healthcheck.sh
