function cd {
    builtin cd $1 && ruby ~/ruby/jumpdir/storedir.rb
}

function jd {
    cd $(ruby ~/ruby/jumpdir/jumpdir.rb $1)
}
