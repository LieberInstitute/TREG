#' Get the Rank of the Mean expression for each Gene in each Cell
#'
#' TODO add a description
#'
#' @param sce [SingleCellExperiment::SingleCellExperiment-class] object with
#' the `assay` (defaults to `logcounts`).
#' @inheritParams get_prop_zero
#' @param assay A `character(1)` specifying the name of the `assay()` in the
#' `sce` object to use to rank expression values. Defaults to `logcounts` since
#' it typically contains the normalized expression values.
#'
#' @return A `list()` of `list()` objects. TODO.
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
