{% set url = "https://" + domain + ("" if path == "/" else path) -%}

L'interface web sur `{{ url }}` est réservée aux administrateurs et ne demande aucune autre connexion.

Les applications de ce serveur joignent l'API directement sur `http://127.0.0.1:{{ port }}`, sans mot de passe. Les clients d'une autre machine utilisent `{{ url }}/ext`, nom d'utilisateur `admin` :

**{{ password }}**

Vous pouvez le changer dans *Outils > Options > Interface Web*, et le retrouver dans la documentation d'administration de cette application.
