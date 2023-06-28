This is a minor release.

* Maintainer change.
* Rectifying warnings in functions 

  * `plotNGTData()`,
  * `summaryNet()`.
  
* Functions below are modified as generic functions, argument `iscsvfile = TRUE` is no longer needed:

  * `tabulate_edges()`,
  * `plotNGTData()`,
  * `edgelist_raw()`.

## R CMD check results

0 errors ✔ | 0 warnings ✔ | 1 note ✖

* checking CRAN incoming feasibility ... NOTE
  Maintainer: ‘Qi Cui <q1cui@ucsd.edu>’
  
  Version contains large components (1.1.8.9000)
  
  New maintainer:
    Qi Cui <q1cui@ucsd.edu>
  Old maintainer(s):
    Stanley Lo <smlo@ucsd.edu>

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages