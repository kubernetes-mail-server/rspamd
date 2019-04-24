bind_socket = "*:{{ RSPAMD_WORKER_PROXY_PORT }}";

upstream "local" {
    default = yes;
    self_scan = yes;
}