FROM golang:1.24-alpine AS build

LABEL maintainer="Hanzo AI, Inc. <dev@hanzo.ai>"

ENV GOPATH /go
ENV CGO_ENABLED 0

RUN apk add -U --no-cache ca-certificates git

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -v -ldflags "-s -w" -o /go/bin/s3 .

FROM scratch

COPY --from=build /go/bin/s3 /usr/bin/s3
COPY --from=build /src/LICENSE /licenses/LICENSE
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["s3"]
