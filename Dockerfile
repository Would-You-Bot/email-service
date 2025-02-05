# Base stage: set WORKDIR to /app so that all installations go there
FROM node:20-slim AS base
RUN apk add --no-cache openssl openssl-dev

WORKDIR /app

# Update Corepack
RUN corepack enable && npm i -g corepack@latest

# Copy dependency files and install all dependencies (using the appropriate package manager)
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f pnpm-lock.yaml ]; then \
    corepack enable pnpm && pnpm i --frozen-lockfile; \
  else \
    echo "Lockfile not found." && exit 1; \
  fi

# Stage for production dependencies only (without dev dependencies)
FROM base AS prod_dependencies
RUN pnpm install --prod --frozen-lockfile

# Builder stage: copy full source code, install all dependencies, and build the project
FROM base AS builder
COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm run build

# Generate Prisma files
RUN corepack enable pnpm
RUN pnpm dlx prisma generate

# Final stage: assemble the production image
FROM base
ENV NODE_ENV=production

WORKDIR /app
# Copy production-only node_modules from the prod_dependencies stage
COPY --from=prod_dependencies /app/node_modules ./node_modules
# Copy the built artifacts from the builder stage
COPY --from=builder /app/dist ./dist

CMD [ "pnpm", "run", "start" ]
