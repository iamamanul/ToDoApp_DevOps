# -------- BUILDER --------
FROM node:20-bullseye AS builder
WORKDIR /app

# Prisma needs OpenSSL 3
ENV NODE_OPTIONS="--openssl-legacy-provider"

# Copy package files and install dependencies first for caching efficiency
COPY package*.json ./
RUN npm install

# Copy the rest of the source (including your Prisma schema)
COPY . .

# Run codegen and build
RUN npx prisma generate
RUN npm run build

# ----------------------------------------------------
# -------- RUNNER (Production) --------
# ----------------------------------------------------
FROM node:20-bullseye AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV NODE_OPTIONS="--openssl-legacy-provider"

# Copy package files and prisma schema
COPY package*.json ./
COPY prisma ./prisma

# Install only production dependencies
RUN npm install --omit=dev

# Copy build artifacts from builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# NOTE: Removed redundant copies of node_modules/.prisma and @prisma/client

EXPOSE 3000
CMD ["npm","start"]