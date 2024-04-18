# PgBouncer custom chart

## Configure PgBouncer
Everything will be done in the helm `values` file.

1. Add your virtual users (authentication) in the list in `config.userlist`.
2. Configure the main destination PostgreSQL server in `.config.postgresql` (hostname and port).
3. Configure (mount) the credentials for the databases through `extraVolumeMounts` and `extraVolumes`.  
  The secret need to have this structure (common structure in C2C):
  ```
  dbname: mydatabase
  host: thehost
  password: mypassword
  port: "5432"
  user: myuser
  ```

## Fine tune the user permissions
Please read here what is PostgreSQL HBA: https://www.postgresql.org/docs/current/auth-pg-hba-conf.html. In a nutshell, it allows you to configure advanced permissions for the users.

This will allow us to configure the permissions for our virtual PgBouncer users.

For that uncomment `config.hba` and configure the file based on the documentation linked above.

## Notes
- You do need to specify the user and their password in the user list for the user to work.
