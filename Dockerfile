# ---------- BUILD STAGE ----------
FROM node:20-bookworm AS builder
WORKDIR /app

# copy entire project first
COPY . .

# install dependencies
RUN npm install

# prisma client generation
RUN npx prisma generate

# build Next.js
RUN npm run build


# ---------- RUN STAGE ----------
FROM node:20-bookworm
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

COPY package*.json ./
COPY prisma ./prisma

RUN npm install --omit=dev

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules/@prisma/client ./node_modules/@prisma/client
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma

EXPOSE 3000
CMD ["npm","start"]
