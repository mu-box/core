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
   - [ ] 2FA
   - [ ] Settings Management
      - [ ] Hosting Accounts
- [ ] Apps
   - [ ] Create
   - [ ] Deploy
   - [ ] Destroy
- [ ] Teams

### Domains

#### Root

-   `mubox.` is the canonical domain, with `microbox.` redirecting back to it
    (get `µbox.` too, if the two-scripts thing can be worked out/around; We'd
    use `microbox.` as the canonical domain if its `.com` wasn't taken by a
    different project, at the moment. Hopefully that will pass before too long
    and we'll be able to grab it ourselves.)
-   `xn-box-wyc.` is for staging and testing before deploying to `mubox.` (from
    an intentional typo of `xn--box-wyc.`, the punycode of `µbox`, which we
    can't actually register because it's a mixed-script name)

#### TLDs

-   `.co`/`.com`/`.space` redirect to `.cloud`, for the dashboard and other
    "official" stuff that belongs to µbox itself
-   `.rocks` for community things
-   `:app.:user.mubox.app` for apps
-   `:instance.:app.:team.mubox.team` for team apps
-   `:app.:team.mubox.live` for HA, A/B, etc
