#!/bin/sh
#set -x

# Work directory of this repository.
if [ "$1" != "" ]; then
	workdir=$1
else
	workdir=.
fi

cd $workdir
if [ ! -f appveyor.yml ]; then
	echo "Wrong directory."
	exit 1
fi

git checkout master
git pull --no-edit --ff-only

if [ ! -d ctags/src ]; then
	git submodule init
fi
git submodule update

# Get the latest ctags source code
cd ctags
git checkout master
git pull --no-edit --ff-only
exacttag=yes
ctagsver=$(git describe --tags --exact-match --match 'v*' 2> /dev/null)
if [ -z "$ctagsver" ]; then
	ctagsver=$(git describe --tags --exact-match 2> /dev/null)
	if [ -z "$ctagsver" ]; then
		ctagsver=$(git describe --tags --always)
		exacttag=no
	fi
fi
cd ..
ctagslog=$(git submodule summary | grep '^  > ')

# Check if it is updated
if git diff --quiet; then
	if [ "$exacttag" = "no" ] || [ -n "$(git tag --list "$ctagsver")" ]; then
		echo "No changes found."
		exit 0
	fi
	# Only a new tag was added
	git tag "$ctagsver"
	git push origin --tags
	exit 0
fi

# Commit the change and push it
# replace newline by \n
echo "$ctagslog" | \
	sed -e 's/\([][_*^<`\\]\)/\\\1/g' \
	    -e 's/^  >/*/' \
	    -e 's!#\([0-9][0-9]*\)![#\1](https://github.com/universal-ctags/ctags/issues/\1)!' | \
	perl -pe 's/\n/\\n/g' > gitlog.txt
ctagslog=$(echo "$ctagslog" | sed -e 's/^  >/*/')
git commit -a -m "ctags: Update to $ctagsver" -m "$ctagslog"
if [ "$exacttag" = "yes" ]; then
	git tag "$ctagsver"
else
	git tag "$(date --rfc-3339=date)/$ctagsver"
fi
git push origin master --tags
