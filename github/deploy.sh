#!/usr/bin/env bash

set -e

echo
echo "=> Install development dependencies"
npm install

echo
echo "=> Build site"
rm -vrf dist
jekyll build -d dist

echo
echo "=> Autoprefixer CSS"
npx postcss dist/assets/css/*.css -c github/postcss.config.js -d dist/assets
mv -vf dist/assets/*.css dist/assets/css

echo
echo "=> Release start"
mv -v dist .git/

echo
echo "=> Checkout gh-pages branch"
if [ `git branch | grep gh-pages` ]; then
  echo "=> Delete local gh-pages"
  git branch -D gh-pages
fi
git checkout -b gh-pages

echo
echo "=> Clean existed files"
rm -rf *

echo
echo "=> Deploy"
mv -v .git/dist/* .
rm -vrf .git/dist

echo
echo "=> Push to remote server"
git add .
git commit -m "release"
git push -f origin gh-pages
