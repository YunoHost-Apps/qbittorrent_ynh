{% set url = "https://" + domain + ("" if path == "/" else path) -%}

## Web interface

Restricted to YunoHost admins. Being logged into the portal is enough, there is no second login.

## API access

Apps on this server (Radarr, Sonarr…) reach qBittorrent directly, without a password:

- `http://127.0.0.1:{{ port }}`

Clients on another machine go through a public entry point, which qBittorrent authenticates:

- `{{ url }}/ext`, username `admin`
{% if password %}- Password: `{{ password }}` — generated at install or upgrade. If you changed it from *Tools > Options > Web UI* since, yours applies.{% else %}- Password: the one you set from *Tools > Options > Web UI*{% endif %}

Both take `/api/v2/…` as usual. Keep a password set: it is what guards `/ext`.

If all your clients run on this server, remove the `visitors` group from the `api` permission to close `/ext`.
