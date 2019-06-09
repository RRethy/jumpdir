#! /usr/bin/env zsh

compdef _jd jd

chpwd_functions+=(storepwd)

function storepwd {
  ruby ~/ruby/jumpdir/jumpdir.rb --incdir $(pwd)
}

function jc {
  if [[ -n "$1" ]]; then
    cd $(ruby ~/ruby/jumpdir/jumpdir.rb --jumpchild $1)
  fi
}

function jd {
  cd $(ruby ~/ruby/jumpdir/jumpdir.rb --jumpdir $1)
}

function jm {
  cd $(ruby ~/ruby/jumpdir/jumpdir.rb --jumpmark $1)
}

function m {
  ruby ~/ruby/jumpdir/jumpdir.rb --markdir $1
}

function _jd {
  compadd -U $(ruby ~/ruby/jumpdir/jumpdir.rb --complete $PREFIX)
}
