#' Local test for package compatibility
#'
#' Currently, these checks, tests, etc. are run just on the packages used in your code in the repository tested - not the dependencies of the packages you use.
#'
#' @import testthat devtools digest
#' @export
#'
#' @details You can see a visual breakdown of check results using \link{rrt_browse} if you have run this function in your repository.
#'
#' Details for each option passed to the \code{what}:
#'
#' \bold{check:} We run \code{devtools::check()}, and skip building the package manual, vignettes, and we don't run examples, or tests. Examples and test are run in separate options passed to the \code{what} parameter. If check passes for a package TRUE is returned; otherwise FALSE.
#'
#' \bold{tests:} We first check for the existence of test in the package. If no tests exist, NULL returns. If tests exist we run them with \code{testthat::test_package()}. If tests pass for a package we return TRUE, otherwise we link to a report for the tests.
#'
#' \bold{examples:} We run examples. Some examples are wrapped in dontrun, which we don't run by default, but you can run them by passing on args to \code{devtools::run_examples()}.
#'
#' \bold{update:} We check for any available updates on CRAN for your packages using \code{old.packages}. NA is returned if no updates available. FIXME: add checks for github and Bioconductor packages.
#'
#' @param repo Repository path. Defaults to your working directory.
#' @param what What to test, one or more of check, tests, examples, or udpate. \code{match.arg} is
#' used internally so unique abbreviations can be used.
#' @param verbose (logical) Print messages (default) or not
#'
#' @seealso \link{rrt_browse}
#'
#' @examples \dontrun{
#' rrt_compat(what="update")
#' rrt_compat(what=c("update","check"))
#' }

rrt_compat <- function(repo=getwd(), what = 'check', verbose=TRUE)
{
  # write check file
  compatfile <- file.path(repo, "rrt/rrt_check.txt")
  cat("", file = compatfile)

  # Check for appropriate values of what
  what <- match.arg(what, c('check','tests','examples','update'), TRUE)

  # set defaults
  checksres <- testsres <- egsres <- oldpkgs <- "passed"

  ## create repo id using digest
  repoid <- digest(suppressWarnings(normalizePath(repo)))

  ## check for repo
  mssg(verbose, "Checking to make sure repository exists...")
  if(!file.exists(repo)){
    mssg(verbose, sprintf("No repository exists at %s", repo))
  }

  # check for rrt directory in the repo
  lib <- check_rrt_dir(verbose, repo)

  # get pkgs list in the rrt repo
  pkgs <- getpkgslist(repo)
  pkgnames <- getpkgnames(pkgs)
  
  # separate pkgs by source
  cranpkgs <- pkgnames[ is_cran_pkg(pkgnames) ]
  biocpkgs <- pkgnames[ is_bioc_pkg(pkgnames) ]

  # check: R CMD CHECK via devtools::check
  if("check" %in% what){
    checksres <- lapply(pkgs, checkrepo, repo=repo, verbose=verbose)
    names(checksres) <- pkgnames
    check <- data.frame(pkg=NA, check_result=NA)
    for(i in seq_along(checksres)){
      check[i,1] <- names(checksres[i])
      check[i,2] <- checksres[[i]]
    }
  } else { check <- data.frame(pkg=pkgnames, check_result=NA, stringsAsFactors = FALSE) }

  # run tests
  if("tests" %in% what){
    testrepo(pkgs, repo=repo, verbose=verbose)
    tfiles <- list.files(file.path(repo, "rrt", "tests"), full.names = TRUE)
    cat(tfiles, file = compatfile, sep = "\n")
    tdf <- data.frame(pkg=pkgnames, testfile=tfiles, stringsAsFactors = FALSE)
  } else { tdf <- data.frame(pkg=pkgnames, testfile=NA, stringsAsFactors = FALSE) }

  # run examples
  if("examples" %in% what){
    egsres <- NULL
  }

  # check for packages that need updating
  if("update" %in% what){
    
    # cran updates
    oldpkgs <- old.packages(lib.loc = lib)
    oldpkgs <- oldpkgs[,c('Package','Installed','ReposVer')]
    if(!is.null(oldpkgs)){
      hh <- t(oldpkgs)
      update <- data.frame(repo='CRAN', hh, stringsAsFactors = FALSE, row.names = NULL)
      names(update)[2] <- 'pkg'
    } else { update <- data.frame(repo='CRAN', pkg=pkgnames, update=NA, stringsAsFactors = FALSE) }
    
    # bioconductor updates
    biocup <- biocupdates(lib, biocpkgs)
    
    # github updates
    ### FIXME - for now any github packages are not checked
    # combine updates
    allupdates <- rbind(update, biocup)
  }

  df <- merge(check, tdf, by="pkg")
  df <- merge(df, allupdates, by="pkg", all = TRUE)
  saveRDS(df, file = file.path(repo, "rrt", "check_result.rds"))

  message("Tests complete!")
}

check_rrt_dir <- function(verbose, repo){
  mssg(verbose, "Checing to make sure rrt directory exists inside your repository...")
  lib <- file.path(repo, "rrt", "lib", R.version$platform, getRversion())
  present <- list.dirs(lib)
  if(!all(grepl("rrt", present))){
    mssg(verbose, "rrt directory doesn't exist...")
  }
  return( lib )
}

getpkgslist <- function(repo){
  pkgs_used <- rrt_deps(repo)
  tocheckpath <- file.path(repo, "rrt", "lib", R.version$platform, getRversion(), "src/contrib")
  pkgs <- list.files(tocheckpath, full.names = TRUE, recursive = FALSE)
  vapply(pkgs_used, function(z){
    tmp <- grep(z, pkgs, value = TRUE)
    if(length(tmp) > 1){
      justnames <- sapply(tmp, function(n){ b <- strsplit(n, "/")[[1]]; sub("_.+", "", b[length(b)]) })
      names(justnames)[justnames %in% z]
    } else { tmp }
  }, "", USE.NAMES = FALSE)
}

getpkgnames <- function(zzz){
  sapply(zzz, function(x)
    strsplit(strsplit(x, "/")[[1]][ length(strsplit(x, "/")[[1]]) ], "_|\\.")[[1]][[1]], USE.NAMES = FALSE)
}

checkrepo <- function(x, repo, verbose){
  pkgname <- strsplit(strsplit(x, "/")[[1]][ length(strsplit(x, "/")[[1]]) ], "_|\\.")[[1]][[1]]
  tmpdir <- tempdir()
  untar(x, exdir = tmpdir)
  dirs <- list.dirs(tmpdir, recursive = FALSE, full.names = FALSE)
  dirname <- grep(pkgname, dirs, value = TRUE)
  mssg(verbose, sprintf("Checking %s", pkgname))
  checkdir <- file.path(repo, "rrt/check")
  suppressWarnings(dir.create(checkdir))
  checkout <- sprintf("--output=%s", checkdir)
  out <- tryCatch(check(file.path(tmpdir, dirname), document = FALSE, doc_clean = FALSE, cleanup = FALSE, force_suggests = FALSE,
        args = c('--no-manual','--no-vignettes','--no-build-vignettes','--no-examples','--no-tests', checkout)), 
        error = function(e) e)
  if(is(out, 'simpleError')) "not a source package"
  else
    if(out) "passed" else "failed"
}

testrepo <- function(x, repo, verbose){
  tmpdir <- file.path(repo, "rrt", "tests", "tmp")# create temporary directory
  suppressWarnings(dir.create(tmpdir, recursive = TRUE))
  testit <- function(y){
    untar(y, exdir = tmpdir)
    dirs <- list.dirs(tmpdir, recursive = FALSE, full.names = FALSE)
    pkgname <- sub("_.+|\\.[A-Za-z]+", "", strsplit(y, "/")[[1]][length(strsplit(y, "/")[[1]])])
    dirname <- grep(pkgname, dirs, value = TRUE)
    capture.output(
      tryCatch(test_dir(file.path(tmpdir, sprintf("%s/tests", dirname))), error=function(e) "no tests found"), file = paste0(repo, "/rrt/tests/", pkgname, ".txt"))
  }
  lapply(x, testit)
  unlink(tmpdir, recursive = TRUE, force = TRUE)# cleanup temp dir
}

### bioc updates
biocupdates <- function(lib, bioc_pkgs){
  type <- getOption('pkgType')
  repos <- biocinstallRepos()
  pkgs <- installed.packages(lib)
  contribUrl <- contrib.url(repos, type = type)
  availPkgs <- available.packages(contribUrl, type = type)
  df <- old.packages(lib, repos = repos, instPkgs = pkgs, available = availPkgs, checkBuilt = TRUE, type = type)
  df <- data.frame(repo="Bioconductor", t(df[bioc_pkgs, c('Package','Installed','ReposVer')]), stringsAsFactors = FALSE)
  names(df)[2] <- 'pkg'
  df
}