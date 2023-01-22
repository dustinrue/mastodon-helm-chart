{{/*
Expand the name of the chart.
*/}}
{{- define "mastodon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mastodon.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mastodon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mastodon.labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mastodon.sidekiq-default-labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.sidekiq-default-selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mastodon.sidekiq-ingress-labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.sidekiq-ingress-selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mastodon.sidekiq-mailers-labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.sidekiq-mailers-selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mastodon.sidekiq-pull-labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.sidekiq-pull-selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mastodon.sidekiq-push-labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.sidekiq-push-selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mastodon.sidekiq-scheduler-labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.sidekiq-scheduler-selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mastodon.sidekiq-combined-labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.sidekiq-combined-selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mastodon.streaming-labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.streaming-selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mastodon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mastodon.sidekiq-default-selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}-sidekiq-default
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mastodon.sidekiq-ingress-selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}-sidekiq-ingress
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mastodon.sidekiq-mailers-selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}-sidekiq-mailers
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mastodon.sidekiq-pull-selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}-sidekiq-pull
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mastodon.sidekiq-push-selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}-sidekiq-push
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mastodon.sidekiq-scheduler-selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}-sidekiq-scheduler
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mastodon.sidekiq-combined-selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}-sidekiq-combined
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mastodon.streaming-selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}-streaming
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mastodon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mastodon.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


# Items adapted from https://github.com/mastodon/mastodon/blob/51a33ce77a32b85eaff37670c40a497aaef13e18/chart/templates/_helpers.tpl
# Pulled 2022-11-21
{{/*
Rolling pod annotations
*/}}
{{- define "mastodon.rollingPodAnnotations" -}}
rollme: {{ .Release.Revision | quote }}
checksum/config-secrets: {{ include ( print $.Template.BasePath "/secrets/environment.yaml" ) . | sha256sum | quote }}
checksum/config-configmap: {{ include ( print $.Template.BasePath "/configmaps/environment.yaml" ) . | sha256sum | quote }}
{{- end }}

{{/*
Get the mastodon secret.
*/}}
{{- define "mastodon.secretName" -}}
{{- if .Values.mastodon.secrets.existingSecret }}
    {{- printf "%s" (tpl .Values.mastodon.secrets.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "mastodon.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the postgresql secret.
*/}}
{{- define "mastodon.postgresql.secretName" -}}
{{- if .Values.mastodon.postgresql.existingSecret }}
    {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "mastodon.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the redis secret.
*/}}
{{- define "mastodon.redis.secretName" -}}
{{- if .Values.mastodon.redis.existingSecret }}
    {{- printf "%s" (tpl .Values.mastodon.redis.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (tpl .Release.Name $) -}}
{{- end -}}
{{- end -}}
