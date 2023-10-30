# custom-compile

The goal of this plugin is to provide a dead simple way to run compilation tasks
and leverage builtin Neovim features. 
It wraps the `:make` and `:compile` features,
and does not aim to be a fully featured task runner.
Programs like `task` and `make` are already amazing; use `custom-compile` to run
them.

## Installation

Using `lazy.nvim`:

```lua
{
    "treemcgee42/custom-compile.nvim",
    config = true
}
```

## Setup

The default settings are these:

```lua
{
    definition_file = "./.nvim/custom-compile.lua",
    key_bindings = {
        do_default_task = "<Leader>B",
        list_taks = "<Leader>b"
    }
}
```

You pass these to the `setup` function:
```lua
custom-compile.setup({
    -- your settings
})
```
If you are using `lazy.nvim`, this is more idiomatic:
```lua
{
    "treemcgee42/custom-compile.nvim",
    config = true,
    opts = {
        -- your settings
    }
}
```

## Definition file

`custom-compile` will look for a lua file to define the available tasks. The 
format of this file is:

```lua
tasks = {
    {
        name = "my-build-task",
        program = "task",
        args = "build",
        error_formats = {
            "zig",
            [[%f:%l:%c:\ %t%*[^:]:\ %m]]   
        },
        default = true
    }
}
```

- `error_formats`: an array of Vim error format strings or default names. Anything else 
will be ignored. In the example above, "zig" is a predefined default for the Zig langauge 
compiler. We can also define our own error format, which we do with the second item in the 
array (in fact, that's how we define the Zig error format internally). 

## Miscellaneous

- [`greyjoy.nvim`](https://github.com/desdic/greyjoy.nvim/tree/main)
was an inspiration and helped me get started writing my own plugin. 
- [This video](https://www.youtube.com/watch?v=vB3NT9QIXo8) by Gavin Freeborn
explains the builin `:make` and `:compile` features of Vim really well.
