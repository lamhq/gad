# update version and changelog
standard-version --skip.tag

# create release branch
release_tag="v${npm_package_version}"
release_branch="release/${release_tag}"
git checkout -b ${release_branch}

# push release branch
git push --set-upstream origin ${release_branch} --no-verify

echo "Release branch created. Please submit a pull request to merge it."