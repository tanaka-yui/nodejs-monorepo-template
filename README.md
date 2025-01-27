# Nodejs Monorepo Application Template

## Architecture

### Base
- typescript
- pnpm - package manager
- turbo - monorepo
- vite - bundler
- biome - linter & formatter
- zx - script runner
- postgres - database

`nodejs has .mts extension because it is an ESM`

### Backend
- fastify - web framework
- fastify-env - environment variables
- prisma - database ORM
- awilix - dependency injection
- graceful-server - graceful shutdown
- swagger - api documentation
- tsx - typescript runtime. tsx is used instead of ts-node because it is faster and path alias is supported.
- yup - schema validation

### Frontend
- react
- tanstack-query
- tanstack-router
- material-ui
- emotion
- i18next
- jotai
- react-hook-form
- yup

## Initial Setup

- Install the nodejs version listed in .node-version

- Install the pnpm package manager
    
    ```bash
    npm install -g pnpm
    ```

- Enable corepack

    ```bash
    corepack enable pnpm
    ```

- Install dependencies

    ```bash
    pnpm i
    ```

- Setup the local environment

    ```bash
    pnpm setup-local
    ```

## Run the dev server

- Start the database    

    ```bash
    docker compose up -d
    ```

- Run the dev server

    ```bash
    pnpm dev
    ```

## Database Migration

If you need to run the database migration,

Edit the schema.prisma file in the backend/prisma directory.
- apps/api/prisma/schema.prisma

 you can do so with the following command:

```bash
cd backend
pnpm db:migrate
```

## Generate OpenAPI Client

If you need to generate the OpenAPI client.

Edit the handlers schema in the backend/src/handlers directory.

When generating openapi client, please do so with the dev server running.

you can do so with the following command:

```bash
cd frontend
pnpm openapi:generate
```

## Dependency Injection

If you need to add a new dependency, please add it to various index.mts in the src/infra/index.mts or src/usecase/index.mts or src/handlers/index.mts file.

If you need to add a new dependency category, please add it to the container.mts file in the src/core directory.
