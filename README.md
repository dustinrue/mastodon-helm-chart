# Mastodon Helm Chart

In this repo is what I created when attempting to test Mastodon (https://github.com/mastodon/mastodon) running on Kubernetes. I did this purely to learn and am providing it for reference. I will not go into great detail on how to set this up.

This chart pulls in a lot of work from the chart provided by the main project but removes external dependencies. I feel that those dependencies should be left to the server administrator to decide on and setup manually. This chart also breaks Sidekiq out into discrete deployments for each queue and allows you to enable autoscaling for Sidekiq, Web and Streaming individually. At this time, Sidekiq autoscaling min/max values will affect all Sidekiq deployments except the scheduler which is locked to one in accordance to the documentation.

## Usage

I am assuming you have a basic understanding of using Kubernetes. I also assume you are familiar with helm. You'll need helm 3. You will very likely need to adjust the values files I provide. There are many settings that are specific to my setup, like using ingress-nginx and democratic-csi to provision iscsi storage from TrueNAS.

Be sure to adjust settings for your environment. Below is information about how to get this running using Redis and PostgreSQL in your Kube cluster. This shouldn't be considered a "production" configuration but can certainly work for a personal setup if you wanted to.

### Add Helm Repositories

If you wish to run everything in Kubernetes, including Redis and PostgreSQL do the following.

* `helm repo add bitnami https://charts.bitnami.com/bitnami`
* `helm repo add codecentric https://codecentric.github.io/helm-charts`

### Install Prereqs

According to the install docs, PostgreSQL and Redis are both required to be running and accessible. For this I simply installed Bitnami's with some settings defined. In this repo you will find the values I used. Install these items doing something like:

* `helm install -f postgresql.yaml -n mastodon --create-namespace postgresql bitnami/postgresql`
* `helm install -f redis.yaml -n mastodon redis bitnami/redis`
* `helm install -f mailhog.yaml -n mastodon mailhog codecentric/mailhog`

### Installing Mastodon

In the helm directory, edit the values file or create a new one and reference it using `-f <filename>` to match your settings. Then apply to your cluster with:

* `helm install -n mastodon mastodon .`

This will install multiple copies of the Mastodon docker image, each running a specific aspect of Mastodon including web, streaming and sidekiq. In my testing I was able to do everything a normal Mastodon instance can do. What I did not do was setup any storage for media uploads.

## Database Backups

You can, optionally, create an automatic database backup cronjob. To enable this you must manually create a Persistent Volume Claim of time "ReadWriteMany" and provide the name of the PVC to this chart. Here is an example PVC:

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-postgresql-backup-0
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 8Gi
  storageClassName: freenas-nfs-csi
```

Next, set the cronjob option to enabled and add the PVC name:

```
...
  cron:
    databaseBackup:
      enabled: true
      schedule: "0 3 * * *"
      volumeClaimName: "data-postgresql-backup-0"
```

You can also enable a utility container that will mount the same directory which you can use to verify the backups or, if needed, restore a backup. To do so add:

```
dbutils:
  enabled: false
```

to your values file

## Contact

You can find me @dustinrue@fosstodon.org 
