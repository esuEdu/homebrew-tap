# esuEdu/homebrew-tap

Homebrew formulae for [wraith](https://esuedu.github.io/wraith/), a terminal proxy for macOS.

```sh
brew install esuEdu/tap/wraith
```

Homebrew builds wraith from the source tarball of its latest release.

## How the formula is updated

The [update workflow](.github/workflows/update.yml) checks wraith's latest release every hour (or when run by hand). When there is a new one, it downloads the release's tarball, checks it against the release's `checksums.txt` and its [build provenance attestation](https://github.com/esuEdu/wraith/attestations), builds and tests the formula on macOS, and commits. Pre-releases are ignored. It uses this repository's own token: no secret from the wraith repository is involved.

## Uninstall

```sh
wraith ca remove
wraith ca untrust --mac
brew uninstall wraith
```
