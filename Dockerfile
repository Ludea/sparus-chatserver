FROM rust as builder-amd64
WORKDIR /opt/chatserver
COPY . .
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --release --verbose

FROM rust as builder-arm64
WORKDIR /opt/chatserver
COPY . .
RUN rustup target add aarch64-unknown-linux-musl
RUN cargo build --release --verbose

FROM builder-$TARGETARCH as build

FROM alpine as final
WORKDIR /opt/chatserver
COPY --from=build /opt/chatserver/target/chatserver .
RUN ["./chatserver"] 
