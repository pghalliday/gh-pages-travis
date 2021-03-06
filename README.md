# gh-pages-travis

CLI to deploy a folder to gh-pages branch of current repo as part of travis build

## Usage

### Installation

Install as a development dependency

```
npm install --save-dev gh-pages-travis
```

or add to your `Gemfile` if using ruby

```
gem 'gh-pages-travis'
```

### Set up the GitHub pages branch

Create your `gh-pages` branch and add the following `.travis.yml` to prevent travis from building it

```yml
branches:
  except:
    - gh-pages
```

If deploying to a `xxxx.github.io` project then you should create a new branch to run `gh-pages-travis` in (eg. `deploy`) and then add the above config to the `master` branch changing it to except the `master` branch.

### Create and encrypt the deploy key

Generate a deploy key for your Github repository

```
ssh-keygen -t rsa -C "your_email@example.com" -N "" -f id_rsa
```

This will generate the `id_rsa` and `id_rsa.pub` files

**NB. Add `id_rsa.pub` as a deploy key for your Github repository**

Install the travis cli client

```
gem install travis
```

Login the travis cli and encrypt the private key, `id_rsa`

```
travis login
travis encrypt-file id_rsa --add
```

This will add the decrypt command to recreate `id_rsa` in the current folder as a `before_install` script

**NB. Make sure you delete/ignore the `id_rsa` and `id_rsa.pub` files and add the `id_rsa.enc` to the repository.**

**NBB. Also make sure that the `id_rsa` file that is recreated by Travis in the root of your project does not get deployed to the target branch - ie. don't add it to the build directory (for Jekyll this may mean that it should be ignored explicitly if building from the root directory).**

### Configure the deploy branch

Lastly update your `.travis.yml` to configure the script and run it

```yml
script:
  # run from node_modules if added to package.json
  - node_modules/.bin/gh-pages-travis
  # run with bundler if added to Gemfile
  - bundle exec gh-pages-travis
env:
  global:
    - DEPLOY_BRANCH="master"
    - SOURCE_DIR="doc"
    - TARGET_BRANCH="gh-pages"
    - SSH_KEY="id_rsa"
    - GIT_NAME="travis"
    - GIT_EMAIL="deploy@travis-ci.org"
```

All the environment variables are optional but it's likely that 1 or more will need to be set.

- `DEPLOY_BRANCH` defaults to `master`. It ensures that the github pages are only deployed from builds of this branch.
- `SOURCE_DIR` defaults to `doc`. It is likely that this will need to be changed to the directory in which the actual site source is built.
- `TARGET_BRANCH` defaults to `gh-pages`. Typically this can be changed to `master` to deploy to the master branch of a `xxxxx.github.io` repository.
- `SSH_KEY` defaults to `id_rsa`. It would only need to be set if a different name was used for the SSH key to that documented above.
- `GIT_NAME` defaults to `travis`. This is the name that will be used for git commits, you probably want to change this.
- `GIT_EMAIL` defaults to `deploy@travis-ci.org`. This is the email that will be used for git commits, you probably want to change this.

## Publishing

Before publishing a new version of this tool, increment the version number in `package.json`

Then to publish the NPM module

```
npm publish
```

To build and publish the ruby gem

```
gem build gh-pages-travis.gemspec
gem push gh-pages-travis-<version>.gem
```
