#!/bin/sh
#
# USAGE: install_sshkey_github.sh {ENCRYPTED_SSHKEY_FILE} {DECRYPTED_SSHKEY_FILE}
# $CI_KEY is used for the decrypt key.

set -e

src=$1 ; shift
dst=$1 ; shift

echo -e "Host github.com\n\tStrictHostKeyChecking no\n\tIdentityFile $dst\n" >> ~/.ssh/config
openssl aes-256-cbc -k "$CI_KEY" -pbkdf2 -in "$src" -d -a -out "$dst"
chmod 600 "$dst"
