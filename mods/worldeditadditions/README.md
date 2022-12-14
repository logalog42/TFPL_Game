# ![](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/main/worldeditadditions-64.png) Minetest-WorldEditAdditions
![GitHub release (latest by date)](https://img.shields.io/github/v/release/sbrl/Minetest-WorldEditAdditions?color=green&label=latest%20release) [![View the changelog](https://img.shields.io/badge/%F0%9F%93%B0-Changelog-informational)](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/CHANGELOG.md) [![ContentDB](https://content.minetest.net/packages/Starbeamrainbowlabs/worldeditadditions/shields/downloads/)](https://content.minetest.net/packages/Starbeamrainbowlabs/worldeditadditions/)

> Extra tools and commands to extend WorldEdit for Minetest

If you can dream of it, it probably belongs here!

**Important News: The `master` branch has been renamed to `main`, to follow the new standard across the Git ecosystem. If you've installed _WorldEditAadditions_ through git, you will need to re-clone the repository.**

![Screenshot](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/main/screenshot.png)

_(Do you have a cool build that you used WorldEditAdditions to build? [Get in touch](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) and I'll feature your screenshot here!)_


## Table of Contents
 - [Quick Command Reference](#quick-command-reference) (including links to detailed explanations)
 - [Using the Far Wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#far-wand)
 - [Using the Cloud Wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#cloud-wand)
 - [Detailed Chat Command Explanations](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md)
 - [Chat Command Cookbook](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Cookbook.md)
 - [Troubleshooting](#troubleshooting)
 - [Contributing](#contributing)
 - [WorldEditAdditions around the web](#worldeditadditions-around-the-web)
 - [Licence](#license)


## Quick Command Reference
The detailed explanations have moved! Check them out [here](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md), or click the links below.

### Geometry
 - [`//ellipsoid <rx> <ry> <rz> <node_name> [h[ollow]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#ellipsoid-rx-ry-rz-node_name-hollow)
 - [`//hollowellipsoid <rx> <ry> <rz> <node_name>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#hollowellipsoid-rx-ry-rz-node_name)
 - [`//torus <major_radius> <minor_radius> <node_name> [<axes=xy> [h[ollow]]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#torus-major_radius-minor_radius-node_name-axesxy-hollow)
 - [`//hollowtorus <major_radius> <minor_radius> <node_name> [<axes=xy>]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#hollowtorus-major_radius-minor_radius-node_name-axesxy)
 - [`//walls <replace_node>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#walls-replace_node)
 - [`//line [<replace_node> [<radius>]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#line-replace_node-radius)
 - [`//hollow [<wall_thickness>]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#hollow-wall_thickness)
 - [`//maze <replace_node> [<path_length> [<path_width> [<seed>]]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#maze-replace_node-path_length-path_width-seed)
 - [`//maze3d <replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#maze3d-replace_node-path_length-path_width-path_depth-seed)

### Misc
 - [`//replacemix <target_node> [<chance>] <replace_node_a> [<chance_a>] [<replace_node_b> [<chance_b>]] [<replace_node_N> [<chance_N>]] ....`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#replacemix-target_node-chance-replace_node_a-chance_a-replace_node_b-chance_b-replace_node_n-chance_n-)
 - [`//floodfill [<replace_node> [<radius>]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#floodfill-replace_node-radius-floodfill)
 - [`//scale <axis> <scale_factor> | <factor_x> [<factor_y> <factor_z> [<anchor_x> <anchor_y> <anchor_z>]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#scale-axis-scale_factor--factor_x-factor_y-factor_z-anchor_x-anchor_y-anchor_z) **experimental**

### Terrain
 - [`//overlay <node_name_a> [<chance_a>] <node_name_b> [<chance_b>] [<node_name_N> [<chance_N>]] ...`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#overlay-node_name_a-chance_a-node_name_b-chance_b-node_name_n-chance_n-)
 - [`//layers [<node_name_1> [<layer_count_1>]] [<node_name_2> [<layer_count_2>]] ...`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#layers-node_name_1-layer_count_1-node_name_2-layer_count_2-)
 - [`//fillcaves [<node_name>]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#fillcaves-node_name)
 - [`//convolve <kernel> [<width>[,<height>]] [<sigma>]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#convolve-kernel-widthheight-sigma)
 - [`//erode [<snowballs|river> [<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#erode-snowballsriver-key_1-value_1-key_2-value_2-) **experimental**

### Flora
 - [`//bonemeal [<strength> [<chance>]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#bonemeal-strength-chance)
 - [`//forest [<density>] <sapling_a> [<chance_a>] <sapling_b> [<chance_b>] [<sapling_N> [<chance_N>]] ...`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#forest-density-sapling_a-chance_a-sapling_b-chance_b-sapling_N-chance_N-) _(new in v1.9)_
 - [`//saplingaliases [aliases|all_saplings]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#saplingaliases-aliasesall_saplings) _(new in v1.9)_

### Statistics
 - [`//count`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#count)

### Selection
 - [`//scol [<axis1> ] <length>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#scol-axis1--length)
 - [`//srect [<axis1> [<axis2>]] <length>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#srect-axis1-axis2-length)
 - [`//scube [<axis1> [<axis2> [<axis3>]]] <length>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#scube-axis1-axis2-axis3-length)
 - [`//scloud <0-6|stop|reset>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#scloud-0-6stopreset)
 - [`//scentre`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#scentre)
 - [`//srel <axis1> <length1> [<axis2> <length2> [<axis3> <length3>]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#srel-axis1-length1-axis2-length2-axis3-length3)
 - [`//smake <operation:odd|even|equal> <mode:grow|shrink|average> [<target=xz> [<base>]]`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#smake-operationoddevenequal-modegrowshrinkaverage-targetxz-base)
 - [`//sstack`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#sstack)
 - [`//spush`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#spush)
 - [`//spop`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#spop)

### Meta
 - [`//multi <command_a> <command_b> ....`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#multi-command_a-command_b-command_c-)
 - [`//many <times> <command>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#many-times-command) _(new in v1.9)_
 - [`//subdivide <size_x> <size_y> <size_z> <cmd_name> <args>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#subdivide-size_x-size_y-size_z-cmd_name-args) **experimental**
 - [`//ellipsoidapply <command_name> <args>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#ellipsoidapply-command_name-args) _(new in v1.9)_

### Extras
 - [`//y`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#y)
 - [`//n`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#n)

### Tools
 - [WorldEditAdditions Far Wand](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#far-wand)
 - [`//farwand skip_liquid (true|false) | maxdist <number>`](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/main/Chat-Command-Reference.md#farwand-skip_liquid-truefalse--maxdist-number)


## Installation
You can install _WorldEditAadditions_ in multiple ways:

### Through ContentDB
WorldEditAdditions is on ContentDB here: <https://content.minetest.net/packages/Starbeamrainbowlabs/worldeditadditions/>.

### Through the latest release
You can get a copy of WorldEditAdditions by downloading the source code for the [latest release](https://github.com/sbrl/Minetest-WorldEditAdditions/releases/latest), but this is not recommended because it takes additional effort to update to the latest version.

### Through Git
You can also clone this git repository. Note that the `main` branch is not considered to be stable at all times - though it shouldn't crash. It is recommended that you checkout a release to ensure stability. Do that like so:

```bash
# First, clone the repository
git clone https://github.com/sbrl/Minetest-WorldEditAdditions.git WorldEditAdditions
cd WorldEditAdditions
# Then, checkout the latest release on Linux:
git checkout "$(git describe --tags --abbrev=0)";
```

Windows users, you'll need to check the [releases page](https://github.com/sbrl/Minetest-WorldEditAdditions/releases) and find the name of the latest release, then do this instead of the `git checkout` above:

```bash
git checkout TAG_NAME_HERE
```


## Troubleshooting
If you're experiencing issues with this mod, try checking this FAQ before opening an issue.

### I get an error saying that worldedit isn't installed
WorldEditAdditions requires that the `worldedit` mod is installed as a dependency. Install it and then try launching Minetest (or the `minetest-server`) again.

### I get an error saying that `worldedit.register_command()` is not a function
This is probably because your version of `worldedit` is too old. Try updating it. Specifically the `worldedit.register_command()` function was only added to `worldedit` in December 2019.

### I get a crash on startup saying `attempt to call field 'alias_command' (a nil value)`
Please update to v1.8+. There was a bug in earlier versions that caused a race condition that sometimes resulted in this crash.

### Why don't the [moretrees](https://content.minetest.net/packages/VanessaE/moretrees/) trees work with `//forest`?
As far as I can tell, the saplings provided by the [`moretrees` mod](https://content.minetest.net/packages/VanessaE/moretrees/) don't properly interact with bonemeal from the [bonemeal mod](https://content.minetest.net/packages/TenPlus1/bonemeal/), which WorldEditAdditions uses to grow trees. As far as I can tell WorldEditAdditions has everything in place needed to support them, but until applying bonemeal to `moretrees` saplings results in a tree rather than waiting for one to grow over time, WorldEditAdditions will always fail to place trees provided by the `moretrees` mod, unfortunately.


## Contributing
Contributions are welcome! Please state in your pull request(s) that you release your contribution under the _Mozilla Public License 2.0_.

Please also make sure that the logic for every new command has it's own file. For example, the logic for `//floodfill` goes in `worldeditadditions/floodfill.lua`, the logic for `//overlay` goes in `worldeditadditions/overlay.lua`, etc.

I, Starbeamrainbowlabs (@sbrl), have the ultimate final say.


## WorldEditAdditions around the web
Are you using WorldEditAdditions for a project? Open an issue and I'll add your project to the below list!

 - _(None that I'm aware of yet! Open an issue or get in touch and I'll link to your project (-:)_

## License
This mod is licensed under the _Mozilla Public License 2.0_, a copy of which (along with a helpful summary as to what you can and can't do with it) can be found in the `LICENSE` file in this repository.

All textures however are licenced under [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) (Creative Commons Attribution Share-Alike International 4.0).

If you'd like to do something that the license prohibits, please get in touch as it's possible we can negotiate something.

If WorldEditAdditions has helped you out in a project, please consider adding a little sign in a corner of your project saying so :-)
