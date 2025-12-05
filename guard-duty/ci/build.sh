#!/usr/bin/env sh

set -e

build() {
  cd ${1}

  terraform --version
  terraform init || true
  terraform validate 

  cd -
}

for example in $( ls examples ); do
  EXAMPLE=${example}
  echo "==> Building example: ${example}"
  build "examples/${example}"
done