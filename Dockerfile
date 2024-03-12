# ==============================================================================
# Add https://gitlab.com/pipeline-components/org/base-entrypoint
# ------------------------------------------------------------------------------
FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

# ==============================================================================
# Component specific
# ------------------------------------------------------------------------------
FROM composer:2.7.2 as build
COPY app/ /app/
WORKDIR /app/
RUN composer install --no-interaction --no-scripts --no-progress --optimize-autoloader

# ------------------------------------------------------------------------------
FROM php:8.3.0-alpine3.17
ENV PATH "$PATH:/app/vendor/bin/"
COPY --from=build /app/ /app/
# COPY php.ini /usr/local/etc/php/php.ini

# ==============================================================================
# Generic for all components
# ------------------------------------------------------------------------------
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD php-cs-fixer

WORKDIR /code/

# ==============================================================================
# Container meta information
# ------------------------------------------------------------------------------
ARG BUILD_DATE
ARG BUILD_REF

LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.opencontainers.image.title="PHP Coding Standards Fixer" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Pipeline Components" \
    org.opencontainers.image.authors="Robbert Müller <spam.me@grols.ch>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://pipeline-components.dev/" \
    org.opencontainers.image.source="https://gitlab.com/pipeline-components/php-cs-fixer/" \
    org.opencontainers.image.documentation="https://gitlab.com/pipeline-components/php-cs-fixer/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION} \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.description="PHP-CS-Fixer in a container for gitlab-ci" \
    org.label-schema.name="PHP Coding Standards Fixer" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.dev/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/php-cs-fixer/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/php-cs-fixer/" \
    org.label-schema.vendor="Pipeline Components"
