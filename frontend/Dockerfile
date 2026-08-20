# Build context is the repo root (see docker-compose.yml).
FROM node:22-slim AS build
WORKDIR /app

COPY frontend/package.json frontend/pnpm-lock.yaml ./
RUN corepack enable && corepack prepare pnpm@latest --activate \
  && pnpm install --frozen-lockfile

COPY frontend .

# Baked in at build time — Vite inlines import.meta.env.* into the bundle,
# so this can't be changed at container-start like a normal runtime env var.
# /api works because Nginx (below) reverse-proxies /api to the backend
# service on the same origin; override via --build-arg for a split-domain
# deployment (see frontend/.env.example).
ARG VITE_API_BASE_URL=/api
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL
RUN pnpm build

FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
