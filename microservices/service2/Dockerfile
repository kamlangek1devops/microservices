# Use the official Node.js image
FROM node:16

# Set the working directory
WORKDIR /app

# Copy the package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Expose the port
EXPOSE 3000

# Start the server
CMD ["node", "src/index.js"]
