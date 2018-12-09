FROM busybox:1.29

ADD exec.sh /bin/exec.sh

ENTRYPOINT [ "/bin/exec.sh" ]
