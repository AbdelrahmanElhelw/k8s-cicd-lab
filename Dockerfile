# Stage 1: Install dependencies
FROM node:26-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

# Stage 2: Production runtime
FROM alpine:3.24

RUN apk add --no-cache nodejs-current


WORKDIR /app


COPY --from=build /app/node_modules ./node_modules
COPY server.js app.js ./
COPY app/ ./app/

USER 10001

EXPOSE 3000

CMD ["node", "server.js"]
