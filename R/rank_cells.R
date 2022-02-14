
#' Get the Rank of the Mean logcount for each Gene in each Cell
#'
#' @param sce SingleCellExperiment Object with logcount assay
#' @param group_col name of the column in the colData of sce that defines the group of interest
#' @param assay name of the assay in the sce object to use to rank
#'
#' @return
#' @export
#'
#' @examples
#' ## Rank the genes for each cell, organized by "group" column
#' rank_cells(sce_zero_test, group_col = "group")
#' @importFrom purrr map
#' @importFrom rafalib splitit
#' @importFrom SummarizedExperiment assays assayNames colData
rank_cells <- function(sce, group_col = "cellType", assay = "logcounts") {
    stopifnot(group_col %in% colnames(colData(sce)))
    stopifnot(assay %in% assayNames(sce))

    group_cell_rank <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx) {
        sce_group <- sce[, indx, drop = FALSE]
        cell_rank <- apply(SummarizedExperiment::assays(sce_group)[[assay]], 2, rank)
        return(cell_rank)
    })

    return(group_cell_rank)
}
