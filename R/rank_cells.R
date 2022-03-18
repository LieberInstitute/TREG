#' Get the Rank of the Expression for each Gene in each Cell
#'
#' This function finds the rank of each gene's expression for each cell,
#' grouped by the user defined variable. This data is used to compute the rank
#' invariance value for each gene later with `rank_invariance`.
#'
#' @param sce [SummarizedExperiment-class][SummarizedExperiment::SummarizedExperiment-class] object with
#' the `assay` (defaults to `logcounts`).
#' @inheritParams get_prop_zero
#' @param assay A `character(1)` specifying the name of the
#' [assay()][SummarizedExperiment::SummarizedExperiment-class] in the
#' `sce` object to use to rank expression values. Defaults to `logcounts` since
#' it typically contains the normalized expression values.
#'
#' @return A named `list()` of `matrix()` objects. Each `matrix()` contains the
#' rank values for the cells belonging to one group.
#' @export
#'
#' @examples
#' ## Rank the genes for each cell, organized by "group" column
#' rank_cells(sce_zero_test, group_col = "group")
#' @family invariance functions
#' @importFrom purrr map
#' @importFrom rafalib splitit
#' @importFrom SummarizedExperiment assays assayNames colData
rank_cells <- function(sce, group_col = "cellType", assay = "logcounts") {
    stopifnot(group_col %in% colnames(colData(sce)))
    stopifnot(assay %in% assayNames(sce))

    group_cell_rank <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx) {
        sce_group <- sce[, indx, drop = FALSE]
        cell_rank <- apply(SummarizedExperiment::assay(sce_group, assay), 2, rank)
        return(cell_rank)
    })

    return(group_cell_rank)
}
