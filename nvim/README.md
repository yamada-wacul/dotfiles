# Configuration and opts for Neovim

| Directory              | Role                                     | Ref                               |
| -                      | -                                        | -                                 |
| `/local/etc`           | Settings for core                        | `runtime! local/etc/*.{vim,lua}`  |
| `/local/with`          | Settings depends/for some plugins        | `runtime! local/with/*.{vim,lua}` |
| `/local/mod/*`         | Somewhat complex, independent features   | `runtime! local/mod/**/*.vim`     |
| `/autoload/local/etc`  | Autoload functions for `/local/etc`      | -                                 |
| `/autoload/local/with` | Autoload functions for `/local/with`     | -                                 |
| `/autoload/local/mod`  | Autoload functions for `/local/mod`      | -                                 |
| `/lua/local/etc`       | Lua modules for `local/etc`              | `lua require("local.etc.*")`      |
| `/lua/local/with`      | Lua modules for `local/with`             | `lua require("local.with.*")`     |
| `/lua/local/mod/*`     | Somewhat complex, independent Lua module | `lua require("local.mod.*")`      |
