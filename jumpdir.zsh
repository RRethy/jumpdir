#! /usr/bin/env zsh

compdef _jd jd

function _jd {
    compadd -U $(ruby ~/ruby/jumpdir/comp.rb $PREFIX)
}

function cd {
    builtin cd $1 && ruby ~/ruby/jumpdir/storedir.rb
}

function jd {
    cd $(ruby ~/ruby/jumpdir/jumpdir.rb $1)
}
