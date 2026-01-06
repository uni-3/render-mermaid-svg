# Article 1: System Architecture

This article demonstrates a system architecture diagram in a nested directory structure.

```mermaid
graph TB
    subgraph "Frontend"
        A[Web App]
        B[Mobile App]
    end

    subgraph "Backend"
        C[API Gateway]
        D[Auth Service]
        E[Database]
    end

    A --> C
    B --> C
    C --> D
    C --> E
    D --> E
```

This diagram should be rendered to `test/fixtures/articles/generated/article1-1.svg`.
