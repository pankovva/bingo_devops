FROM alpine


RUN mkdir -p /opt/bingo && \
             mkdir -p /opt/bongo/logs/12690b3e5e && \
             ln -s /proc/1/fd/1 /opt/bongo/logs/12690b3e5e/main.log && \
             addgroup --gid 1000 nonroot && \
             adduser --u 1000 -G nonroot -g "" -D  nonroot && \
             apk --no-cache  add strace curl && \
             rm -vrf /var/cache/apk/*

COPY --chown=nonroot:nonroot bingo /opt/bingo/ 
RUN chown -R nonroot:nonroot /opt && \
    chmod -R 755 /opt/bingo/bingo

WORKDIR /opt/bingo
EXPOSE 15220/TCP
USER nonroot
CMD ["./bingo", "run_server" ]