FROM minlag/mermaid-cli:latest

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER mermaidcli

ENTRYPOINT ["/entrypoint.sh"]
