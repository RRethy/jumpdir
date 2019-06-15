# Jumpdir

# Usage

```
ruby jumpdir.rb [OPTION]

jumpdir is a script to manage and print directories. It can be used in
conjunction with cd to jump to directories around the filesystem.

OPTIONS:

--help, -h:
    show help

--incdir dir, -i dir:
    increase the ranking associate with dir, dir will default to pwd if omitted

--jumpdir keyword, -j keyword:
    print to stdout the highest ranking directory being tracked which matches
    keyword, $HOME will be printed if keyword is omitted

--complete keyword, -c keyword:
    print to stdout all directories being tracked in ranking order which match
    keyword, all directories will be printed if keyword is omitted

--markdir x, -m x:
    associate the directory with the mark x so it can be jumped to using
    --jumpmark x, x must match [0-9a-zA-Z]

--jumpmark x:
    print the directory marked by x

--jumpchild keyword:
    print the first directory which matches keyword and is a child of pwd, BFS
    will be used to find child directories which match
```

## TODO

1. Write README
2. Fix bug where selection a completion candidate doesn't work due to matching algo
