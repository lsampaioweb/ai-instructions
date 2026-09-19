app:
  feature:
    display-name: "Example feature"
    endpoint:
      base-url: "${FEATURE_BASE_URL:https://localhost:8443}"
      connect-timeout-seconds: 5
    enabled-regions:
      - "us-east-1"
      - "sa-east-1"