dotfiles
=========

## Overview

dotfiles are managed using [chezmoi](https://www.chezmoi.io/)


## Installation

Single line install
```
sh -c "$(curl -fsLS get.chezmoi.io/lb) -- init --apply git@github.com:paulshir/dotfiles"
```

If chezmoi already exists
```
chezmoi init git@github.com/paulshir/dotfiles.git
```

## Configs
Not documenting all config, just anomolies

### Karabiner
`karabiner.json` is generated from [typescript config](https://github.com/paulshir/dotfiles)

