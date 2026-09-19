.git/
.vscode/
*.log
*.gz
.env
*.p12
*.crt

# Single-stage Dockerfile: retain the prebuilt JAR, ignore other build output.
target/*
!target/*.jar

# Multi-stage Dockerfile: replace the two lines above with `target/` instead.
# target/