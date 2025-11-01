# Use lightweight node image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package manifests first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy app source
COPY . .

# Expose the port your app listens on
EXPOSE 8090

# Start the app
CMD ["node", "index.js"]

