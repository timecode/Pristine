# Pristine

A place to store my shell setup stuffz and dotfiles

## Install

```sh
$ ./setup.sh
```

## Notes

- Issue: tmux modifies zsh `$PATH` !

    Solution: Modify `/etc/zprofile` to the following:
    
    ```sh
    # system-wide environment settings for zsh(1)
    if [ -x /usr/libexec/path_helper ]; then
      if [ -z "$TMUX" ]; then
        eval `/usr/libexec/path_helper -s`
      fi
    fi
    ```
