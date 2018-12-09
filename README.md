# fp8-busytools

A very simple docker image based on busybox with helper commands.

## Commands

#### /bin/exec.sh

Couldn't figure out how to run multiple command easily when preparing
a container for Kubernetes.  Sample usage:

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: redis-config
data:
  redis.conf.master: |
    requirepass 12345
---
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: exec-test
spec:
  selector:
    matchLabels:
      app: exec-test  # has to match .spec.template.metadata.labels
  replicas: 1
  template:
    metadata:
      labels:
        app: exec-test  # has to match .spec.selector.matchLabels
    spec:
      containers:
      - name: exec-test
        image: redis:5-alpine
        command: ["tail", "-f", "/dev/null"]
        volumeMounts:
          - name: cache-volume
            mountPath: /etc/redis/
      initContainers:
      - name: exec-test-init
        image: faport/fp8-busytools
        imagePullPolicy: Never
        args:
          - cp /fp8-config/* /etc/redis/
          - chown 100:100 /etc/redis/*
        volumeMounts:
        - name: config-volume
          mountPath: /fp8-config
        - name: cache-volume
          mountPath: /etc/redis/
      volumes:
      - name: config-volume
        configMap:
          name: redis-config
      - name: cache-volume
        emptyDir: {}

```