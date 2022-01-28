
#' Get the Rank of the Mean logcount for each Gene in each Cell
#'
#' @param sce SingleCellExperiment Object with logcount assay
#' @param group_col name of the column in the colData of sce that defines the group of interest
#'
#' @return
#' @export
#'
#' @examples
#' get_cell_gene_rank(sce_zero_test, group_col = "group")
#' @importFrom purrr map
#' @importFrom rafalib splitit
#' @importFrom SummarizedExperiment assays
get_cell_gene_rank <- function(sce, group_col = "cellType") {
    group_cell_rank <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx) {
        sce_group <- sce[, indx]
        cell_rank <- apply(SummarizedExperiment::assays(sce_group)$logcounts, 2, rank)
        return(cell_rank)
    })

    return(group_cell_rank)
}
