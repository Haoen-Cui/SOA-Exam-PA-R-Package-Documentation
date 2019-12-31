#' @export
#' @name download_pkgs
#' @title Download Packages to Disk
#' @description Download the latest version of `pkgs` by `as_of_date` to disk.
#'     Could take a while to run if input `pkgs` contains multiple packages.
#' @author Haoen Cui
#'
#' @importFrom utils download.file unzip
#'
#' @inheritParams get_pkg_version
#' @param path_to_dir (character, to be used as path to file system)
#'     path to file system where the downloaded packages will reside
#' @param verbose (logical) whether to print verbose logs to console
#'
#' @return a `list` containing
#' * `path_to_dir`: same as the input argument
#' * `pkg_dirs`: names of package directories within `path_to_dir`
#'
#' @examples
#' download_pkgs(
#'     pkgs = c("data.table", "knitr"),
#'     as_of_date = "2019-01-01",
#'     path_to_dir = "./packages"
#' )
download_pkgs <- function(
    pkgs = PAdocs::PKG_GLOBAL_ENV$PA_PKGS,
    as_of_date = PAdocs::PKG_GLOBAL_ENV$PKG_FREEZE_DATE,
    path_to_dir = tempdir(check = TRUE),
    verbose = TRUE
) {
    # get appropriate package versions
    if (verbose) message("Getting appropriate package versions...")
    pkgs_version_DT <- get_pkg_version(pkgs = pkgs, as_of_date = as_of_date)

    # initialize downloaded files
    downloaded_pkgs <- vector(
        mode = "character", length = nrow(pkgs_version_DT)
    )

    # create directory if not already exists
    if ( !dir.exists(path_to_dir) ) {
        if (verbose) message(sprintf("Creating directory %s", path_to_dir))
        dir.create(path_to_dir)
    }

    # download packages
    if (verbose) message(sprintf(
        "Start to download packages %s...",
        paste(
            pkgs_version_DT[, unique(package)],
            pkgs_version_DT[, unique(version)],
            sep = "-", collapse = ", "
        )
    ))
    for ( idx in seq_len(nrow(pkgs_version_DT)) ) {
        # try two different URL extensions
        for ( sub_url in c("releases/tag", "archive") ) {
            possible_err <- tryCatch({
                # package info
                pkg <- as.character(pkgs_version_DT[idx, package])
                pkg_version <- as.character(pkgs_version_DT[idx, version])
                # construct URLs
                download_url <-
                    sprintf(
                        "https://github.com/cran/%s/%s/%s.zip",
                        pkg, sub_url, pkg_version
                    )
                # construct local file path
                save_to_file <- file.path(
                    path_to_dir,
                    sprintf("%s-%s.zip", pkg, pkg_version)
                )
                # download file
                if (verbose) message(sprintf(
                    "Downloading package %s version %s from %s to %s",
                    pkg, pkg_version, download_url, save_to_file
                ))
                suppressWarnings(
                    utils::download.file(
                        url = download_url, destfile = save_to_file
                    )
                )
                # unzip file
                if ( file.exists(save_to_file) ) {
                    if (verbose) message(sprintf(
                        "Unzipping package %s in directory %s",
                        save_to_file, path_to_dir
                    ))
                    # unzip
                    utils::unzip(save_to_file, exdir = path_to_dir)
                    # remove docs directory if exists
                    unlink(
                        file.path(
                            path_to_dir,
                            sprintf("%s-%s", pkg, pkg_version),
                            "docs"
                        ),
                        recursive = TRUE
                    )
                    # append to return vector
                    downloaded_pkgs[idx] <- sprintf("%s-%s", pkg, pkg_version)
                }
            }, error = function(e) invisible(NULL))
            if ( inherits(possible_err, "error") ) next
        }
    }

    return(list(
        "path_to_dir" = path_to_dir,
        "pkg_dirs" = downloaded_pkgs
    ))
}
