{% set url = "https://" + domain + ("" if path == "/" else path) -%}

The web interface at `{{ url }}` is admin-only and needs no further login.

Apps on this server reach the API directly on `http://127.0.0.1:{{ port }}`, without a password. Clients on another machine use `{{ url }}/ext`, username `admin`:

**{{ password }}**

You can change it from *Tools > Options > Web UI*, and find it again in this app's admin documentation.
