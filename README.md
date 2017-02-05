[![Build Status](https://travis-ci.org/spals/parent-pom.svg?branch=master)](https://travis-ci.org/spals/parent-pom)

# parent-pom

The parent pom.xml for all spals related projects.

This releases the version to maven central.
```
git tag {version} HEAD
git push origin --tags
```

This manually updates the version as our travis ci doesn't handle it yet.
```
mvn versions:set -DnewVersion={version+1}-SNAPSHOT
mvn versions:commit
git commit -a -m 'Bump version to {version+1}-SNAPSHOT [ci skip]'
git push origin master
```
