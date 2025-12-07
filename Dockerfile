# ---------- BUILD STAGE ----------
FROM node:20-bookworm AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npx prisma generate
RUN npm run build

# ---------- RUN STAGE ----------
FROM node:20-bookworm
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Copy package files and prisma BEFORE npm install
COPY package*.json ./
COPY prisma ./prisma

# Install only production dependencies
RUN npm install --omit=dev

# Copy app build output
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Copy prisma client + generated engines
COPY --from=builder /app/node_modules/@prisma/client ./node_modules/@prisma/client
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma

EXPOSE 3000
CMD ["npm", "start"]
