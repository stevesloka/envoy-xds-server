FROM golang:alpine as builder

RUN mkdir /build
ADD . /build/
WORKDIR /build

# Build the binary
RUN go build -o envoy-xds-server ./cmd/server/main.go

# Copy into scratch
FROM scratch
COPY --from=builder /build/envoy-xds-server /bin/envoy-xds-server
CMD ["/bin/envoy-xds-server"]