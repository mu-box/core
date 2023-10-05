- user provides Nanobox creds
- ask Nanobox API what apps those creds have access to
- let user select apps to import
- get detailed info about apps
- create temporary apps with that info
- connect temp apps to Nanobox-controlled servers
    - retrieve service IPs from Nanobox API
    - retrtive platform component service tokens via Nanobox API
    - retrieve SSH creds for `{provider}.1` via Nanobox API's console endpoint
        - if that fails, try `{provider}.2`, then `{provider}.3`, then ...
        - if all those fail, something is very wrong, and the import will fail
    - SSH in to get Nanoagent config, and associated token
    - use Nanoagent to get the list of other IPs belonging to that app
    - use Nanoagent to get the list of components on that server
    - install updated SSH public key so we can connect without a console session
    - continue the process above until all servers/components are accounted for
- give user migration options to select where to migrate to
- migrate temp apps to full apps
- tell user to destroy apps in Nanobox and repoint DNS