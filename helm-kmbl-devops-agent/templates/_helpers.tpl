{{/*
Expand the name of the chart.
*/}}
{{- define "helm-kmbl-devops-agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helm-kmbl-devops-agent.fullname" -}}
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
{{- define "helm-kmbl-devops-agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm-kmbl-devops-agent.labels" -}}
helm.sh/chart: {{ include "helm-kmbl-devops-agent.chart" . }}
{{ include "helm-kmbl-devops-agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm-kmbl-devops-agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-kmbl-devops-agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helm-kmbl-devops-agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "helm-kmbl-devops-agent.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Prepare container image name
*/}}
{{- define "app.image"}}
{{- if eq .Values.statefulset.image.registry ""}}
{{- .Values.statefulset.image.repository }}:{{ .Values.statefulset.image.tag | default .Chart.AppVersion }}
{{- else}}
{{- .Values.statefulset.image.registry }}/{{ .Values.statefulset.image.repository }}:{{ .Values.statefulset.image.tag | default .Chart.AppVersion }}
{{- end}}
{{- end}}
