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

    # construct package menu
    extract_pkg_name <- function(pkg_dir) {
        return(strsplit(pkg_dir, split = "-")[[1]][1])
    }
    pkg_menu <- lapply(pkg_dirs, function(pkg_dir) list(
        text = extract_pkg_name(pkg_dir),
        href = sprintf("../%s/index.html", extract_pkg_name(pkg_dir))
    ))

    # build site
    pkg_paths  <- file.path(path_to_dir, pkg_dirs)
    dest_paths <- file.path(
        base_path,
        "docs",
        sapply(pkg_dirs, extract_pkg_name)
    )
    pkg_paths  <- c(pkg_paths, base_path)
    dest_paths <- c(dest_paths, file.path(base_path, "docs"))

    for ( idx in seq_along(pkg_paths) ) {
        possible_err <- tryCatch({
            pkgdown::build_site(
                pkg = pkg_paths[idx],
                override = list(
                    destination = dest_paths[idx],
                    navbar = list(
                        structure = list(
                            left = c(
                                "home",
                                "packages",
                                "intro",
                                "reference",
                                "articles",
                                "tutorials"
                            ),
                            right = c("github")
                        ),
                        components = list(
                            packages = list(
                                text = "R Packages",
                                icon = "fas fa-archive fa-lg",
                                menu = pkg_menu
                            )
                        )
                    )
                ),
                ...
            )
        }, error = function(e) invisible(NULL))
        if ( inherits(possible_err, "error") ) next
    }

    return( invisible(NULL) )
}
