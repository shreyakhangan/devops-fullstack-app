# Stage 1: Build the Go application
FROM golang:1.19-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum to download dependencies
COPY go.mod go.sum ./

# Download Go modules dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o backend .

# Stage 2: Create a minimal image with the compiled Go binary
FROM golang:1.19-alpine

# Copy the compiled Go binary from the builder
COPY --from=builder /app/backend /backend

# Expose port 8080
EXPOSE 8080

# Run the backend application
CMD ["/backend"]