## This is a minor release of version 1.2.0.

### Major changes:
* Functions below are modified as generic functions, argument `iscsvfile = TRUE` is no longer needed:

  * `tabulate_edges()`,
  * `plotNGTData()`,
  * `edgelist_raw()`.

### Minor changes:
* Maintainer change:
  
  New maintainer:
    Qi Cui <q1cui@ucsd.edu>
  Old maintainer(s):
    Stanley Lo <smlo@ucsd.edu>
* Rectifying warnings in functions 

  * `plotNGTData()`,
  * `summaryNet()`.
  
Best regards,

Qi

## Test environments

* R-hub:
  * Windows Server 2022, R-devel, 64 bit | x86_64-w64-mingw32 (64-bit) | R-devel(r84363 ucrt)
  * Ubuntu Linux 20.04.1 LTS, R-release, GCC | x86_64-pc-linux-gnu (64-bit) | R-release 4.3.0
  * Fedora Linux, R-devel, clang, gfortran | x86_64-pc-linux-gnu | R-devel (r84528)
  
* check_win_devel():
  * Windows Server 2022 x64 (build 20348) | x86_64-w64-mingw32 | R-devel (r84676 ucrt)

* Local:
  * macOS Ventura 13.4.1 | aarch64-apple-darwin20 (64-bit) | R-release 4.2.2


## R CMD check results

There are 0 errors and 0 warnings.
Notes are listed below:

* On R-hub, win_devel, local:
    
  ```
  * checking CRAN incoming feasibility ... NOTE
  Maintainer: ‘Qi Cui <q1cui@ucsd.edu>’
    
  New maintainer:
    Qi Cui <q1cui@ucsd.edu>
  Old maintainer(s):
    Stanley Lo <smlo@ucsd.edu>
  ```
* On R-hub (windows_r-devel):

  ```
  * checking sizes of PDF files under 'inst/doc' ... NOTE
  Unable to find GhostScript executable to run checks on size reduction
  ```
  ```
  * checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
  ''NULL''
  ```
  ```
  * checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
  'lastMiKTeXException'
  ```
  which are likely to be ignored as noted in 
  * [R-hub issue #51](https://github.com/r-hub/rhub/issues/51)
  * [R-hub issue #503](https://github.com/r-hub/rhub/issues/503)
  * [R-hub issue #560](https://github.com/r-hub/rhub/issues/560).


* On R-hub (ubuntu_r-release and fedora_r-devel):
  ```
  * checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  ```
  which is likely to be ignored as noted in [R-hub issue #548](https://github.com/r-hub/rhub/issues/548).
  
<div class="alert alert-info">
  <strong>Note:</strong> Emails from two R-hub checks (ubuntu and fedora) show <font color="red">PREPERROR</font>. This is likely due to long logs  as noted in [R-hub issue #86](https://github.com/r-hub/rhub/issues/86), in our case long logs are caused by gcc/clang and gfortran related compilation for c, c++ and fortran codes from other packages. All R-hub checks are success.
</div>



## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
