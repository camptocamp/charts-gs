# volumes

* `geocontrib_media`: contains files which look like user-contributed (uploaded) resources
* `geocontrib_static`: contains several (front) js / css / images files
* `geocontrib_config_front`: contains a json file, can probably be stored as a `configMap` instead

# containers

* `geocontrib-celery`
* `geocontrib-celery-beat`
* `geocontrib-frontend`
* `geocontrib-redis`
* `geocontrib`

I would assume that `celery` and `celery-beat` are independent and don't need to expose a service object internally.

# Environment variables

A bunch are shared between the `celery`, `celery-beat`, `geocontrib` containers.
