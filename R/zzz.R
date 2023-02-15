
.onAttach <- function(lib, pkg) {
  packageStartupMessage("This is ttmoment ",
                        utils::packageDescription("ttmoment",
                                                  fields = "Version"
                        ),
                        appendLF = TRUE
  )
}


# -------------------------------------------------------------------------

show_progress <- function() {
  isTRUE(getOption("ttmoment.show_progress")) && # user disables progress bar
    interactive() # Not actively knitting a document
}



.onLoad <- function(libname, pkgname) {
  opt <- options()
  opt_ttmoment <- list(
    ttmoment.show_progress = TRUE
  )
  to_set <- !(names(opt_ttmoment) %in% names(opt))
  if (any(to_set)) options(opt_ttmoment[to_set])
  invisible()
}

