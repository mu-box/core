# µbox core

Microbox (aka µbox, mu-box, or mi-box, depending on who you talk to) is an open
source "fork" of [Nanobox](https://nanobox.io), focusing initially on
feature-parity with Nanobox v1 (boxfiles), then on adding features and
maintaining the boxfile approach moving forward. Doing this will require making
some changes to some of the tooling and Docker images used, for example to
switch package managers to something that will take less time to maintain when
new package versions are released. More information on this process will be
added to the project documentation (at the moment, this README) as it gets
fleshed out.

For now, just getting the basic Nanobox features implemented will go a long way
in getting the project up and running.

- [ ] Accounts
   - [x] Registration
   - [x] Login
   - [x] Social Login
   - [ ] _2FA_ \*
   - [ ] Settings Management
      - [x] _Connected Social Accounts_ \*
      - [ ] Hosting Accounts
      - [ ] Teams
         - [ ] Membership
         - [ ] Apps
         - [ ] _Permissions_ \*
      - [ ] Plans and Billing? (need to talk to DO about whether we can do this)
- [ ] Apps
   - [ ] _Import from Nanobox_ \*
   - [ ] Create
   - [ ] Manage
      - [ ] Servers
         - [ ] Reboot
         - [ ] Console
      - [ ] Components
         - [ ] Restart
         - [ ] Rebuild
         - [ ] Move
         - [ ] Console
      - [ ] Ownership
      - [ ] Settings
      - [ ] Evars
      - [ ] SSL
   - [ ] Monitor
      - [ ] Logs
      - [ ] Stats
   - [ ] Deploy
   - [ ] _Migrate_ \*
   - [ ] Scale
   - [ ] Destroy

\* Items _in italics_ are not supported by Nanobox, but are seen as essential to
an initial release, for ensuring the most buy-in from folks looking for Nanobox
alternatives.

### Domains

The section below outlines what Microbox uses. Folks installing and running
their own copies are free to use whatever works best for them.

#### Root

-   `microbox` is the canonical domain, with `mubox` redirecting back to it (get
    `µbox` too, if the two-scripts thing can be worked out/around)
-   `xn-box-wyc` is for staging and testing before deploying to `microbox` (from
    an intentional typo of `xn--box-wyc`, the punycode of `µbox`, which we can't
    actually register because it's a mixed-script name)

#### TLDs

-   `.co`/`.com`/`.space` redirect to `.cloud`, for the dashboard and other
    "official" stuff that belongs to µbox itself
-   `.rocks` for community things
-   `:app.:user.microbox.app` for apps
-   `:instance.:app.:team.microbox.team` for team apps
-   `:app.:team.microbox.live` for HA, A/B, etc

#### SLDs

-   `.` (the root) for onboarding (explain, register, etc)
-   `dashboard.` for the account and app management dashboard
-   `api.` for the API documented in `openapi.yaml` (and converted to several
    other formats besides)
-   ...
