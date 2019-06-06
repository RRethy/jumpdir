#! /usr/bin/env zsh

compdef _jd jd

chpwd_functions+=(storepwd)

function storepwd {
  ruby ~/ruby/jumpdir/storedir.rb
}

function jd {
    cd $(ruby ~/ruby/jumpdir/jumpdir.rb $1)
}

function _jd {
    compadd -U $(ruby ~/ruby/jumpdir/comp.rb $PREFIX)
}
