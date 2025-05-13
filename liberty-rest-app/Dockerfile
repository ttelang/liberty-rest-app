# Use Open Liberty base image with Java 17
FROM icr.io/appcafe/open-liberty:full-java17-openj9-ubi

# Copy application WAR file to the apps directory in the container
COPY --chown=1001:0 target/liberty-rest-app.war /config/apps/

# Copy server configuration
COPY --chown=1001:0 src/main/liberty/config/server.xml /config/

# This runs configure.sh which reads the server.xml and prepares the Liberty server
RUN configure.sh

# Define health and readiness check
HEALTHCHECK --interval=10s --timeout=3s CMD curl -f http://localhost:9080/health/ || exit 1

# Expose the port defined in the Liberty configuration
EXPOSE 9080 9443
