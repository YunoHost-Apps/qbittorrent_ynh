{% set url = "https://" + domain + ("" if path == "/" else path) -%}

## Interface web

Réservée aux administrateurs YunoHost. Être connecté au portail suffit, il n'y a pas de second login.

## Accès à l'API

Les applications de ce serveur (Radarr, Sonarr…) joignent qBittorrent directement, sans mot de passe :

- `http://127.0.0.1:{{ port }}`

Les clients d'une autre machine passent par un point d'entrée public, que qBittorrent authentifie :

- `{{ url }}/ext`, nom d'utilisateur `admin`
{% if password %}- Mot de passe : `{{ password }}` — généré à l'installation ou à la mise à jour. Si vous l'avez changé depuis dans *Outils > Options > Interface Web*, c'est le vôtre qui s'applique.{% else %}- Mot de passe : celui que vous avez défini dans *Outils > Options > Interface Web*{% endif %}

Les deux prennent `/api/v2/…` comme d'habitude. Gardez un mot de passe défini : c'est lui qui garde `/ext`.

Si tous vos clients tournent sur ce serveur, retirez le groupe `visitors` de la permission `api` pour fermer `/ext`.
