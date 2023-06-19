# µbox core

[![The MIT License](https://img.shields.io/github/license/mu-box/core)](http://opensource.org/licenses/MIT)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3162/badge)](https://bestpractices.coreinfrastructure.org/projects/3162)
[![Elixir CI](https://github.com/mu-box/core/workflows/Elixir%20CI/badge.svg)](https://github.com/mu-box/core/actions?query=workflow%3A%22Elixir+CI%22)

[![Discord](https://img.shields.io/discord/610589644651888651?logo=discord&style=social)](https://discord.gg/MCDdHfy)
[![GitHub stars](https://img.shields.io/github/stars/mu-box/core?style=social)](https://github.com/mu-box/core)

[![IssueHunt](https://img.shields.io/badge/fund-an_issue-blue)](https://issuehunt.io/o/mu-box)
[![ko-fi](https://img.shields.io/badge/donate-on_ko--fi-blue)](https://ko-fi.com/microbox)
[![Patreon](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fpatreon-shields-io.herokuapp.com%2Fmicrobox%2Fpledges)](https://patreon.com/microbox)
[![Liberapay](https://img.shields.io/liberapay/receives/microbox?logo=liberapay)](https://liberapay.com/microbox/)

Microbox (aka µbox, mu-box, or mi-box, depending on who you talk to) is an open-
source clone of Nanobox, focusing initially on feature-parity with Nanobox v1
(boxfiles), then on adding features and maintaining the boxfile approach moving
forward. Doing this will require making some changes to some of the tooling and
Docker images used, for example to switch package managers to something that
will take less time to maintain when new package versions are released. More
information on this process will be added to the project documentation (check
the `docs/` directory) as it gets fleshed out.

For now, just getting the basic Nanobox features implemented will go a long way
in getting the project up and running.

- [ ] Dashboard
   - [x] Accounts
      - [x] Registration
      - [x] Login
      - [x] Social Login
      - [x] _2FA_ \*
      - [x] Settings Management
         - [x] _Connected Social Accounts_ \*
         - [x] Hosting Accounts ([#4][])
         - [x] Teams ([#3][])
            - [x] Membership ([#3][])
            - [ ] Apps ([#5][])
            - [x] _Permissions_ \*
         - [ ] Plans and Billing
   - [ ] Apps
      - [ ] Create ([#5][])
      - [ ] Manage
         - [ ] Servers ([#5][])
            - [ ] Reboot
            - [ ] Console
         - [ ] Components ([#5][], [#8][])
            - [ ] Restart
            - [ ] Rebuild
            - [ ] Move ([#6][])
            - [ ] Console
         - [ ] Ownership
         - [ ] Settings
         - [ ] Evars ([#9][])
         - [ ] SSL ([#9][])
      - [ ] Monitor
         - [ ] Logs
         - [ ] Stats
      - [ ] Deploy ([#8][])
      - [ ] _Migrate_ \*
      - [ ] Scale ([#6][])
      - [ ] Destroy ([#7][])
- [ ] Hosting Provider API ([#4][], [#5][], [#6][], [#7][], [#9][])
- [ ] MicroAgent API ([#5][], [#6][], [#7][])
- [ ] DNS API (shaman) ([#5][], [#6][], [#7][])
- [ ] CLI API ([#8][])
- [ ] Platform Component APIs ([#5][], [#9][])
   - [ ] Portal (load balancer)
   - [ ] Pulse (monitor)
   - [ ] Hoarder (warehouse)
   - [ ] Mist (message bus)
   - [ ] LogVac (logger)

\* Items _in italics_ are not supported by Nanobox, but are seen as essential to
an initial release, for ensuring the most buy-in from folks looking for Nanobox
alternatives.

[#3]: https://github.com/mu-box/core/issues/3
[#4]: https://github.com/mu-box/core/issues/4
[#5]: https://github.com/mu-box/core/issues/5
[#6]: https://github.com/mu-box/core/issues/6
[#7]: https://github.com/mu-box/core/issues/7
[#8]: https://github.com/mu-box/core/issues/8
[#9]: https://github.com/mu-box/core/issues/9

## Project Setup

### Local

If you're setting up Microbox Core in your own development environment, the
easiest (and only supported) way to do it is with the Microbox CLI. Setting that
up is beyond the scope of this document, but once it's in place, you only need
to do a couple of things to get started.

In the directory where you've cloned the Core's code:

```sh
microbox dns add local microbox.local
microbox run node-start mix phx.server
```

And you should be off and running!

### Deployed

The section below outlines what Microbox uses. Folks installing and running
their own copies are free to use whatever works best for them.

#### Domains

##### Root

-   `microbox` is the canonical domain, with `mubox`, `mibox`, `mu-box`, and
    `mi-box` redirecting back to it (get `µbox` too, if the two-scripts thing
    can be worked out/around)
-   `xn-box-wyc` is for staging and testing before deploying to `microbox` (from
    an intentional typo of `xn--box-wyc`, the punycode of `µbox`, which we can't
    actually register because it's a mixed-script name)

##### TLDs

-   `.co`/`.com`/`.io`/`.space`/`.site`/`.website` redirect to `.cloud`
-   `.rocks` for community things

##### SLDs

-   `microbox.cloud` for onboarding (explain, register, etc)
-   `dashboard.microbox.cloud` for the account and app management dashboard
-   `api.microbox.cloud` for the API documented in `docs/core-api.yaml`
-   ...

##### FQDs

-   `:guid.:user.microbox.dev` for exposing local dev instances to the
    Internet (not currently supported by Nanobox)
-   `:app.:user.microbox.app` for apps
-   `:instance.:app.:team.microbox.team` for team apps
-   `:app.:team.microbox.live` for HA, A/B, etc

## Sponsors!

[Giacomo Trezzi (@G3z)](https://github.com/G3z)
