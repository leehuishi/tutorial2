# Use the official Node.js image from Docker Hub
FROM node:18-alpine AS builder

# Create and set the working directory inside the container
WORKDIR /app

# Copy the tarball and the package.json to the container
COPY package.json a4-1.0.0.tgz ./

# # npm install the tarball into a build folder and perform necessary actions
RUN npm install --prefix ./build a4-1.0.0.tgz 
RUN cmp ./package.json ./build/node_modules/a4/package.json || (echo "Files differ. Stopping the build." && exit 1)

RUN cat package.json
RUN cat ./build/node_modules/a4/package.json


# Copy the rest of the application code to the container
COPY . .

RUN cp -r ./build/node_modules/a4/node_modules/. ./node_modules

# Final stage to create a minimal image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the application code and node_modules from the builder stage
COPY --from=builder /app /app

# Create a non-root user without a home directory
RUN adduser -D -H appuser

# Switch to the non-root user
USER appuser

# Expose the port your app runs on
EXPOSE 3002

# Command to run your application
CMD ["node", "app.js"]
