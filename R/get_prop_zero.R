
#' Get the Proption of Zero Counts for Each Gene in Each Group
#'
#' @param sce [SingleCellExperiment-class][SingleCellExperiment::SingleCellExperiment-class] Object
#' @param group_col name of the column in the colData of sce that defines the group of interest
#'
#' @return data.frame containing proportion of zero counts, genes as rows, groups as columns
#' @export
#'
#' @examples
#' ## Basic Proportion counts == 0
#' rowSums(assays(sce_zero_test)$counts == 0) / nrow(sce_zero_test)
#'
#' ## Get proportion by cell type
#' get_prop_zero(sce_zero_test)
#'
#' ## Get proption by defined group
#' get_prop_zero(sce_zero_test, group_col = "group")
#' @importFrom rafalib splitit
#' @importFrom purrr map_dfc
#' @importFrom SummarizedExperiment assasys assayNames colData
get_prop_zero <- function(sce, group_col = "cellType") {
    ## Error checks
    stopifnot(inherits(sce, "SummarizedExperiment"))
    stopifnot("counts" %in% assayNames(sce))
    stopifnot(group_col %in% colnames(colData(sce)))

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
