# Pristine

A place to store my shell setup and dotfiles. This repo should be all I need to setup a new or cloned box.

## Install

1. Install [Homebrew](https://brew.sh/)

2. Clone this repo to a suitable local location. That could be directly under `$HOME` or some other, less prominent, location.

3. Run this repo's setup script:

    ```sh
    $ ./setup.sh
    ```


## Notes & Bugfixes

- Add any required language specific modules to `.zpreztorc` manually (for now), i.e.

  ```
  .
  .
  .
  # Set the Prezto modules to load (browse modules).
  # The order matters.
  zstyle ':prezto:load' pmodule \
    'environment' \
    .
    .
    .
    'prompt'  \
    'git'     \
    'python'  \
    'node'    \
    'ruby'
  ```

- There is an issue where tmux modifies `$PATH` when using zsh!

    **Solution**: Modify `/etc/zprofile` to the following:

    ```sh
    # system-wide environment settings for zsh(1)
    if [ -x /usr/libexec/path_helper ]; then
      if [ -z "$TMUX" ]; then
        eval `/usr/libexec/path_helper -s`
      fi
    fi
    ```


### Dotfiles

This repo's setup command installs [stow](https://www.gnu.org/software/stow/), which is a a symlink farm manager. I use it to backup [dotfiles](https://dotfiles.github.io/) and place them in version control.

It's important to distinguish between dotfiles and 'hidden working/cache files/directories' that just happen to be sitting in the `$HOME` directory. The later should not be placed in version control! For example, whilst the dotfile `.tmux.conf` holds customizable configuration data for a `tmux` install (and may therefore be recorded and monitored in version control), its related `.tmux` directory is used as a cache and will simply be populated to the requirements of the `.tmux.conf` configuration file at runtime.

- Having established an app's actual dotfile(s), in order to use `stow`:

  1. Create a directory in this repo's `dotfiles` directory, named after the dotfile's application:

      ```sh
      # i.e.                      # e.g.
      dotfiles/appname/           dotfiles/tmux/
      ```

  2. **Move** the dotfile(s) **from** the `$HOME` directory **to** the directory created in step 1

  3. Run the following command to get `stow` to symlink the dotfile(s) from the new location (in version control)!

      ```sh
      $ stow appname
      ```

  4. Add the appname to `bin/dotfiles.sh` to have its dotfile(s) automatically installed from version control whenever a new setup is run.

  5. `git commit`, etc


- To remove 'stow control' for an application's dotfile(s):

  1. Run the following command to remove associated symlink(s)

      ```sh
      $ stow --delete appname
      ```

  2. **Move** the file(s) from the application's corresponding directory (in version control - see step 1 above) back to their original location, i.e the `$HOME` directory


**Note**: `stow` will never overwrite a file that it hasn't previously created, or that already exists, so it's fairly safe to rerun any of the following commands at any time:

```sh
# for dotfile(s) in version control already...
#
# to `stow` a single application's dotfile(s)
# (use the -v flag to see what's going on)
$ stow -v appname
# or for multiple applications
$ stow -v --stow app1name [app2name [app3name]]

# to remove from stow, just use the --delete flag
$ stow -v --delete app1name [app2name [app3name]]
# don't forget to copy/move the dotfile(s) back to $HOME manually!
```


## Inspiration

- [Daniel Miessler](https://github.com/danielmiessler): [configuration script](https://github.com/danielmiessler/Pristine) for bootstrapping a new box
- [Xero](https://github.com/xero): dotfile [solution](https://github.com/xero/dotfiles)
