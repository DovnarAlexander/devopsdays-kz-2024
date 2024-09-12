{{/*
Create the name of the service account to use
*/}}
{{- define "library.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Render an array of env variables. The input can be a map or a slice.
Values can be templates using the "common.tplvalues.render" helper, but changes to scope are not processed.
Usage:
{{ include "library.toEnvArray" ( dict "envVars" .Values.envVars "context" $ ) }}
*/}}
{{- define "library.toEnvArray" -}}
{{- if kindIs "map" .envVars }}
{{- range $key, $val := .envVars }}
- name: {{ $key }}
{{- if kindIs "string" $val }}
  value: {{ include "common.tplvalues.render" (dict "value" $val "context" $.context) }}
{{- else if kindIs "map" $val }}
{{ include "common.tplvalues.render" (dict "value" (omit $val "name") "context" $.context) | indent 2 }}
{{- end -}}
{{- end -}}
{{- else if kindIs "slice" .envVars }}
{{ include "common.tplvalues.render" (dict "value" .envVars "context" $.context) }}
{{- end }}
{{- end -}}

{{- define "library.image" -}}
{{- $registryName := default .imageRoot.registry ((.global).imageRegistry) -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $separator := ":" -}}
{{- $termination := .imageRoot.tag | toString -}}

{{- if not .imageRoot.tag }}
  {{- if .chart }}
    {{- $termination = .chart.AppVersion | toString -}}
  {{- end -}}
{{- end -}}
{{- if .imageRoot.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .imageRoot.digest | toString -}}
{{- end -}}
{{- if $registryName }}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- else -}}
    {{- printf "%s%s%s"  $repositoryName $separator $termination -}}
{{- end -}}
{{- end -}}