# Pristine

A place to store my shell setup stuffz and dotfiles. Following the instructions here should be all I need to do to setup a new box or clone.

## Install

1. Install [Homebrew](https://brew.sh/)
2. Run this repo's setup script:

    ```sh
    $ ./setup.sh
    ```


### Stow dotfiles

The setup command will install [stow](https://www.gnu.org/software/stow/), which is a a symlink farm manager. I use it to backup [dotfiles](https://dotfiles.github.io/) and place them in version control. In order to add an app's dotfiles to 'stow control':

1. Create a directory in this repo's `dotfiles` directory, named after the app/package that the dotfile(s) belong to...

    ```sh
    # i.e.
    dotfiles/appname/

    # e.g.
    dotfiles/tmux/
    ```

2. Move the dotfiles **from** their position in `$HOME` **to** the directory created in step 1

3. Run the following command to get `stow` to symlink the dotfiles back to where they came from!

    ```sh
    $ stow appname
    ```

4. Add the appname to `bin/dotfiles.sh` to have it automatically installed whenever a new setup is run.

5. `git commit`, etc


## Notes & Bugfixes

- Adding the following to `.zpreztorc` manually at the moment...

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

- Issue: tmux modifies zsh `$PATH` !

    **Solution**: Modify `/etc/zprofile` to the following:

    ```sh
    # system-wide environment settings for zsh(1)
    if [ -x /usr/libexec/path_helper ]; then
      if [ -z "$TMUX" ]; then
        eval `/usr/libexec/path_helper -s`
      fi
    fi
    ```


## Inspiration

- [Daniel Miessler](https://github.com/danielmiessler): [configuration script](https://github.com/danielmiessler/Pristine) for bootstrapping a new box
- [Xero](https://github.com/xero): dotfile [solution](https://github.com/xero/dotfiles)
