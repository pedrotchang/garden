# Build stage
FROM oven/bun:1.3-alpine AS builder

WORKDIR /src

# Copy package files first for better caching
COPY package.json bun.lock ./

# Install dependencies
RUN bun install --frozen-lockfile

# Copy source files
COPY . .

# Build Quartz static site
RUN bun run quartz build

# Production stage
FROM nginx:1.27-alpine

# Copy built site
COPY --from=builder /src/public /usr/share/nginx/html

# Nginx config optimized for static sites
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # SPA routing - try file, then directory, then index
    location / {
        try_files \$uri \$uri/ \$uri.html /index.html;
    }

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1000;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json image/svg+xml;

    # Cache static assets aggressively
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Cache HTML with revalidation
    location ~* \.html$ {
        expires 1h;
        add_header Cache-Control "public, must-revalidate";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
}
EOF

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
