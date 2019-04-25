# Resume

Hi! I'm Dmitry, a web developer from St. Petersburg, Russia with 4 years of experience in the field of professional web development.

## I code

- ### Ruby

    Most of my ruby code rests in private codebases, so there's not much to show here, yet I consider the folowing examples representative

    - My pull requests to uploadcare-ruby, for example [this][Secure Auth] and [this][ResourceList]
    - Useless yet interesting [patme][patme] gem (with 75★) that implements elixir-style pattern matching (I've written it some time ago on a dare)
    - [Test task][SPBTV test task] for my previous employer (SPB TV AG)
    - [telegram bot][telegram bot] that I've written for personal purposes

[Secure Auth]: https://github.com/uploadcare/uploadcare-ruby/pull/24
[ResourceList]: https://github.com/uploadcare/uploadcare-ruby/pull/31
[patme]: https://github.com/vizvamitra/patme
[SPBTV test task]: https://github.com/vizvamitra/watch_counter
[telegram bot]: https://github.com/vizvamitra/memmo_bot

- ### JS

    Being mostly a ruby developer, I know and like JS, but have quite a few publicly available examples of my JS code. Here are some of them, written for my personal experiments with graphics. Note that they are all 2 or more years old (don't trust commit timestamps)

    - 2d: particles ([code][js particles code], [live demo][js particles demo] looks better in night mode)
    - 3d: lightning ([code][js lishtning code], [live demo][js lishtning demo]), texturing ([code][js texturing code], [live demo][js texturing demo])

[js particles code]: https://github.com/vizvamitra/canvas_experiments/tree/master/gravity
[js particles demo]: https://vizvamitra.github.io/canvas_experiments/gravity/index.html
[js lishtning code]: https://github.com/vizvamitra/canvas_experiments/tree/master/gypsum
[js lishtning demo]: https://vizvamitra.github.io/canvas_experiments/gypsum/index.html
[js texturing code]: https://github.com/vizvamitra/webgl_study/tree/master/8/01_textures
[js texturing demo]: http://vizvamitra.github.io/webgl_study/8/01_textures/index.html

## I speak

- ### 2018.12.11, Functional reload, PiterPy meetup #12

    [video][python talk] (Russian), [slides][python talk slides] (English)

    I was telling pythonistas about benefits of functional approach to web programming

[python talk]: https://www.youtube.com/watch?v=eQBrynDQHWE
[python talk slides]: https://slides.com/vizvamitra/2018_fr#/

## I work

### Freelance

- #### Online store [istetica.ru][istetica]

    I was working here as a fullstack developer. In 80 working hours spanned into two months I've lead this project from a prototype stage to a fully functional online store.

- #### [uploadcare-ruby][uploadcare-ruby] && [uploadcare-rails][uploadcare-rails] gems

    Uploadcare hired me to maintain their ruby gems. I've lead uploadcare-ruby gem [from v1.0.5 to v2.1.2][uploadcare-ruby diff]

[istetica]: https://istetica.ru
[uploadcare-ruby]: https://github.com/uploadcare/uploadcare-ruby
[uploadcare-rails]: https://github.com/uploadcare/uploadcare-rails
[uploadcare-ruby diff]: https://github.com/uploadcare/uploadcare-ruby/compare/v1.0.5...v2.1.2

### Career

- #### Backend dev at [<img src="./images/spbtv.svg" height="26" style="margin-bottom: -4px">][spbtv], 2017.03 - 2018.10 (1 year 8 months)

    **Ruby**, **Rails**, **API**, **Postgres**, **Docker**, **Redis**, **MQTT**, **Functional programming**, **dry-rb**, **Legacy code**, **remote work**

    I was working on an SPB TV's OTT platform backend which runs several websites (https://ru.spbtv.com, https://beltandroad.tv/ and others), mostly developing and implementing new features.

    Achievements:

    - Added support for iTunes/Google Play in-app subscriptions into an existing subscriptions system
    - Added support for push notifications to non-mobile platforms (web browser, smart tv, STB) to an existing push notifications sending sytsem
    - Developed data model for sports competitons section (https://www.voka.tv/competition/football) and participated in implementating it and the corresponding API
    - Added support for a payment gateway of one of the company's partner banks to an existing subscriptions system
    - Optimized push notifications sending system, reducing the time it needs to send 7M notifications by 8 times
    - Added parental control support (with security PINs)
    - Added some important integration tests

- #### Backend dev at [<img src="./images/izitravel.svg" height="18">][izi.travel], 2015.10 - 2016.12 (1 year 3 months)

    **Ruby**, **Rails**, **Postgres**, **AWS (EC2, S3, RDS)**, **ElasticSearch**, **HAProxy**, **Kibana**, **Redis**, **API**, **TDD**, **Legacy code**

    izi.travel is a "storytelling platform" that deals with museum audio guides and city tours. As a backend I was responsible for new features implementation, bug fixing, server setup, deploys and infrastructure support

- #### Junior dev at [1tvch][1tvch], 2014.08 - 2015.08 (1 year)

    **Ruby**, **Rails**, **Postgres**

    Developed from scratch backends for several company's websites (2 CMSs and a video hosting)

[spbtv]: https://beltandroad.tv/
[izi.travel]: https://izi.travel/en
[1tvch]: http://1tvch.ru
