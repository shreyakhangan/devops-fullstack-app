FROM node:14.17.6-alpine3.13

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install frontend dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Expose the port the app will run on
EXPOSE 3000

# Start the React app
CMD ["npm", "start"]