# Poetry App backend

## Stack

- Java 21
- Spring Boot 4.0.2
- Gradle Kotlin DSL (Gradle Wrapper 9.3.0)
- Spring Data JPA
- PostgreSQL + Flyway in production
- H2 for local development and integration tests

## Run locally

From this directory:

```bash
./gradlew bootRun
```

The default profile uses an in-memory H2 database. Flyway creates the schema on startup. No sample content is inserted.

## Run tests

```bash
./gradlew test
```

## Production configuration

Activate the `prod` profile and provide these environment variables:

- `DB_URL`
- `DB_USERNAME`
- `DB_PASSWORD`
- `CORS_ALLOWED_ORIGINS`

The production profile deliberately has no fallback database credentials.

## Read-only API in this stage

- `GET /api/v1/media?page=0&size=20` - published media only
- `GET /api/v1/media/{id}` - one published media item
- `GET /api/v1/creators?role=POET&page=0&size=20` - creators credited as poets
- `GET /api/v1/creators?role=ARTIST&page=0&size=20` - creators credited as artists
- `GET /actuator/health` - health probe

The API does not expose filesystem paths or implement media streaming. Write endpoints, importing, search and playback are outside this stage.
