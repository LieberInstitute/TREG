#' Get the Proportion of Zero Counts for Each Gene in Each Group
#'
#' This function calculates the Proportion Zero for each gene in each user defined group.
#' Proportion Zero = number of zero counts for a gene for a group of cells/number of cells in the group.
#'
#' For more information about calculating Proportion Zero, check equation 1 from
#'  the vignette in section "Calculate Proportion Zero and Pick Cutoff".
#'
#' @param sce [SummarizedExperiment-class][SummarizedExperiment::SummarizedExperiment-class] object
#' @param group_col name of the column in the
#' [colData()][SummarizedExperiment::SummarizedExperiment-class] of `sce`
#' that defines the group of interest.
#'
#' @return A `data.frame()` containing proportion of zero counts, genes as rows,
#' groups as columns.
#' @export
#'
#' @examples
#' ## Basic Proportion counts == 0
#' rowSums(assays(sce_zero_test)$counts == 0) / nrow(sce_zero_test)
#'
#' ## Get proportion by the default group "cellType"
#' get_prop_zero(sce_zero_test)
#'
#' ## Get proportion by user defined grouping of the data
#' get_prop_zero(sce_zero_test, group_col = "group")
#' @importFrom rafalib splitit
#' @importFrom purrr map_dfc
#' @importFrom SummarizedExperiment assays assayNames colData
#' @family Proportion Zero functions
get_prop_zero <- function(sce, group_col = "cellType") {
    ## Error checks
    stopifnot(inherits(sce, "SummarizedExperiment"))
    stopifnot("counts" %in% SummarizedExperiment::assayNames(sce))
    stopifnot(group_col %in% colnames(colData(sce)))
    
    ## Check for empty levels in grouping col
    if (is.factor(sce[[group_col]]) & any(table(sce[[group_col]]) == 0)) {
        warning("Empty Levels in group_col: ", group_col)
    }

    gene_propZero <- purrr::map_dfc(rafalib::splitit(sce[[group_col]]), function(indx) {
        sce_group <- sce[, indx, drop = FALSE]
        # message(ncol(sce_group))
        # TODO test with removing as.matrix, what breaks?
        prop_zero <- rowSums(as.matrix(assays(sce_group)$counts) == 0) / ncol(sce_group)
        return(prop_zero)
    })
    gene_propZero <- as.data.frame(gene_propZero)
    rownames(gene_propZero) <- rownames(sce)
    return(gene_propZero)
}
