#' @export
#' @name get_pkg_version
#' @title Get Package Version
#' @description Get the latest version of `pkgs` by `as_of_date`.
#'     Could take a while to run if input `pkgs` contains multiple packages.
#' @author Haoen Cui
#'
#' @importFrom versions available.versions
#' @importFrom lubridate as_date
#' @importFrom data.table rbindlist as.data.table `:=`
#'
#' @inheritParams versions::available.versions
#' @param as_of_date (character, convertible to date)
#'     date of interest to subset versions of `pkgs`
#'
#' @return a `data.table` with the following columns:
#' * `package`: the name of the package
#' * `version`: the version of the package
#' * `date`: the date of the version release
#'
#' @examples
#' get_pkg_version(
#'     pkgs = c("data.table", "knitr"),
#'     as_of_date = "2019-01-01"
#' )
get_pkg_version <- function(
    pkgs = PKG_GLOBAL_ENV$PA_PKGS,
    as_of_date = PKG_GLOBAL_ENV$PKG_FREEZE_DATE
) {
    # get package available versions
    #   returns a list of equal length as pkgs
    #   with each component as a data.frame
    #   containing columns (version, date, available)
    #   versions::available.versions will take a while to run
    pkgs <- unique(pkgs)
    pkgs_version_ls <- versions::available.versions(pkgs = pkgs)
    pkgs_version_DT <- data.table::rbindlist(lapply(
        seq_along(pkgs_version_ls),
        function(idx) {
            DT <- data.table::as.data.table(pkgs_version_ls[[idx]])[, .(
                package = names(pkgs_version_ls)[idx],
                version = as.character(version),
                date = lubridate::as_date(date),
                available = as.logical(available)
            )]
            return(
                DT[
                    date <= lubridate::as_date(as_of_date) & available,
                    .(version, date, available),
                    by = package
                ][
                    date == max(date) & version == max_ver(version),
                    .(version, date, available),
                    by = package
                ]
            )
        }
    ))

    # raise warning if not all packages have an available version returned
    missing_pkgs <- setdiff(pkgs, pkgs_version_DT[, unique(package)])
    if ( length(missing_pkgs) > 0 ) warning(sprintf(
        "Some packages are missing: %s. Possibly because there is no available version before %s.",
        paste(missing_pkgs, collapse = ", "),
        as_of_date
    ))

    return( unique(pkgs_version_DT[, .(package, version, date)]) )
}


#' @export
#' @name max_ver
#' @title Max for Package Version
#' @description Find the latest package version
#'
#' @param pkg_versions (character vector) representing package version numbers
#'
#' @return a character of the latest package version
#'
#' @examples
#' max_ver(c("7.3-51.3", "7.3-51.3", "7.3-51.4"))
max_ver <- function(pkg_versions) {
    latest <- pkg_versions[1]
    for ( idx in seq_along(pkg_versions)[-1] ) {
        if ( utils::compareVersion(latest, pkg_versions[idx]) == -1 ) {
            latest <- pkg_versions[idx]
        }
    }
    return(latest)
}
