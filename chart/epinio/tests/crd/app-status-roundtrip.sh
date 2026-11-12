#!/usr/bin/env bash
# Round-trip check for the App CRD status schema (EPINIO-781).
#
# Undeclared status fields are pruned silently: the write returns success and
# the data is gone. A successful `kubectl patch` therefore proves nothing on its
# own, so this script reads every field back and fails if any value is missing.
# It also checks that finishedat is validated as date-time and that durationms
# rejects non-integers.
#
# Usage:
#   chart/epinio/tests/crd/app-status-roundtrip.sh
#       run against the current kubectl context
#   CREATE_KIND=1 [KIND_BIN=kind.exe] chart/epinio/tests/crd/app-status-roundtrip.sh
#       create a throwaway kind cluster, run, and delete it afterwards
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
CRD="$HERE/../../crds/app-crd.yaml"
NS="epinio-crd-roundtrip"
APP="roundtrip-app"
KIND_NAME="epinio-crd-roundtrip"
KIND_BIN="${KIND_BIN:-kind}"
FAILS=0

cleanup() {
  kubectl delete namespace "$NS" --ignore-not-found --wait=false >/dev/null 2>&1
  if [ "${CREATE_KIND:-0}" = "1" ]; then
    "$KIND_BIN" delete cluster --name "$KIND_NAME" >/dev/null 2>&1
  fi
}
trap cleanup EXIT

pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; FAILS=$((FAILS + 1)); }

# expect <jsonpath-without-braces> <expected-value> <label>
expect() {
  local got
  got="$(kubectl get app "$APP" -n "$NS" -o "jsonpath={$1}" 2>/dev/null)"
  if [ "$got" = "$2" ]; then
    pass "$3 = $2"
  else
    fail "$3: expected '$2', got '${got:-<empty>}' (field pruned or not written)"
  fi
}

patch_status() {
  kubectl patch app "$APP" -n "$NS" --subresource=status --type=merge -p "$1"
}

if [ "${CREATE_KIND:-0}" = "1" ]; then
  "$KIND_BIN" create cluster --name "$KIND_NAME" --wait 120s || { echo "kind create failed"; exit 1; }
fi

kubectl apply -f "$CRD" || { echo "CRD apply failed"; exit 1; }
kubectl wait --for=condition=established --timeout=90s crd/apps.application.epinio.io \
  || { echo "CRD not established"; exit 1; }

kubectl create namespace "$NS" >/dev/null 2>&1
kubectl apply -n "$NS" -f - >/dev/null <<EOF || { echo "could not create App CR"; exit 1; }
apiVersion: application.epinio.io/v1
kind: App
metadata:
  name: $APP
spec:
  origin:
    container: nginx:stable
EOF

# 1. Full write through the status subresource, then read every field back.
PAYLOAD='{"status":{
  "lastbuild":{"durationms":12345,"finishedat":"2026-11-09T10:15:30Z","result":"succeeded","stageid":"stage-build-001"},
  "lastdeploy":{"durationms":678,"finishedat":"2026-11-09T10:20:00Z","result":"failed","stageid":"stage-deploy-002"}
}}'
if patch_status "$PAYLOAD" >/dev/null; then
  expect '.status.lastbuild.durationms'  '12345'                    'lastbuild.durationms'
  expect '.status.lastbuild.finishedat'  '2026-11-09T10:15:30Z'     'lastbuild.finishedat'
  expect '.status.lastbuild.result'      'succeeded'                'lastbuild.result'
  expect '.status.lastbuild.stageid'     'stage-build-001'          'lastbuild.stageid'
  expect '.status.lastdeploy.durationms' '678'                      'lastdeploy.durationms'
  expect '.status.lastdeploy.finishedat' '2026-11-09T10:20:00Z'     'lastdeploy.finishedat'
  expect '.status.lastdeploy.result'     'failed'                   'lastdeploy.result'
  expect '.status.lastdeploy.stageid'    'stage-deploy-002'         'lastdeploy.stageid'
else
  fail "full status patch was rejected"
fi

# 2. Schema validation: a non-RFC3339 timestamp must be rejected.
if patch_status '{"status":{"lastbuild":{"finishedat":"yesterday"}}}' >/dev/null 2>&1; then
  fail "finishedat='yesterday' was accepted; format: date-time is not enforced"
else
  pass "finishedat='yesterday' rejected by schema"
fi

# 3. Schema validation: durationms must be an integer.
if patch_status '{"status":{"lastdeploy":{"durationms":"fast"}}}' >/dev/null 2>&1; then
  fail "durationms='fast' was accepted; type: integer is not enforced"
else
  pass "durationms='fast' rejected by schema"
fi

if [ "$FAILS" -gt 0 ]; then
  echo "$FAILS check(s) failed"
  exit 1
fi
echo "All App CRD status round-trip checks passed"
