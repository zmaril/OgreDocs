#!/bin/bash

curl -v -X POST -d name=OgreDocs -d repo=zmaril%2FOgreDocs -d travis=false -d issues=false -d google_analytics=UA-11943276-8 -d twitter=zmaril -d theme=v1 --data-urlencode content@README.md http://documentup.com/compiled > index.html 

mv index.html /tmp
git checkout gh-pages
git fetch origin
git merge origin/gh-pages
mv /tmp/index.html ./

git commit -a -m 'regenerate'
git push origin gh-pages
git checkout master

