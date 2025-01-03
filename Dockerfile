# Specifies the syntax version for the Dockerfile to use Docker's BuildKit features.
# In this case, it's Docker BuildKit for Dockerfiles.
# syntax=docker/dockerfile:1

# Define an argument for the Node.js version to allow flexibility when building the image.
ARG NODE_VERSION=18.0.0

# Use the specified Node.js version with the lightweight Alpine Linux distribution as the base image.
FROM node:${NODE_VERSION}-alpine as base

# Set the working directory inside the container where application code and dependencies will reside.
WORKDIR /usr/src/app

# Expose port 3000 for the application to listen on, making it accessible to other services.
EXPOSE 3000

# Create a new stage for the development environment using the base image defined earlier.
FROM base as dev

# Install dependencies for development using bind mounts and cache optimization:
# 1. Bind the `package.json` and `package-lock.json` files from the host to the container.
# 2. Cache the npm modules in `/root/.npm` for faster installations on subsequent builds.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --include=dev

# Switch to a non-root user (`node`) for security.
USER node

# Copy the application code from the host into the container.
COPY . .

# Set the default command to start the application in development mode.
CMD npm run dev

# Create another stage for the production environment using the same base image.
FROM base as prod

# Install only production dependencies:
# 1. Bind `package.json` and `package-lock.json` to ensure dependency integrity.
# 2. Use a cache for npm to speed up dependency installation.
# 3. Exclude development dependencies using `--omit=dev`.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

# Switch to a non-root user (`node`) for security.
USER node

# Copy the application code into the container.
COPY . .

# Set the default command to start the application in production mode.
CMD node src/index.js
