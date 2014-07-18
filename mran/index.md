---
layout: page
title: MRAN Overview
---

* [What is MRAN?](#whatismran)
* [MRAN](#indetail)
* [How are snapshots created?](#snapshots)
* [Important note regarding dates](#dates)
* [Difference between snapshots of MRAN](#diffsnaps)
* [Metadata and RRT integration](#metadatarrt)

### <a href="#whatismran" name="whatismran">#</a> What is MRAN?
MRAN is a server side component that works hand-in-hand with the client side
RRT package.
The goal of MRAN is to better organize the various places that R packages
live on CRAN, and add point in time capabilities allowing more precision for reproducibility.

### <a href="#indetail" name="indetail">#</a> In detail - MRAN (Modern R Archive Network)
MRAN is downstream snapshot of CRAN. The main differentiation of MRAN to CRAN
is that MRAN consists of a series of snapshots that are taken once a day
using a script that points to the master CRAN server in Vienna, Austria.
Authors of R packages that are hosted on CRAN are likely to update their packages at any point in time.
That is great as it keeps the ecosystem fresh and ensures that bug fixes are available. MRAN snapshots
combined with the RRT front end are in essence a trace back mechanism so R users will have a way to go
back to the version of a package that they were working on at a point in time.
Each MRAN snapshot holds all source versions of a package in the same
per-package directory on the MRAN server.  
i.e. [http://mran.revolutionanalytics.com/snapshots/src/2014-06-26_1400/zoo](http://mran.revolutionanalytics.com/snapshots/src/2014-06-26_1400/zoo)

### <a href="#snapshots" name="snapshots">#</a> How are snapshots created?
Snapshots are created using [ZFS](http://open-zfs.org/wiki/Main_Page).
The MRAN server is specifically using the native Linux kernel port, [ZFS-on-Linux](http://zfsonlinux.org/).
The ZFS-on-Linux project was started at [Lawrence Livermore National Laboratory](https://www.llnl.gov/).
[Open-ZFS](http://open-zfs.org/wiki/Main_Page) is an open source community project that
has a wide range of contributors and sponsors that comprise its ecosystem.

ZFS was chosen as the server side snapshot method for MRAN as it works on the block level,
not the file level like many other tools. It is efficient for storing compressed binary
files like .tar.gz or .zip, unlike SCM tools such as git, mercurial or subversion.
ZFS is very space efficient: ZFS snapshots are immutable objects that only take up the amount of
space that has changed between the snapshot and the 'live' file system. i.e.
very small when looking at the daily churn of R packages, but great space
savings when looking at the ecosystem of packages hosted on CRAN as a whole
over the course of a year.  
Note that backend processes work on the "live" file system, so for reproducability RRT always
points to a MRAN snapshot. A RRT user never see's the "live" file system.
A current overview of space usage on the current MRAN server can be found at:  
<br/>
[http://mran.revolutionanalytics.com/accounting.txt](http://mran.revolutionanalytics.com/accounting.txt)  
<br/>
All MRAN snapshots are exposed at:  
[http://mran.revolutionanalytics.com/snapshots/](http://mran.revolutionanalytics.com/snapshots/)


### <a href="#dates" name="dates">#</a> Important note regarding dates
MRAN snapshots are taken using the UTC time zone as the basis for dates.


### <a href="#diffsnaps" name="diffsnaps">#</a> Differences between snapshots of MRAN

The `zfs diff` command is the method that diffs are created with.
Diffs are taken between the most recent snapshot and the previous
snapshot so that RRT or a user can compare differences between them
at any point in time.

The output of the diffs are exposed at:  
[http://mran.revolutionanalytics.com/diffs/](http://mran.revolutionanalytics.com/diffs/)

### <a href="#metadatarrt" name="metadatarrt">#</a> Metadata and RRT integration

`mran_metadata.R` creates metadata from each snapshot of source packages.
A variety of metadata above and beyond what a CRAN package description file contains is stored for each R package.  
All metadata is exposed at:  
[http://mran.revolutionanalytics.com/metadata/](http://mran.revolutionanalytics.com/metadata/)
