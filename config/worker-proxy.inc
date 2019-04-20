bind_socket = "*:{{ WORKER_PROXY_PORT }}";

upstream "local" {
    default = yes;
    self_scan = yes;
}