# Use Node.js 20 for building the app
FROM node:20-alpine AS builder
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Build the NestJS project
COPY . .
RUN npm run build

# Production image
FROM node:20-alpine AS runner
WORKDIR /app

COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /app/dist ./dist

CMD ["node", "dist/main.js"]
