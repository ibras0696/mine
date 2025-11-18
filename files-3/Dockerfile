FROM itzg/minecraft-server:java17

LABEL org.opencontainers.image.source="Minecraft Forge 1.20.1 stack"
LABEL org.opencontainers.image.description="Форк базового itzg/minecraft-server с сохраняемой конфигурацией Forge 1.20.1."

# Значения можно переопределять через .env / docker compose, но базовые задаём здесь,
# чтобы образ всегда запускался с одинаковыми дефолтами.
ENV EULA=TRUE \
    TYPE=FORGE \
    VERSION=1.20.1 \
    FORGE_VERSION=47.3.0 \
    MEMORY=4G \
    USE_AIKAR_FLAGS=false \
    TZ=Europe/Moscow

# Внутренние вспомогательные сценарии.
COPY scripts/container/check-data.sh /opt/mc-tools/check-data.sh
COPY scripts/container/console-wrapper.sh /opt/mc-tools/console-wrapper.sh
RUN chmod +x /opt/mc-tools/check-data.sh /opt/mc-tools/console-wrapper.sh
