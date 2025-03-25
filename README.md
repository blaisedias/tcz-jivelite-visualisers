# Visualiser tczs for jivelite-vis
## Contents:
* assets: root of tree containing visualiser artwork
  * assets/visualisers/vumeters:  location of VU meter artwork
  * assets/visualisers/spectrum: location of Spectrum meter artwork
* tcz/scripts/build-vis-meters.sh - core script to build the visualiser tcz files
* tcz/scripts/pcp_build_tcz.sh - script to build visualiser tcz files on piCorePlayer
* tcz/suites: path containing tcz suite files which  define the contents of tcz files

## tcz suite files
tcz suite files contain lists of meters to include in a single visualiser tcz file.

tcz suite files are placed in 2 locations
* tcz/suites/spectrum
* tcz/suites/vumeters

The build scripts use name of the tcz suite file as the basename of the generated tcz file.
E.g. the following files are generated for  *VU_Meters_vis_jivelite*  
* VU_Meters_vis_jivelite.tcz
* VU_Meters_vis_jivelite.tcz.md5.txt
* VU_Meters_vis_jivelite.dep.tcz
* VU_Meters_vis_jivelite.list  
* VU_Meters_vis_jivelite.tcz.info

tcz suite files are "parsed" by shell scripts and therefore are very simple.

Each line in a tcz list file is a relative path from *assets/visualisers* to the location of the resources for the visualiser

In addition lines of the form "key: value" are also parsed as meta data, which is added to the tcz.info file.

Typically these 2 lines, should be added to the tcz.info file
```
Author: <names of authors>
Copying-policy: <name of license>
```

For example in *visualiser-tcz-scripts/tcz-lists/vumeters/VU_Meters_vis_jivelite* the contents of the first line are:
* vumeters/Jstraw_Dark

the associated vumeter resources are in *assets/visualisers/vumeters/Jstraw_Dark*


## Building tczs
The current set of build scripts only support linux 

Dependencies:
 * bash
 * git
 * squash fs tools

On piCorePlayer invoke
```
./tcz/scripts/pcp-build-vis-meters.sh
```
This will download and load the dependencies.


On other linux systems, dependencies must be installed using the appropriated package manager,
and then invoking
```
./tcz/scripts/build-vis-meter-suites.sh
```

The tczs files are generated in *build* and log files are in *build/logs*

## Setting up to build on piCorePlayer
ssh into the piCorePlayer then run the following commands
```
ce
tce-load -w git
tce-load -il git
git clone  https://github.com/blaisedias/tcz-jivelite-visualisers
```

Make sure you have enough free space to clone and build currently at least 1GiB
