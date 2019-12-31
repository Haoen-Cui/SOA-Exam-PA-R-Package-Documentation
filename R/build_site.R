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
#' @param ... other arguments (in addition to `pkg` and `override`)
#'     to be passed to `pkgdown::build_site`
#'
#' @return `invisible(NULL)`
#'
#' @examples
#' \dontrun{
#' build_site(path_to_dir = "./packages")
#' }
build_site <- function(path_to_dir, ...) {
    # get all packages in the directory
    pkg_dirs <- list.dirs(
        path = path_to_dir,
        full.names = FALSE,
        recursive = FALSE
    )

    # construct package menu
    extract_pkg_ver <- function(pkg_dir) {
        return(strsplit(pkg_dir, split = "-")[[1]][1])
    }
    pkg_menu <- lapply(pkg_dirs, function(pkg_dir) list(
        text = extract_pkg_ver(pkg_dir),
        href = sprintf("../%s/index.html", extract_pkg_ver(pkg_dir))
    ))

    # build site
    for ( pkg_dir in pkg_dirs ) {
        pkgdown::build_site(
            pkg = file.path(path_to_dir, pkg_dir),
            override = list(
                destination = file.path(
                    getwd(),
                    "docs",
                    extract_pkg_ver(pkg_dir)
                ),
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
    }

    return( invisible(NULL) )
}
