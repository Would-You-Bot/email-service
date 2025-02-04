FROM node:20-slim AS base

# Update Corepack
RUN corepack enable && npm i -g corepack@latest

# Install dependencies based on the preferred package manager
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

#Create node_modules files without dev dependencies.
FROM base AS prod_dependencies
RUN pnpm install --prod --frozen-lockfile

#Create dist.
FROM base AS builder
COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm run build

#Generate prisma files
RUN corepack enable pnpm
RUN pnpm dlx prisma generate

#Final image
FROM base
ENV NODE_ENV=production

WORKDIR /usr/src/app
COPY --from=prod_dependencies /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/dist ./dist
CMD [ "pnpm", "run", "start" ]
