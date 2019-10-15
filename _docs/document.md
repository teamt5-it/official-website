# `/zh/`

Mandarin pages

# `/products/`

Products related pages

Including threatsonar and threatvision

# `/newsroom/`

Newsroom related pages

Including browse by tag

# `/resource/`

Resource related pages

Including browse by tag

# `/includes/`

Shared component

# `/_assets/`

Basic css, images, js

# `/assets/`

Images uploaded by user(for article use)

# `/drafts/`

Draft articles set by Forestry.io

Articles in this directory won't be displayed

# How browse by tag work

Manually create tag page from category directory

For example:

category: `resource`

Browese by tag: `technical`

 `/resource/technical.html`

```
---
layout: resource-browse-by-type
permalink: /resource/technical
i18n-prefix: resource-browse-by-type-technical
category: resource
type: technical
pagination:
    per_page: 14
    categories:
    - resource
    tags:
    - technical
    enabled: true
    locale: en
---
```

You should manually specify permalink url and configure pagination

Let pagination only select category: `resource`, tag: `technical`

# i18n

`/_data/en.yml`

English(default) translation

`/_data/zh.yml`

Mandarin translation

# Adding a new page

## Create a new page under root directory

`/new.html`

```
---
layout: new
permalink: /new/
i18n-prefix: new
pagination:
    per_page: 5
    enabled: true
    locale: en
---
```

## Add i18n key in `_data/en.yml`

i18n-prefix key is `new`

 `_data/en.yml`

    new:
        title: Hello

## Create a layout under `_layouts` directory

 `_layouts/new.html`

```
---
layout: default
---
{% t title %} // Hello
 ```

`default` layout will add "#{page.layout}-layout" class to container

It can be used for styling specific page

## Add specific page style under `_assets/css/new.scss`

    @import 'base';

    .new-layout {
        ...
    }

## Include specific page style in `_assets/css/main.css`

    @import "new";

# Add i18n page for different language

The process is almost the same as adding [Adding a new page](#Adding-a-new-page)

Only change permalink: `/new/` to `/zh/new/`

Instead adding i18n key in `_data/en.yml`, adding i18n key to `_data/zh.yml`

# Add new i18n language

For example, Japanese(ja)

Edit `_config.yml`

```
defaults:
  -
    scope:
      path: "ja"
      type: "pages"
    values:
      locale: ja
```

Add Japanese pages under `/ja/` directory

Edit i18n key in `_data/ja.yml`
