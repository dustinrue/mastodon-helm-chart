# Mastodon Helm Chart

In this repo is what I created when attempting to test Mastodon (https://github.com/mastodon/mastodon) running on Kubernetes. I did this purely to learn and am providing it for reference. 

This chart pulls in a lot of work from the chart provided by the main project but removes external dependencies. I feel that those dependencies should be left to the server administrator to decide on and setup manually. This chart also allows you to break the Sidekiq queues out into discrete deployments for each queue and allows you to enable autoscaling for Sidekiq, Web and Streaming individually. At this time, Sidekiq autoscaling min/max values will affect all Sidekiq deployments except the scheduler which is locked to one in accordance to the documentation.

## Requirements

Running your own Mastodon server is the perfect way to maintain complete control over your social media experience. That said, there are some things you need to consider when running this helm chart:

* It may not be cheap in terms of actual cash paid for hosting or your time.
* You need experience with a number of different systems including Kubernetes itself and CDN/S3.
* A familiarity with PostgreSQL and Redis do not hurt but not absolutely necessary. You at least need to understand how to setup and get credentials for each.

If those haven't scared you off then here are the things you will need to host your own instance of Mastodon:

* You must have an S3 compatible provider. This helm chart does not support any other media storage solution by design. I use Cloudflare's R2
* I highly encourage you to use a CDN in front of your server. Again, I use Cloudflare.
* A PostgreSQL database. If you are comfortable with it, you can install this into Kubernetes as well or use a managed solution provided by your cloud provider. I install PostgreSQL into my Kubernetes cluster.
* Like PostgreSQL, you also need Redis. You can host this in your Kubernetes cluster or use a managed service. I install Redis into my Kubernetes cluster.
* You must be able to provide persistent storage for your database and less importantly Redis. In my setup I am using TrueNAS Core but you can use whatever solution your provider offers.
* A mail relay provider. This one is not _fully_ necessary if you are running just a private instance. You can get away with sending mail to mailhog. There are a number of mail relay services like Mailgun or SendInBlue. I use SendInBlue's free tier.

You can learn more over at [https://docs.joinmastodon.org/user/run-your-own/](https://docs.joinmastodon.org/user/run-your-own/)

### Special Note

Definitely take care to protect all of these services! The only thing exposed publicy should be your Ingress system, preferably using a load balancer that is exposed with everything else behind a firewall.


## Usage

I am assuming you have a good understanding of using Kubernetes. I also assume you are familiar with helm. You'll need helm 3. You will need to adjust the values files I provide. There are many settings that are specific to my setup, like using ingress-nginx and democratic-csi to provision iSCSI storage from TrueNAS. In my limited testing, this can also work with traefik ingress controller.

Be sure to adjust settings for your environment. Below is information about how to get this running using Redis and PostgreSQL in your Kube cluster. This shouldn't be considered a "production" configuration but can certainly work for a personal setup if you wanted to.

I have included some example values files for running PostgreSQL and Redis in your Kubernetes cluster. You will find them in examples directory.

### Add Helm Repositories

If you wish to run everything in Kubernetes, including Redis and PostgreSQL do the following.

* `helm repo add bitnami https://charts.bitnami.com/bitnami`
* `helm repo add codecentric https://codecentric.github.io/helm-charts`
* `helm repo add dustinrue https://helm.dustinrue.com`

### Install Prereqs

According to the install docs, PostgreSQL and Redis are both required to be running and accessible. For this I simply installed Bitnami's with some settings defined. In this repo you will find the values I used. Install these items doing something like:

* `helm install -f postgresql.yaml -n mastodon --create-namespace postgresql bitnami/postgresql`
* `helm install -f redis.yaml -n mastodon redis bitnami/redis`
* `helm install -f mailhog.yaml -n mastodon mailhog codecentric/mailhog`

Remember the examples directory contains the above mentioned values files.

### Installing Mastodon

In the helm directory, edit the values file or create a new one and reference it using `-f <filename>` to match your settings. Then apply to your cluster with:

* `helm install -n mastodon mastodon dustinrue/mastodon`

This will install multiple copies of the Mastodon docker image, each running a specific aspect of Mastodon including web, streaming and sidekiq. In my testing I was able to do everything a normal Mastodon instance can do. What I did not do was setup any storage for media uploads.

## Database Backups

You can, optionally, create an automatic database backup cronjob. To enable this you must manually create a Persistent Volume Claim of type "ReadWriteMany" and provide the name of the PVC to this chart. Here is an example PVC:

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

You can find me at https://mastodon.chateaude.luxe/@dustinrue
