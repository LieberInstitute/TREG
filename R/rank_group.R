#' Get the Rank of the Mean expression for each Gene in each Group
#'
#' TODO description.
#'
#' @inheritParams rank_cells
#'
#' @return Named `list()` of ranks for each gene
#' @export
#'
#' @examples
#' ## Rank the genes for each group defined by "group" column
#' rank_group(sce_zero_test, group_col = "group")
#' @importFrom purrr map
#' @importFrom rafalib splitit
#' @importFrom SummarizedExperiment assays assayNames colData
#' @importFrom Matrix rowMeans
rank_group <- function(sce, group_col = "cellType", assay = "logcounts") {
    stopifnot(group_col %in% colnames(colData(sce)))
    stopifnot(assay %in% assayNames(sce))

    group_gene_rank <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx) {
        sce_group <- sce[, indx, drop = FALSE]
        group_ranks <- rank(Matrix::rowMeans(assays(sce_group)$logcounts))
        return(group_ranks)
    })

    return(group_gene_rank)
}
