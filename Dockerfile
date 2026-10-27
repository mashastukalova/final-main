FROM golang:1.26.3 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY main.go parcel.go ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /final-main .

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /final-main /final-main
COPY tracker.db /app/tracker.db

CMD ["/final-main"]
