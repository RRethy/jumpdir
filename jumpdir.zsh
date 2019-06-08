#! /usr/bin/env zsh

compdef _jd jd

chpwd_functions+=(storepwd)

function storepwd {
  ruby ~/ruby/jumpdir/jumpdir.rb --incdir
}

function jd {
  cd $(ruby ~/ruby/jumpdir/jumpdir.rb --jump $1)
}

function _jd {
  compadd -U $(ruby ~/ruby/jumpdir/jumpdir.rb --complete $PREFIX)
}
