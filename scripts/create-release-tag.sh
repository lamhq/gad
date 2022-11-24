release_tag="v${npm_package_version}"
git tag ${release_tag} HEAD
git push origin ${release_tag}