- CLI (or other client-side tool) signals that a snapshot is ready to deploy
    - validate boxfile
    - verify that data components have been removed from the server before the boxfile
    - other basic sanity checks?
- create new data containers for new or reconfigured components
    - instruct agent to install images for data components
    - instruct agent to create containers for data components
    - configure data components
    - perform initial migration for reconfigured components
    - stop old reconfigured data components
    - perform final migration for reconfigured components
    - start new data components
- update evars on all code components
- (if determined to be necessary to update the evars) restart all code components
- instruct agent to remove containers for old data components
- create new code containers for all components
    - instruct agent to install image for code components
    - instruct agent to create containers for code components
    - configure code components
    - load /data and /app into code components from warehouse archives
- run transform hooks
- lock down files and folders to prevent changes
- start code components
- run before_live hooks
- update services and routes in Portal, as well as any additional evars
- destroy old code components
    - stop code components
    - instruct agent to remove containers for code components
- run after_live hooks
