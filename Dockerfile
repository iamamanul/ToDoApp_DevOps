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

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma/client ./node_modules/@prisma/client
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
CMD ["npm","start"]

