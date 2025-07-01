# Use an official Node.js runtime as the base image
FROM node:20-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy files to the working directory
COPY . /app

# Install dependencies
RUN npm install

# Build the React app
RUN npm run build

# Use a lightweight web server to serve the built files
FROM nginx:alpine

# Copy build output to nginx
COPY --from=builder /app/dist /usr/share/nginx/html/

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Fix permissions for nginx cache directory
USER root
RUN mkdir -p /var/cache/nginx/client_temp && chmod -R 777 /var/cache/nginx

# Expose port 8080
EXPOSE 8080

# Start the server
CMD ["nginx", "-g", "daemon off;"]
