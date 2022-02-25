#' Filter Genes for by Max Proportion Zero Among Groups
#'
#' @param prop_zero_df data.frame containing proportion of zero counts, genes as
#' rows, groups as columns.
#' @param cutoff Cutoff Value for Maximum Proprotion Zero.
#'
#' @return A `character()` of gene names that are under the cutoff.
#' @export
#'
#' @examples
#' ## Get proportion zero data.frame
#' prop_zero <- get_prop_zero(sce_zero_test, group_col = "group")
#'
#' ## Filter with max proportion zero cutoff = 0.59
#' filter_prop_zero(prop_zero, cutoff = 0.59)
filter_prop_zero <- function(prop_zero_df, cutoff = 0.9) {
    stopifnot(is.data.frame(prop_zero_df))
    stopifnot(!is.null(rownames(prop_zero_df)))
    stopifnot(type(prop_zero_df) == "double")

    max_prop_zero <- apply(prop_zero_df, 1, max)
    filter_prop <- max_prop_zero[max_prop_zero < cutoff]
    return(names(filter_prop))
}
