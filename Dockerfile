# Stage 1
FROM node:18.17-alpine AS builder

ENV LANG=C.UTF-8

WORKDIR /opt/app

# Copy app dependencies
COPY app/package.json .
COPY app/package-lock.json .

# Install NPM
RUN npm install

# Add app files
ADD app/src src/
ADD app/public public/

# Build app
RUN npm run build

# Stage 2
FROM nginx:latest

WORKDIR /usr/share/nginx/html

# Clean content from current folder
RUN rm -rf ./*

# Add app files
COPY --from=builder opt/app/build .

# Run webserver
ENTRYPOINT ["nginx", "-g", "daemon off;"]
