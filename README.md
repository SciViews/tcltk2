
# tcltk2

<!-- badges: start -->
[![Linux Build Status](https://travis-ci.com/SciViews/tcltk2.svg )](https://travis-ci.com/SciViews/tcltk2)
[![Win Build Status](https://ci.appveyor.com/api/projects/status/github/SciViews/tcltk2?branch=master&svg=true)](https://ci.appveyor.com/project/phgrosjean/tcltk2)
[![Coverage Status](https://img.shields.io/codecov/c/github/SciViews/tcltk2/master.svg)
](https://codecov.io/github/SciViews/tcltk2?branch=master)
[![CRAN Status](https://www.r-pkg.org/badges/version/tcltk2)](https://cran.r-project.org/package=tcltk2)
[![License](https://img.shields.io/badge/license-LGPL3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0.html)
[![Life
cycle stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
<!-- badges: end -->

> Several additions to R through Tcl functions and Tk widgets.

## Installation

The latest stable version of {tcltk2} can simply be installed from [CRAN](http://cran.r-project.org):

```r
install.packages("tcltk2")
```

You can also install the latest developement version. Make sure you have the {remotes} R package installed:

```r
install.packages("remotes")
```

Use `install_github()` to install the {tcltk2} package from Github (source from **master/main** branch will be recompiled on your machine):

```r
remotes::install_github("SciViews/tcltk2")
```

R should install all required dependencies automatically, and then it should compile and install {tcltk2}.

Latest devel version of {tcltk2} (source + Windows binaires for the latest stable version of R at the time of compilation) is also available from [appveyor](https://ci.appveyor.com/project/phgrosjean/tcltk2/build/artifacts).

## Further explore tcltk2

You can get further help about this package this way. Make the {tcltk2} package available in your R session:

```r
library("tcltk2")
```

Get help about this package:

```r
library(help = "tcltk2")
help("tcltk2-package")
vignette("tcltk2") # None is installed with install_github()
```

For further instructions, please, refer to these help pages at https://www.sciviews.org/tcltk2/.

## Code of Conduct

Please note that the {tcltk2} package is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

## Note to developers

This package used to be developed on R-Forge in the past. However, the latest [R-Forge version](https://r-forge.r-project.org/projects/sciviews/) was moved to this Github repository on 2016-03-18 (SVN version 569). **Please, do not use R-Forge anymore for SciViews development, use this Github repository instead.**
