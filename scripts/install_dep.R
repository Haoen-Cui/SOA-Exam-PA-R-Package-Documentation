pkgs_version_DT <- PAdocs::get_pkg_version()

# install specific versions of packages needed
for ( idx in seq_len(nrow(pkgs_version_DT)) ) {
    devtools::install_version(
        package = pkgs_version_DT[idx, package],
        version = pkgs_version_DT[idx, version],
        repos = "https://cran.rstudio.com/"
    )
}

# install additional dependencies for pkgdown website
install.packages(c(
    "mlbench", "rsample", "nycflights13", "hexbin",
    "profvis", "lars", "import", "repurrrsive", "vcd"
))
