

FROM node:22-alpine AS builde

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .


FROM node:22-alpin

LABEL maintainer="Teja"

WORKDIR /app

RUN addgroup -S nodegroup && \
    adduser -S nodeuser -G nodegroup

COPY --from=builder /app .

USER nodeuser

EXPOSE 8080

HEALTHCHECK --interval=30s \
            --timeout=5s \
            --start-period=20s \
            --retries=3 \
CMD wget --spider http://localhost:8080/health || exit 1

CMD ["npm","start"]