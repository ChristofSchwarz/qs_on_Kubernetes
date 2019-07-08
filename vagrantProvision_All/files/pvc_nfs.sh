kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-qse
  annotations:
    volume.beta.kubernetes.io/storage-class: localnfs
spec:
  storageClassName: localnfs
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
