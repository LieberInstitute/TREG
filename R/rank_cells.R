
#' Get the Rank of the Mean logcount for each Gene in each Cell
#'
#' @param sce SingleCellExperiment Object with logcount assay
#' @param group_col name of the column in the colData of sce that defines the group of interest
#'
#' @return
#' @export
#'
#' @examples
#' rank_cells(sce_zero_test, group_col = "group")
#' @importFrom purrr map
#' @importFrom rafalib splitit
#' @importFrom SummarizedExperiment assays
rank_cells <- function(sce, group_col = "cellType") {
    group_cell_rank <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx) {
        sce_group <- sce[, indx, drop = FALSE]
        cell_rank <- apply(SummarizedExperiment::assays(sce_group)$logcounts, 2, rank)
        return(cell_rank)
    })

    return(group_cell_rank)
}
