# Dockerfile (multi-stage)
FROM node:20-alpine AS builder
WORKDIR /app

# install deps
COPY package*.json ./
RUN npm ci

# copy source
COPY . .

# prisma codegen (no DB required for generate)
RUN npx prisma generate

# build Next.js
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000

# 1. Copy package files
COPY package*.json ./

# 2.Copy the prisma directory before running npm ci.
# This prevents the 'prisma generate' postinstall script from failing.
COPY --from=builder /app/prisma ./prisma

# 3. Install dependencies (which now succeeds)
RUN npm ci --omit=dev

# 4. Copy the remaining build artifacts
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Copy generated Prisma files and client
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma/client ./node_modules/@prisma/client
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
CMD ["npm","start"]