#!/usr/bin/env bash
echo "Activating maintenance mode..."
wp maintenance-mode activate

{{ if .Values.jobs.update.core -}}
echo "Updating Wordpress core..."
wp core update
wp core update-db
{{- end }}

{{ if .Values.jobs.update.plugins -}}
echo "Updating all plugins..."
wp plugin update --all
{{- end }}

{{ if .Values.jobs.update.themes -}}
echo "Updating all themes..."
wp theme update --all
{{- end }}

{{ if .Values.jobs.update.languages -}}
echo "Updating Wordpress core and themes languages..."
wp language core update
wp language theme update --all
{{- end }}

wp maintenance-mode deactivate
