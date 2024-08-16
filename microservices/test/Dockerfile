# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose the application port
EXPOSE 3000

# Define environment variables (these will be overridden by the ECS task definition)
ENV DB_HOST=localhost
ENV DB_USER=root
ENV DB_PASS=password
ENV DB_NAME=mydatabase

# Start the Node.js application
CMD ["npm", "start"]
