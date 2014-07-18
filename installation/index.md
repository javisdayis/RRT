---
layout: page
title: RRT Installation
---

* [Ubuntu Linux](#linux)
* [Mac OS X](#osx)
* [Windows](#windows)

To install R, the best place to start is the [CRAN home page](http://cran.r-project.org/)  
Optionally:  
Ubuntu users can  

```coffee
apt-get update ; apt-get install r-base
```  

Mac [Homebrew](http://brew.sh) users can

```coffee
brew update ; brew tap homebrew/science ; brew install R
```

### RRT Installation by operating system

####  <a href="#linux" name="linux">#</a>  Ubuntu Linux

On Ubuntu Linux, you may need to install two system dependencies:  
-XML C library  
-libcurl-dev

```coffee
apt-get install r-cran-xml libcurl-dev
```

In an `R` session

```coffee
install.packages("devtools")
library("devtools")
```

Then install `RRT`

```coffee
install_github("RevolutionAnalytics/RRT")
library("RRT")
```

`RRT` has been tested on Ubuntu 14.04.  
Please create a brief item in the [RRT issue tracker](https://github.com/RevolutionAnalytics/RRT/issues)
if you run into issues with system dependencies or general install issues.

####  <a href="#osx" name="osx">#</a> Mac OS X

XML and curl C libraries should be installed by default on your machine.
RRT has been tested on Mac OS X Mavericks.  
Please create a brief item in the [RRT issue tracker](https://github.com/RevolutionAnalytics/RRT/issues)
if you run into issues on other versions of Mac OS X and system dependencies.  


In an `R` session

```coffee
install.packages("devtools")
library("devtools")
```

Then install `RRT`

```coffee
install_github("RevolutionAnalytics/RRT")
library("RRT")
```

####  <a href="#windows" name="windows">#</a>  Windows

* Install [Rtools](http://cran.r-project.org/bin/windows/Rtools/)
* Install the [devtools R package](https://github.com/hadley/devtools). You can install from source,
or just install via `install.packages("devtools")`, or choose devtools from the R GUI.

* Then install `RRT`

```coffee
install_github("RevolutionAnalytics/RRT")
library("RRT")
```
