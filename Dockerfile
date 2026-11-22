# Stage 1: Install dependencies
FROM node:26-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

# Stage 2: Production runtime
FROM node:26-alpine

WORKDIR /app

RUN rm -rf /usr/local/lib/node_modules/npm \
           /usr/local/bin/npm \
           /usr/local/bin/npx

COPY --from=build /app/node_modules ./node_modules
COPY server.js app.js ./
COPY app/ ./app/

USER node

EXPOSE 3000

CMD ["node", "server.js"]
