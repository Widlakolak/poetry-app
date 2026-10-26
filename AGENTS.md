# AGENTS.md

## Project rules

1. Read `README.md` completely before making changes. Treat it as the source of truth for product requirements.
2. Work in small, independently verifiable stages. Do not start the next stage without explicit user approval.
3. Before implementation, inspect the existing repository, configuration, dependencies and relevant tests. Never claim to have inspected files or systems that were not actually accessible.
4. Do not invent product content, creator biographies, authorship, transcripts, external URLs or media identifiers.
5. Preserve the agreed home screen order: Wiersz na dziś, Poeci, Artyści, Wybrane dla Ciebie. Do not redesign the product or add unrequested features.
6. Keep the application a modular monolith. Use Java 21, Spring Boot 4.0.2, Gradle Kotlin DSL, PostgreSQL, Flyway, React, TypeScript and Vite as specified in `README.md`.
7. Verify dependency compatibility with Spring Boot 4.0.2. Do not blindly reuse configuration from older Spring Boot versions.
8. Keep controllers, services, repositories, entities, DTOs, validation, mapping and error handling clearly separated. Add tests for important behavior and failure cases.
9. Never store media files in Git, Docker images or PostgreSQL BLOBs. Use persistent storage outside the application containers.
10. Make media imports idempotent and safe to retry. Validate file types, sizes, paths and checksums. Do not expose the `incoming` directory.
11. Keep media publication status separate from transcript verification status. Missing or draft transcripts must not prevent valid media from being published.
12. Never expose database ports publicly or commit credentials, tokens or secrets. Restrict Actuator endpoints and container permissions.
13. Preserve existing QNAP, Nginx and Cloudflare Tunnel infrastructure unless a justified change is approved.
14. Keep CI/CD, container builds and deployments reproducible. Adding a media file must not require rebuilding application images.
15. Do not leave empty implementations, fake behavior or TODOs in features reported as complete.
16. After every stage, run relevant tests and production builds, fix failures, report what works and what remains, and wait for approval.
17. Keep changes focused. Do not introduce additional infrastructure, dependencies or features without a concrete requirement.
18. Update documentation when implementation changes setup, configuration, API behavior or deployment procedures.
