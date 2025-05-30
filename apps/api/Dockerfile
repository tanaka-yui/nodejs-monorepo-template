FROM node:22.13.1-alpine3.21 AS build-stage

WORKDIR /tmp

ARG ENVIRONMENT

ENV PNPM_VERSION=9.14.2

COPY ./ /tmp

RUN npm install -g pnpm@$PNPM_VERSION

RUN pnpm install --prefer-offline

RUN pnpm build

RUN cp /tmp/envs/.env.${ENVIRONMENT} /tmp/.env

FROM node:22.13.1-alpine3.21 AS runtime-stage

WORKDIR /app

RUN apk update && apk upgrade

COPY --chown=node:node --from=build-stage /tmp/package*.json /app
COPY --chown=node:node --from=build-stage /tmp/node_modules /app/node_modules
COPY --chown=node:node --from=build-stage /tmp/dist /app/dist
COPY --chown=node:node --from=build-stage /tmp/.env /app/.env

CMD ["node", "./dist/main.mjs"]