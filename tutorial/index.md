---
layout: page
title: Tutorial
---

* [Install RRT](#installrrt)
* [Create an RRT repository](#createrrt)
    * [w/o user input](#nouserinput)
    * [w/ user input](#userinput)
* [Refresh repository](#refresh)
* [Install packages](#installpkgs)
* [Package compatibility check](#compatibility)
* [Browse your RRT repositories](#browsing)
* [Get a list of repositories within R](#listing)
* [Starting R from a repo](#starting)
* [Get packages from MRAN ](#mran)
* [Clean ('sweep') out all packages from your repository](#clean)

### <a href="#installrrt" name="installrrt">#</a> Install `RRT`

On Linux, get xml C library first (on the command line)

```
(sudo) apt-get update
(sudo) apt-get install r-cran-xml
```

You may need libcurl too. Do report in the issues tab if you run into this problem.

In an `R` session

```r
install.packages("devtools")
library("devtools")
```

Then install `RRT`

```r
devtools::install_github("RevolutionAnalytics/RRT")
library("RRT")
```

### <a href="#createrrt" name="createrrt">#</a> Create an RRT repository

#### <a href="#nouserinput" name="nouserinput">#</a> Create a repo without user input

```r
checkpoint("2014-07-11", "~/mynewrepository")
```

```r
Checking to see if repository exists already...
Creating repository ~/mynewrepository
Checking to make sure rrt directory exists inside your repository...
Creating rrt directory ~/mynewrepository/rrt/lib/x86_64-apple-darwin13.1.0/3.1.0
Looking for packages used in your repository...
Writing repository manifest...

>>> RRT initialization completed.
```
You should now have a RRT repository

#### <a href="#userinput" name="userinput">#</a> Or create a repo interactively

This process will ask you questions

```r
checkpoint("2014-07-11", interactive=TRUE)
```

```r
Repository name (default: random name generated):
somenewrepo # user entered

Repository path (default: home directory + repository name):
 # user left blank

Repository author(s) (default: left blank):
Scott Chamberlain # user entered

Repo license (default: MIT):
GPL-2 # user entered

Repo description (default: left blank):
A repository for research on x, y, and z # user entered

Repo remote git or svn repo (default: left blank):
https://github.com/sckott/somenewrepo # user entered
```

With similar message as above for other checks

```r
Checking to see if repository exists already...
Creating repository /Users/sacmac/somenewrepo
Checking to make sure rrt directory exists inside your repository...
Creating rrt directory /Users/sacmac/somenewrepo/rrt/lib/x86_64-apple-darwin13.1.0/3.1.0
Looking for packages used in your repository...
Writing repository manifest...

>>> RRT initialization completed.
```

### <a href="#refresh" name="refresh">#</a> Refresh repository

To make `RRT` as simple as possible, there is a function called `rrt_refresh()`, used to update the packages installed locally in your repository by looking through the repository files again for new packages. However, you only need to run `checkpoint()` again, as we know you already have an `RRT` repository, so we run `rrt_refresh()` instead of `rrt_init()`. After we initiated a new repo above with `rrt_init()` we may add some code in a `code.R` file. Then we want to update the packages in the repo, which can be done with `checkpoint()`. Note that we don't have to pass in the repo path (unless your current working directory isn't the folder in question) or the `snapshotdate` parameter.

```r
checkpoint()
```

```r
Checking to make sure repository exists...
Checking to make sure rrt directory exists inside your repository...
Looking for packages used in your repository...
Getting new packages...
Creating new folders: ~/mynewrepository/rrt/lib/x86_64-apple-darwin13.1.0/3.1.0/src/contrib
trying URL 'http://cran.r-project.org/src/contrib/plyr_1.8.1.tar.gz'
Content type 'application/x-gzip' length 393233 bytes (384 Kb)
opened URL
==================================================
downloaded 384 Kb

trying URL 'http://cran.r-project.org/src/contrib/Rcpp_0.11.2.tar.gz'
Content type 'application/x-gzip' length 2004313 bytes (1.9 Mb)
opened URL
==================================================
downloaded 1.9 Mb

Writing repository manifest...

>>> RRT refresh completed.
```

As you can see `checkpoint()` scans the repo for new packages used, downloads them if any new ones, and updates the manifest file.

### <a href="#installpkgs" name="installpkgs">#</a> Install packages

In addition to downloading packages, `checkpoint()` installs any packages that are downloaded, but not yet installed. The package download and installation steps are separate, but we do them all in one step with the `checkpoint()` function so you don't have to worry about it.

### <a href="#compatibility" name="compatibility">#</a> Package compatibility check

This will be done by `rrt_compat()` - this function is not done yet...

### <a href="#browsing" name="browsing">#</a> Browse your RRT repositories

This function uses `rrt_repos_list()` (see below) internally, and uses the `whisker` R package to build a series of web pages to easily understand what RRT repos exist on your machine, their details, etc.

```r
rrt_browse()
```

Should open up a web page in your default browser

![](../public/img/browse1.png)

You can click on each green button to get to more detailed data for each repository

![](../public/img/browse2.png)


### <a href="#listing" name="listing">#</a> Get a list of repositories within R

```r
rrt_repos_list()
```

```r
No. repos: 8
First 10 repo ids : 29307e120a662d571bfd9fa1395f426e, 277c8be765b8fa66fb8180204459d408, 8ebc7000ea66165b24ba492d99a729fc, 543e3adeb00dfec82628addcb2dffbb4, 4177de12146511bf69a6d6cec69eb8d2, 1a6f0d8a387c0854464d260da141a9ea, 837809181e43446a37f550c0ef38c125, 0b34a89dda7b251d24c39fd90bf9881c
```

```r
rrt_repos_list()[[1]]
```

```r
$repo
[1] "~/howdydoody//rrt/rrt_manifest.txt"

$InstalledWith
[1] "RRT"

$InstalledFrom
[1] "source"

$RRT_version
[1] "0.0.1"

$R_version
[1] "3.1.0"

$DateCreated
[1] "2014-20-16"

$PkgsInstalledAt
[1] "/Users/sacmac/howdydoody//rrt/lib/x86_64-apple-darwin13.1.0/3.1.0"

$RepoID
[1] "29307e120a662d571bfd9fa1395f426e"

$Packages
[1] "colorspace,dichromat,digest,ggplot2,gtable,labeling,MASS,munsell,plyr,proto,RColorBrewer,Rcpp,reshape2,scales,stringr,lattice"

$SystemRequirements
[1] ""

$repo_root
[1] "~/howdydoody/"
```


### <a href="#starting" name="starting">#</a> Starting R from a repo

If you start R from a RRT repository R will use the repository specific `.Rprofile` file and look for packages in the repository to install instead of the global R packages library.

### <a href="#mran" name="mran">#</a> Get packages from MRAN

Note: this doesn't install them, only downloads them.

```r
pkgs_mran(pkgs = c("plyr","ggplot2","dplyr","taxize"), outdir = "~/mypkgs")
```

```r
... Downloading package files
```

Which results in the following files in the directory `mypkgs`:

```
dplyr_0.2.tar.gz
ggplot2_1.0.0.tar.gz
plyr_1.8.1.tar.gz
taxize_0.3.0.tar.gz
```

You can also install from MRAN using a more traditional approach using `install.packages()`

```r
install.packages("http://mran.revolutionanalytics.com/snapshots/src/2014-07-18_0500/stringr/stringr_0.6.2.tar.gz", repos = NULL, type="source")
```

```r
Installing package into ‘/Users/sacmac/Library/R/3.1/library’
(as ‘lib’ is unspecified)
trying URL 'http://mran.revolutionanalytics.com/snapshots/src/2014-07-18_0500/stringr/stringr_0.6.2.tar.gz'
Content type 'application/octet-stream' length 20636 bytes (20 Kb)
opened URL
==================================================
downloaded 20 Kb

* installing *source* package ‘stringr’ ...
** package ‘stringr’ successfully unpacked and MD5 sums checked
** R
** inst
** preparing package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded
* DONE (stringr)
```

Or just download using `download.packages()`

```r
download.file("http://mran.revolutionanalytics.com/snapshots/src/2014-07-18_0500/stringr/stringr_0.6.2.tar.gz", destfile = 'stringr_0.6.2.tar.gz')
```

```r
trying URL 'http://mran.revolutionanalytics.com/snapshots/src/2014-07-18_0500/stringr/stringr_0.6.2.tar.gz'
Content type 'application/octet-stream' length 20636 bytes (20 Kb)
opened URL
==================================================
downloaded 20 Kb
```

You can also get binaries from MRAN:

Download:

```r
download.file("http://mran.revolutionanalytics.com/snapshots/bin/macosx/2014-07-15_0043/stringr_0.6.2.tgz", destfile = "stringr_0.6.2.tgz")
```

Install

```r
install.packages("http://mran.revolutionanalytics.com/snapshots/bin/macosx/2014-07-15_0043/stringr_0.6.2.tgz", repos=NULL)
```

Note that MRAN is not a "CRAN-like" repository so you can't just use `install.packages()` as you normally would like `install.packages("stringr")`. 

### <a href="#clean" name="clean">#</a> Clean

You can clean out all package sources and installed packages from your repository with a single easy to use function: `rrt_sweep()`. This defaults to work from your current working directory, and deletes all package sources and installed packages. This basically creates a clean slate in your `rrt/` directory in your respository. Your manifest file is unchanged though to retain metadata important to replication of your efforts.



```r
rrt_sweep()
```

```r
Checking to make sure repository exists...
Checking to make sure rrt directory exists inside your repository...
Package sources removed
Your repository packages successfully removed:
abind
doMC
foreach
iterators
itertools
plyr
Rcpp
testthat
```

This leaves you with all your personal files, your `rrt/` directory, and your manifest file intact.
