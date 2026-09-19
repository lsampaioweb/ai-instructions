# <Project or Sample Name>

<One-sentence description of the verified purpose.>

## Overview

- <Verified capability or behavior>
- <Verified technology or integration>
- <Verified API, messaging, or page feature>

## Prerequisites

- Java <version from pom.xml>
- Maven <required version>
- <Required infrastructure>

## Local Setup

1. Start the required shared infrastructure:

   ```bash
   cd <relative infrastructure directory>
   cp .env.example .env
   docker compose up -d
   ```

2. Set the required local environment variables:

   ```bash
   export <VARIABLE_NAME>=<local development value>
   ```

   Do not commit local `.env` files or real credentials.

## Run

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=<development profile>
```

## Endpoints

| Method | Path | Description |
| --- | --- | --- |
| `<METHOD>` | `<path>` | <Verified behavior> |

### Example Request

```http
<METHOD> <path>
Content-Type: application/json

<Verified request payload when applicable>
```

## Configuration Notes

- <Profile-specific behavior verified in application configuration>
- <Schema or seed behavior verified in active SQL initialization configuration>
- <Development-only URL, such as Swagger UI, when enabled>

## Tests

```bash
mvn test
```

<Test scope and important coverage boundaries verified from the test suite.>

## Troubleshooting

- <Verified failure symptom and corrective action>

## Related Documentation

- [<Topic>](<relative link>)

## Created by

Luciano Sampaio
