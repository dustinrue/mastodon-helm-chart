# Example Mastodon Helm Chart

In this repo is what I created when attempting to test Mastodon (https://github.com/mastodon/mastodon) running on Kubernetes. I did this purely to learn and am providing it for reference. I will not go into great detail on how to set this up.

## Usage

I am assuming you have a basic understanding of using Kubernetes. I also assume you are familiar with helm. You'll need helm 3. You will very likely need to adjust the values files I provide. There are many settings that are specific to my setup, like using ingress-nginx and democratic-csi to provision iscsi storage from TrueNAS.

### Add Jelm Repositories

* `helm repo add bitnami https://charts.bitnami.com/bitnami`
* `helm repo add codecentric https://codecentric.github.io/helm-charts`

### Install Prereqs

According to the install docs, PostgreSQL and Redis are both required to be running and accessible. For this I simply installed Bitnami's with some settings defined. In this repo you will find the values I used. Install these items doing something like:

* `helm install -f postgresql.yaml -n mastodon --create-namespace postgresql bitnami/postgresql`
* `helm install -f redis.yaml -n mastodon redis bitnami/redis`
* `helm install -f mailhog.yaml -n mastodon mailhog codecentric/mailhog`

### Installing Mastodon

In the helm directory, edit the values file to match your settings. Then apply to your cluster with:

* `helm install -n mastodon mastodon .`

This will install three copies of the Mastodon docker image, each running a specific aspect of Mastodon including web, streaming and sidekiq. In my testing I was able to do everything a normal Mastodon instance can do. What I did not do was setup any storage for media uploads.

## Contact

You can find me @dustinrue@fosstodon.org 
