# TeamT5 Official Website

This website is powered by jekyll

## Installation

```bash
gem install jekyll
bundle install
jekyll serve
```

Now browse to http://localhost:4000

## Writing

Goto https://forestry.io/

## How works

This repository is use Heroku dyno app to deploy for multi domains website,
to make sure to handles well the redirection of pages,
we use [nginx buildpack](https://github.com/heroku/heroku-buildpack-nginx.git) to makes flexible to design the website.

### CI/CD Flow

1. Directly commit push from T5 GitLab Server
2. Forestry CMS will append a commit after GitLab mirrored to [GitHub](https://github.com/teamt5-it/official-website)
3. Trigger Travis CI to build the site
4. Travis CI sends artifacts to `gh-pages` branch, but that branch doesn't use any GitHub Pages features
5. After CI finished w/o exception, Heroku will starts to deploy dyno to [Staging site](https://t5-official-website-staging.herokuapp.com/)
6. Manually to poke `promote to production` button from [Heroku dashboard pipeline](https://dashboard.heroku.com/pipelines/f8615cfc-15ed-4744-a2a4-43ff93b8e22a) to make staging contents move to production
7. Verify [Production site](https://t5-official-website-production.herokuapp.com/) is deploy successful, then waiting Cloudflare cache expires or manually to poke flush caches from Cloudflare dashboard
