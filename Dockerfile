# Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

# Runtime Stage
FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app .

RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

USER appuser

EXPOSE 5010

HEALTHCHECK --interval=10s \
            --timeout=3s \
            --start-period=5s \
            --retries=3 \
CMD wget --spider -q http://localhost:5010 || exit 1

CMD ["npm","start"]

