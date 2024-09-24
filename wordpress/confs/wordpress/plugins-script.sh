#!/usr/bin/env bash
{{- if .Values.jobs.plugins.deleteUnused -}}
echo "Removing unused plugins..."
wp plugin delete hello
wp plugin delete akismet
{{- end -}}

{{ if and .Values.jobs.plugins.w3tc.enabled .Values.redis.enabled }}
redisHost=${REDIS_HOST}
redisPort=${REDIS_PORT}

wp plugin install w3-total-cache
wp plugin activate w3-total-cache

wp total-cache option set dbcache.engine redis --type=string
wp total-cache option set dbcache.redis.servers "$redisHost:$redisPort" --type=string
wp total-cache option set dbcache.enabled true --type=boolean

wp total-cache option set objectcache.engine redis --type=string
wp total-cache option set objectcache.redis.servers "$redisHost:$redisPort" --type=string
wp total-cache option set objectcache.enabled true --type=boolean

wp total-cache option set pgcache.engine file_generic --type=string
wp total-cache option set pgcache.enabled true --type=boolean

wp total-cache option set lazyload.enabled true --type=boolean
wp total-cache option set lazyload_process_background true --type=boolean

wp total-cache option set extensions.active '{"imageservice": "w3-total-cache\/Extension_ImageService_Plugin.php"}' --type=json
wp total-cache option set extensions.active_frontend '{"imageservice": "*"}' --type=json
wp total-cache option set extension.imageservice true --type=boolean

wp total-cache option set browsercache.cssjs.cache.control true --type=boolean
wp total-cache option set browsercache.html.cache.control true --type=boolean
wp total-cache option set browsercache.other.cache.control true --type=boolean

wp total-cache option set common.track_usage false --type=boolean

wp total-cache flush all
{{- end -}}
