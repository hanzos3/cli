FROM golang:1.22-alpine as build

LABEL maintainer="Hanzo AI, Inc. <dev@hanzo.ai>"

ENV GOPATH /go
ENV CGO_ENABLED 0


RUN apk add -U --no-cache ca-certificates
RUN apk add -U curl
RUN curl -s -q https://raw.githubusercontent.com/hanzos3/cli/main/LICENSE -o /go/LICENSE
RUN curl -s -q https://raw.githubusercontent.com/hanzos3/cli/main/CREDITS -o /go/CREDITS
RUN go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)" "github.com/minio/mc@latest"

FROM scratch

COPY --from=build /go/bin/mc  /usr/bin/s3
COPY --from=build /go/CREDITS /licenses/CREDITS
COPY --from=build /go/LICENSE /licenses/LICENSE
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["s3"]
