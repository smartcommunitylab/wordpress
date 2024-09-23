{{/*
Expand the name of the chart.
*/}}
{{- define "wordpress.name" -}}
{{- printf "%s-%s" (default .root.Chart.Name .root.Values.nameOverride) .component | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wordpress.fullname" -}}
{{- if .root.Values.fullnameOverride }}
{{- printf "%s-%s" (.root.Values.fullnameOverride) .component | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .root.Chart.Name .root.Values.nameOverride }}
{{- if contains $name .root.Release.Name }}
{{- printf "%s-%s" (.root.Release.Name) .component | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" .root.Release.Name $name .component | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wordpress.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wordpress.labels" -}}
helm.sh/chart: {{ include "wordpress.chart" .root }}
{{ include "wordpress.selectorLabels" . }}
{{- if .root.Chart.AppVersion }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
app.kubernetes.io/part-of: {{ .root.Chart.Name }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wordpress.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wordpress.name" . }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "wordpress.serviceAccountName" -}}
{{- if (index .root.Values .component "serviceAccount" "create") }}
{{- default (include "wordpress.fullname" . ) (index .root.Values .component "serviceAccount" "name") }}
{{- else }}
{{- default "default" index (.root.Values .component "serviceAccount" "name") }}
{{- end }}
{{- end }}

{{/*
Create the name of the PVC or use existing one
*/}}
{{- define "wordpress.pvcName" -}}
{{- default (printf "%s-%s" .Release.Name "shared-dir") .Values.persistence.existingPvc | trunc 63 | trimSuffix "-" }}
{{- end }}
