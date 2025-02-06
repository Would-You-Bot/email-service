FROM node:18-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN apt-get update -y && apt-get install -y openssl
#Hook into pnpm without installing pnpm. (magic) (https://nodejs.org/docs/latest-v18.x/api/corepack.html)
# RUN corepack enable
#Current fix for the corepack download issue
RUN npm install -g pnpm 
WORKDIR /usr/src/app
COPY package*.json pnpm-lock*.yaml ./


#Create node_modules files without dev dependencies.
FROM base AS prod_dependencies
RUN pnpm install --prod --frozen-lockfile

#Create dist.
FROM base AS builder
COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm dlx prisma generate
RUN pnpm run build

#Final image
FROM base
ENV NODE_ENV=production

WORKDIR /usr/src/app
COPY --from=prod_dependencies /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/dist ./dist
RUN pnpm dlx prisma generate
CMD [ "pnpm", "run", "start" ]
