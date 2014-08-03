# fluent-plugin-tail_path

[![Build Status](https://secure.travis-ci.org/sonots/fluent-plugin-tail_path.png?branch=master)](http://travis-ci.org/sonots/fluent-plugin-tail_path)

## About

This is an extension of fluentd in\_tail plugin to add `path` field which tells the log path being tailed. 

This plugin was created based on a pull request [fluentd#281](https://github.com/fluent/fluentd/pull/281). 

## Requirements

Fluentd v0.10.45 or above. 

## Parameters

Basically same with in\_tail plugin. See http://docs.fluentd.org/articles/in_tail

Following parameters are additionally available: 

- path_key

    Add `path` field which tells the log path being tailed. Specify the field name. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## ChangeLog

See [CHANGELOG.md](CHANGELOG.md) for details.

## Copyright

* Copyright (c) 2014- @szhem
* Copyright (c) 2014- Naotoshi Seo
* See [LICENSE](LICENSE) for details.
