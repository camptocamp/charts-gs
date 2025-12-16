# GeoServer DataDir Sync Helm Chart

This Helm chart deploys the [geoserver-datadir-sync](https://github.com/camptocamp/georchestra-docker-images/tree/master/geoserver-datadir-sync) container, which provides automated, bi-directional Git synchronization for GeoServer configuration directories with intelligent conflict resolution, webhook monitoring, and robust error handling.

## Features

✨ **Based on proven git-sync technology**
- Safe automatic conflict resolution
- Intelligent rebase handling for diverged histories
- Graceful degradation on conflicts requiring manual intervention

🔔 **Built-in webhook monitoring** (optional)
- GET requests for simple monitoring (UptimeRobot, etc.)
- POST requests with JSON payloads for advanced integrations
- Notifications on sync success and failure

📁 **inotify + periodic sync**
- Instant sync on file changes via inotify
- Fallback periodic sync (works with NFS)
- Configurable sync interval

🔒 **Branch protection**
- Configure which branch to sync (prevents accidents)
- Repository must be explicitly configured for sync
- Automatic sync configuration for new repos only

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- A Git repository to sync with (optional for local-only mode)
- A webhook endpoint for monitoring (optional for sync notifications)
- SSH deploy key for Git authentication (if using remote repository)

## Installation

```bash
helm install my-datadir-sync ./geoserver-datadir-sync -f values.yaml
```

## Configuration

### Required Configuration

The following values must be configured for the chart to work properly:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `git.username` | Git username for commits | `geoserver-sync` |
| `git.email` | Git email for commits | `geoserver@example.com` |

### Git Remote Configuration (Optional)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `git.remote.name` | Name of the git remote (e.g., `origin`) | `origin` |
| `git.remote.url` | Git repository URL | `git@github.com:your-org/geoserver-datadir.git` |
| `git.remote.branch` | Branch to synchronize | `master` |

### SSH Authentication

The SSH key is automatically mounted as a Kubernetes secret and passed to the container via the `GIT_RSA_DEPLOY_KEY` environment variable.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `secrets.datadirSSHKey` | Private RSA key content (multiline). This will be mounted as a secret. | `""` |

### Webhook Configuration (Optional)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `webhook.url` | Webhook URL for monitoring notifications | `""` |
| `webhook.method` | HTTP method for webhook (`GET` or `POST`) | `GET` |

### Optional Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `config.syncInterval` | Sync interval in milliseconds (inotify timeout) | `500` |
| `config.forceClone` | Force cleanup of directory before cloning (`yes`/`no`) | `no` |
| `config.commitMessage` | Custom commit message (can be a shell command) | `""` |

### Volume Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `volumes.geoserverDatadir` | Volume configuration for GeoServer datadir | PVC with claimName `georchestra-geoserver-datadir` |

## Example Configurations

### Basic Configuration with Remote Repository

```yaml
git:
  username: "geoserver-sync"
  email: "geoserver@example.com"
  remote:
    name: "origin"
    url: "git@github.com:your-org/geoserver-datadir.git"
    branch: "master"

webhook:
  url: "https://heartbeat.uptimerobot.com/your-monitor-id"
  method: "GET"

secrets:
  datadirSSHKey: |
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEA...
    -----END RSA PRIVATE KEY-----

volumes:
  geoserverDatadir:
    persistentVolumeClaim:
      claimName: georchestra-geoserver-datadir
```

### Local Repository Only (No Remote)

```yaml
git:
  username: "local-user"
  email: "local@example.com"
  # No remote configuration needed

# Optional: webhook for monitoring notifications
# webhook:
#   url: "http://localhost:8080/health"
#   method: "GET"

volumes:
  geoserverDatadir:
    persistentVolumeClaim:
      claimName: georchestra-geoserver-datadir
```

### Initialization Only (No Continuous Sync)

```yaml
git:
  username: "init-user"
  email: "init@example.com"
  remote:
    name: "origin"
    url: "git@github.com:org/repo.git"
    branch: "master"

# Optional: webhook for monitoring notifications
# webhook:
#   url: "https://your-monitoring.com/webhook"
#   method: "GET"

secrets:
  datadirSSHKey: |
    -----BEGIN RSA PRIVATE KEY-----
    ...
    -----END RSA PRIVATE KEY-----

volumes:
  geoserverDatadir:
    persistentVolumeClaim:
      claimName: georchestra-geoserver-datadir
```

### Custom Commit Messages

```yaml
git:
  username: "geoserver-sync"
  email: "geoserver@example.com"
  remote:
    name: "origin"
    url: "git@github.com:your-org/geoserver-datadir.git"

webhook:
  url: "https://your-monitoring.com/webhook"

config:
  commitMessage: 'printf "updateSequence "; grep updateSequence global.xml | sed -e "s#.*ce>\(.*\)</up.*#\1#"'

secrets:
  datadirSSHKey: |
    -----BEGIN RSA PRIVATE KEY-----
    ...
    -----END RSA PRIVATE KEY-----

volumes:
  geoserverDatadir:
    persistentVolumeClaim:
      claimName: georchestra-geoserver-datadir
```

## Webhook Configuration

### Simple GET (UptimeRobot, etc.)

```yaml
webhook:
  url: "https://heartbeat.uptimerobot.com/your-monitor-id"
  method: "GET"
```

### POST with JSON payload

```yaml
webhook:
  url: "https://your-service.com/api/webhook"
  method: "POST"
```

POST requests send JSON:
```json
{
  "status": "success",
  "message": "Sync completed: file change: global.xml",
  "timestamp": "2025-12-02T10:30:00Z",
  "hostname": "datadir-sync-container"
}
```

## Troubleshooting

### Container exits immediately

The container performs initialization and then runs continuously to sync changes.

### "ERROR: WEBHOOK_URL is not configured"

Webhook is optional for continuous sync notifications. Set `webhook.url` in your values if you want monitoring notifications. The container will work without webhook configuration.

### "Manual intervention required"

Git-sync detected a conflict it cannot resolve automatically:

```bash
# Connect to container
kubectl exec -it <pod-name> -- bash

# Check git status
git status

# Resolve conflicts manually
git rebase --continue
# or
git rebase --abort

# Restart pod
kubectl delete pod <pod-name>
```

### Sync not working

1. Check container logs: `kubectl logs <pod-name>`
2. Verify git-sync configuration:
   ```bash
   kubectl exec -it <pod-name> -- bash
   git config --get branch.master.sync
   git config --get branch.master.syncNewFiles
   ```
3. Test git-sync manually:
   ```bash
   kubectl exec -it <pod-name> -- git-sync -n -s
   ```

### SSH Authentication Issues

Ensure your deploy key is properly formatted in your values file:

```yaml
secrets:
  datadirSSHKey: |
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEA...
    -----END RSA PRIVATE KEY-----
```

## Migration from Version 1.x

Version 2.0.0 of this chart introduces several changes to align with the new geoserver-datadir-sync image:

### Key Differences

1. **Webhook configuration available**: Set `webhook.url` for monitoring notifications
2. **Restructured values**: Configuration is now organized into `git`, `remote`, `webhook`, `config`, and `secrets` sections
3. **SSH key handling**: The SSH key is now mounted as a secret and passed via `GIT_RSA_DEPLOY_KEY` environment variable

### Migration Steps

Your existing values file will continue to work:
```yaml
secrets:
  datadirSSHKey: |
    -----BEGIN RSA PRIVATE KEY-----
    ...
```

Update to new structure:
```yaml
git:
  username: "geoserver-sync"
  email: "geoserver@example.com"
  remote:
    name: "origin"
    url: "git@github.com:your-org/repo.git"
    branch: "master"

webhook:
  url: "https://your-monitoring.com/webhook"

secrets:
  datadirSSHKey: |
    -----BEGIN RSA PRIVATE KEY-----
    ...
```

### What Changed

- **SSH Key**: Now mounted as a Kubernetes secret and passed via `GIT_RSA_DEPLOY_KEY` environment variable
- **New required fields**: `git.username`, `git.email` (webhook.url is optional)

### Testing the Migration

1. **Deploy the updated chart**:
   ```bash
   helm upgrade my-datadir-sync ./geoserver-datadir-sync -f values.yaml
   ```

2. **Check logs for successful initialization**:
   ```bash
   kubectl logs -f <pod-name>
   ```

3. **Verify the configuration**:
   - Confirm git configuration is applied
   - Verify webhook is being called
   - Make a test change to trigger sync

## How It Works

### On Container Start

1. **Initialization**:
   - Configures git username/email
   - Sets up SSH keys if provided
   - Adds git host to known_hosts

2. **Repository Setup**:
   - **If no .git directory**: Clones from remote OR initializes local repo
   - **If .git exists**: Updates remote configuration, optionally fetches/resets
   - **New repos only**: Automatically configures git-sync settings

3. **Continuous Sync**:
   - Webhook notifications if configured (optional)
   - Starts file watcher with inotify
   - Performs periodic sync on timeout
   - Sends webhook notifications if configured

### Sync Behavior

The underlying [git-sync](https://github.com/simonthum/git-sync) handles:

- **Local changes**: Auto-commits with timestamp
- **Behind remote**: Fast-forward merge
- **Ahead of remote**: Push
- **Diverged**: Rebase and push
- **Conflicts**: Stop sync, require manual intervention

### Error Handling

- **Exit code 1** (conflicts): Container stops, requires manual fix
- **Exit code 3** (network issues): Logs error, continues (retries on next sync)
- **Other errors**: Logged with webhook notification

## License

- **git-sync**: [CC0 1.0 Universal](https://github.com/simonthum/git-sync/blob/master/LICENSE) by Simon Thum and contributors
- **This chart**: Maintained by [Camptocamp](https://github.com/camptocamp)

## Contributing

Issues and pull requests welcome at the [charts-gs](https://github.com/camptocamp/charts-gs) repository.
