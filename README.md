# Todo App with Next.js and PostgreSQL

A modern todo application with user authentication and real-time updates.

## Features

- User authentication (Sign up, Login, Logout)
- Create, read, update, and delete todos
- Mark todos as complete/incomplete
- Responsive design
- Secure API routes
- PostgreSQL database with Prisma ORM

## Prerequisites

- Node.js 18+
- PostgreSQL database
- npm or yarn

## Getting Started

1. Install dependencies:
   ```bash
   npm install
   # or
   yarn
   ```

2. Set up environment variables:
   Create a `.env.local` file in the root directory with:
   ```env
   DATABASE_URL="postgresql://neondb_owner:npg_nfWyYG5B8NvM@ep-proud-sky-ah1eeihp-pooler.c-3.us-east-1.aws.neon.tech/To-Do-App?sslmode=require&channel_binding=require"
   NEXTAUTH_URL="http://localhost:3000"
   NEXTAUTH_SECRET="your-secret-key-here-change-this-to-a-secure-random-string"
   ```

3. Run database migrations:
   ```bash
   npx prisma migrate dev --name init
   ```

4. Seed the database (optional):
   ```bash
   npx ts-node src/scripts/seed.ts
   ```

5. Start the development server:
   ```bash
   npm run dev
   # or
   yarn dev
   ```

6. Open [http://localhost:3000](http://localhost:3000) in your browser

## Available Scripts

- `npm run dev` - Start the development server
- `npm run build` - Build the application for production
- `npm start` - Start the production server
- `npm run lint` - Run ESLint
- `npx prisma generate` - Generate Prisma Client
- `npx prisma migrate dev` - Run database migrations
- `npx ts-node src/scripts/seed.ts` - Seed the database with test data

## Tech Stack

- Next.js 14
- TypeScript
- Tailwind CSS
- NextAuth.js
- Prisma
- PostgreSQL
- Heroicons

## Usage

1. Navigate to `/signup` to create a new account
2. Login with your credentials
3. You'll be redirected to the todo list page
4. Add, edit, delete, and complete todos
5. Each user has their own private todo list

## Test User

After seeding the database, you can use:
- Email: test@example.com
- Password: password123
