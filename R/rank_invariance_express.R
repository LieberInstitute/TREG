#' Calculate the Rank Invariance of Each Gene from SCE object
#'
#' Description TODO.
#'
#' @inheritParams rank_cells
#'
#' @return A `numeric()` with the rank of invariance for each gene. High values
#' represent TODO.
#' @export
#'
#' @examples
#' ## Calculate RI for the sce object
#' rank_invariance_express(sce_zero_test, group_col = "group")
#' rank_invariance_express(sce_zero_test, group_col = "cellType")
#' @family invariance functions
#' @import SingleCellExperiment
rank_invariance_express <- function(sce, group_col = "cellType", assay = "logcounts") {
    stopifnot(group_col %in% colnames(colData(sce)))
    stopifnot(assay %in% assayNames(sce))

    rank_diff <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx) {
        sce_group <- sce[, indx]
        group_ranks <- rank(Matrix::rowMeans(SummarizedExperiment::assay(sce_group, assay)))
        cell_rank <- apply(SummarizedExperiment::assay(sce_group, assay), 2, rank)
        rd <- sweep(cell_rank, 1, STATS = group_ranks, FUN = "-")
        return(rd)
    })

    rank_diff_cell_type <- as.matrix(purrr::map_dfc(rank_diff, ~ rank(rowSums(abs(.x)))))
    rownames(rank_diff_cell_type) <- rownames(rank_diff[[1]])

    gene_rank_invar <- rank(rowSums(rank_diff_cell_type))

    # Reverse rank so max(rank) is max invariance
    gene_rank_invar <- length(gene_rank_invar) + 1 - gene_rank_invar
    return(gene_rank_invar)
}
