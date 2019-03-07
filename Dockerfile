FROM google/cloud-sdk:181.0.0-alpine

RUN apk add --update curl ca-certificates bash \
  && curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl

COPY ./*.sh /bin/
ENTRYPOINT ["/bin/bash"]
CMD ["/bin/check-service.sh"]
