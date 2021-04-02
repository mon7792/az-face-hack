FROM golang:alpine as builder

RUN apk update && apk add --no-cache git

COPY . /source

RUN cd /source &&\
    go build -o myapp

FROM alpine:3.7

RUN apk update

COPY --from=builder /source/myapp /myapp

ENTRYPOINT ./myapp