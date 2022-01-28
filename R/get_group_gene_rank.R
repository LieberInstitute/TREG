#' Get the Rank of the Mean logcount for each Gene in each Group
#'
#' @inheritParams rank_cells
#'
#' @return Named list of ranks for each gene
#' @export
#'
#' @examples
#' ## TODO add comments
#' get_group_gene_rank(sce_zero_test, group_col = "group")
#' @importFrom purrr map
#' @importFrom rafalib splitit
#' @importFrom SummarizedExperiment assays
get_group_gene_rank <- function(sce, group_col = "cellType") {
    group_gene_rank <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx) {
        sce_group <- sce[, indx, drop = FALSE]
        group_ranks <- rank(rowMeans(SummarizedExperiment::assays(sce_group)$logcounts))
        return(group_ranks)
    })

    return(group_gene_rank)
}
