# ----------------------------------------------------
# ------------------ BUILDER STAGE -------------------
# ----------------------------------------------------
FROM node:20-bullseye AS builder
WORKDIR /app

# ENV NODE_OPTIONS is necessary if your Node.js or Prisma version relies on a legacy 
# OpenSSL provider, especially when dealing with older dependencies.
ENV NODE_OPTIONS="--openssl-legacy-provider"

# 1. Copy package files (package.json and package-lock.json/npm-shrinkwrap.json)
COPY package*.json ./

# 2. 🔥 CRITICAL FIX: Copy the entire source (including prisma/schema.prisma) 
#    BEFORE running npm install, as the postinstall script needs the schema.
COPY . .

# 3. Install all dependencies (dev and prod)
#    This triggers the successful 'prisma generate' via postinstall.
RUN npm install

# 4. Explicitly run Prisma generate (optional, but good for clarity)
RUN npx prisma generate

# 5. Build the Next.js application
RUN npm run build

# ----------------------------------------------------
# ------------------ RUNNER STAGE --------------------
# ----------------------------------------------------
FROM node:20-bullseye AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV NODE_OPTIONS="--openssl-legacy-provider"

# 1. Copy necessary files for the production environment
COPY package*.json ./
COPY prisma ./prisma

# 2. Install only production dependencies
#    This ensures a minimal final image size.
RUN npm install --omit=dev

# 3. Copy the built artifacts from the builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# 4. Optional: Copy package.json again for 'npm start' to work reliably
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
CMD ["npm","start"]