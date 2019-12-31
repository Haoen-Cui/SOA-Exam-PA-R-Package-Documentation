#' @export
#' @name build_site
#' @title Build Documentation Website
#' @description Build a complete documentation website
#'     for all `R` packages required for SOA Exam PA
#'     using `pkgdown` packages
#'
#' @importFrom pkgdown build_site
#'
#' @inheritParams download_pkgs
#' @param base_path (character) representing the base path to this project
#' @param ... other arguments (in addition to `pkg` and `override`)
#'     to be passed to `pkgdown::build_site`
#'
#' @return `invisible(NULL)`
#'
#' @examples
#' \dontrun{
#' build_site(path_to_dir = file.path(getwd(), "packages"))
#' }
build_site <- function(path_to_dir, base_path = getwd(), ...) {
    # get all packages in the directory
    pkg_dirs <- list.dirs(
        path = path_to_dir,
        full.names = FALSE,
        recursive = FALSE
    )

    # helper function
    extract_pkg_name <- function(pkg_dir) {
        return(strsplit(pkg_dir, split = "-")[[1]][1])
    }

    # build PAdocs
    navbar <- PKG_GLOBAL_ENV$PKGDOWN_OVERRIDE_NAVBAR
    navbar[["components"]][["packages"]][["menu"]] <- lapply(
        pkg_dirs,
        function(pkg_dir) {
            return(list(
                text = extract_pkg_name(pkg_dir),
                href = sprintf("./%s/index.html", extract_pkg_name(pkg_dir))
            ))
        })

    possible_err <- tryCatch({
        pkgdown::build_site(
            pkg = base_path,
            override = list(
                destination = file.path(base_path, "docs"),
                navbar = navbar
            ),
            ...
        )
    }, error = function(e) invisible(NULL))

    # build other
    pkg_paths  <- file.path(path_to_dir, pkg_dirs)
    dest_paths <- file.path(
        base_path,
        "docs",
        sapply(pkg_dirs, extract_pkg_name)
    )
    navbar <- PKG_GLOBAL_ENV$PKGDOWN_OVERRIDE_NAVBAR
    navbar[["components"]][["packages"]][["menu"]] <- lapply(
        pkg_dirs,
        function(pkg_dir) {
            return(list(
                text = extract_pkg_name(pkg_dir),
                href = sprintf("../%s/index.html", extract_pkg_name(pkg_dir))
            ))
        })

    for ( idx in seq_along(pkg_paths) ) {
        possible_err <- tryCatch({
            pkgdown::build_site(
                pkg = pkg_paths[idx],
                override = list(
                    destination = dest_paths[idx],
                    navbar = navbar
                ),
                ...
            )
        }, error = function(e) invisible(NULL))
        if ( inherits(possible_err, "error") ) next
    }

    return( invisible(NULL) )
}
