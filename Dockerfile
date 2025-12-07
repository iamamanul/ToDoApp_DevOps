# -------- BUILDER --------
FROM node:20.11-bullseye AS builder
WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma
COPY . .

RUN npm install
RUN npx prisma generate
RUN npm run build

# -------- RUNNER --------
FROM node:20.11-bullseye AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

COPY package*.json ./
COPY prisma ./prisma

RUN npm install --omit=dev

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma/client ./node_modules/@prisma/client

EXPOSE 3000
CMD ["npm","start"]

