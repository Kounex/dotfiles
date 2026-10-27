# Kubernetes / OpenShift helpers. Only defined where the CLI exists.

if command -v kubectl >/dev/null 2>&1; then
  alias k='kubectl'
  # kcn <namespace>: switch the current context's namespace
  alias kcn='kubectl config set-context --current --namespace'
fi

if command -v oc >/dev/null 2>&1; then
  # approve every pending CSR (node joins)
  alias ocapprovecsr="oc get csr -o go-template='{{range .items}}{{if not .status}}{{.metadata.name}}{{\"\\n\"}}{{end}}{{end}}' | xargs oc adm certificate approve"
  # ocdecsecret <secret> <key>: print one decoded key of a secret
  ocdecsecret() { oc get secret "$1" -o go-template="{{index .data \"$2\" | base64decode}}"; echo; }
fi
