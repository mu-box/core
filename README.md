# µbox core

![MIT License](https://img.shields.io/github/license/mu-box/core)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3162/badge)](https://bestpractices.coreinfrastructure.org/projects/3162)

[![Discord](https://img.shields.io/discord/610589644651888651?logo=discord&style=social)](https://discord.gg/MCDdHfy)
![GitHub stars](https://img.shields.io/github/stars/mu-box/core?style=social)

[![IssueHunt](https://img.shields.io/badge/fund-an_issue-blue)](https://issuehunt.io/o/mu-box)
[![ko-fi](https://img.shields.io/badge/donate-on_ko--fi-blue)](https://ko-fi.com/microbox)
[![Patreon](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.herokuapp.com%2Fmicrobox%2Fpledges)](https://patreon.com/microbox)
[![Liberapay](https://img.shields.io/liberapay/receives/microbox?logo=liberapay)](https://liberapay.com/microbox/)

Microbox (aka µbox, mu-box, or mi-box, depending on who you talk to) is an open
source clone of [Nanobox](https://nanobox.io), focusing initially on
feature-parity with Nanobox v1 (boxfiles), then on adding features and
maintaining the boxfile approach moving forward. Doing this will require making
some changes to some of the tooling and Docker images used, for example to
switch package managers to something that will take less time to maintain when
new package versions are released. More information on this process will be
added to the project documentation (at the moment, this README) as it gets
fleshed out.

For now, just getting the basic Nanobox features implemented will go a long way
in getting the project up and running.

- [ ] Dashboard
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
         - [ ] Plans and Billing
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
- [ ] Hosting Provider API
- [ ] MicroAgent API
- [ ] DNS API (shaman)
- [ ] CLI API
- [ ] Platform Component APIs
   - [ ] Portal (load balancer)
   - [ ] Pulse (monitor)
   - [ ] Hoarder (warehouse)
   - [ ] Mist (message bus)
   - [ ] LogVac (logger)

\* Items _in italics_ are not supported by Nanobox, but are seen as essential to
an initial release, for ensuring the most buy-in from folks looking for Nanobox
alternatives.

### Domains

The section below outlines what Microbox uses. Folks installing and running
their own copies are free to use whatever works best for them.

#### Root

-   `microbox` is the canonical domain, with `mubox`, `mibox`, `mu-box`, and
    `mi-box` redirecting back to it (get `µbox` too, if the two-scripts thing
    can be worked out/around)
-   `xn-box-wyc` is for staging and testing before deploying to `microbox` (from
    an intentional typo of `xn--box-wyc`, the punycode of `µbox`, which we can't
    actually register because it's a mixed-script name)

#### TLDs

-   `.co`/`.com`/`.io`/`.space`/`.site`/`.website` redirect to `.cloud`
-   `.rocks` for community things

#### SLDs

-   `microbox.cloud` for onboarding (explain, register, etc)
-   `dashboard.microbox.cloud` for the account and app management dashboard
-   `api.microbox.cloud` for the API documented in `docs/core/openapi.yaml` (and
    converted to several other formats besides)
-   ...

#### FQDs

-   `:random_id.:user.microbox.dev` for exposing local dev instances to the
    Internet (not currently supported by Nanobox)
-   `:app.:user.microbox.app` for apps
-   `:instance.:app.:team.microbox.team` for team apps
-   `:app.:team.microbox.live` for HA, A/B, etc
