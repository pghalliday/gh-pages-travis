# gh-pages-travis

CLI to deploy a folder to gh-pages branch of current repo as part of travis build

## Usage

Install as a development dependency

```
npm install --save-dev gh-pages-travis
```

Add a script entry to `package.json` (npm puts the `node_modules/.bin` directory on the path when it runs scripts)

```json
{
  "scripts": {
    "gh-pages-travis": "gh-pages-travis"
  }
}
```

Create your `gh-pages` branch and add the following `.travis.yml` to prevent travis build it

```yml
branches:
  except:
    - gh-pages
```

Generate a deploy key for your Github repository

```
ssh-keygen -t rsa -C "your_email@example.com"
```

This will generate the `id_rsa` and `id_rsa.pub` files

Add `id_rsa.pub` as a deploy key for your Github repository

Install the travis cli client

```
gem install travis
```

Login the travis cli and encrypt the private key, `id_rsa`

```
travis Login
travis encrypt-file id_rsa --add
```

This will add the decrypt command to recreate `id_rsa` in the current folder as a `before_install` script

Make sure you delete the `id_rsa` and `id_rsa.pub` files and add the `id_rsa.enc` to the repository.

Lastly update your `.travis.yml` to configure the script and run it after a successful build

```yml
after_sucess:
  - npm run gh-pages-travis
env:
  global:
    - SSH_KEY="id_rsa"
    - GIT_NAME="Peter Halliday"
    - GIT_EMAIL="pghalliday@gmail.com"
    - SOURCE_DIR="docs"
    - DEPLOY_BRANCH="master"
```
