FROM ubuntu:26.04

LABEL Maintainer="Hamid Naeemabadi" \
      org.opencontainers.image.source="https://github.com/hamidnaeemabadi/doprax-service" \
      org.opencontainers.image.description="Ubuntu 26.04 network diagnostics and shell tools for Doprax"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Exclude optional data before unpacking packages so it never enters the layer.
# Keep copyright files and runtime data (including Nmap scripts and completions).
RUN printf '%s\n' \
        'path-exclude=/usr/share/doc/*' \
        'path-include=/usr/share/doc/*/copyright' \
        'path-exclude=/usr/share/man/*' \
        'path-exclude=/usr/share/info/*' \
        'path-exclude=/usr/share/lintian/*' \
        'path-exclude=/usr/share/locale/*/LC_MESSAGES/*' \
        > /etc/dpkg/dpkg.cfg.d/01-minimal \
    && printf 'Acquire::Languages "none";\n' > /etc/apt/apt.conf.d/99-no-translations \
    && apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=30 -o Acquire::https::Timeout=30 update \
    && DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=30 -o Acquire::https::Timeout=30 install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        net-tools \
        nmap \
        iftop \
        mtr-tiny \
        speedtest-cli \
        bash \
        bash-completion \
        htop \
        btop \
    && curl -fsSL https://raw.githubusercontent.com/hamidnaeemabadi/my-shell/main/install.sh | MY_SHELL_TARGET=bash bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
        /root/.my-shell-backups /root/.cache /tmp/* /var/tmp/* \
    && find /var/log -type f -delete \
    && find /usr/lib -type d -name __pycache__ -prune -exec rm -rf '{}' +

ENV TERM=xterm-256color \
    PYTHONDONTWRITEBYTECODE=1

CMD ["sleep", "infinity"]
