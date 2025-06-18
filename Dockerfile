# ---------- Build Frontend ----------
FROM node:18-alpine AS frontend

WORKDIR /app

# Copy and build client
COPY client ./client
COPY package.json package-lock.json ./
RUN npm install && npm run build --prefix client

# ---------- Build Backend ----------
FROM node:18-alpine AS backend

WORKDIR /app

COPY server ./server
COPY shared ./shared
COPY package.json package-lock.json ./
RUN npm install

# Copy built frontend into backend
COPY --from=frontend /app/client/dist ./client/dist

# ---------- Run Server ----------
EXPOSE 5000

CMD ["node", "server/index.js"]
