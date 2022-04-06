#' Calculate the Rank Invariance of Each Gene from SCE object
#'
#' This function computes the Rank Invariance value for each gene, over the
#' groups defined by the user. This function computes the same RI values as running
#' `rank_cells()` + `rank_group()` + `rank_invariance()`.
#' Genes with high RI values are considered good candidate TREGs. This function is
#' more efficient than running the previous three functions.
#'
#' @inheritParams rank_cells
#'
#' @return A `numeric()` with the rank of invariance for each gene. High values
#' represent low Rank Invariance, these genes are considered good candidate TREGs.
#' @export
#'
#' @examples
#' ## Calculate RI for the sce object
#' ## Highest RI value is best candidate TREG, and can change based on the grouping of interest
#' rank_invariance_express(sce_zero_test, group_col = "group")
#' rank_invariance_express(sce_zero_test, group_col = "cellType")
#' @family invariance functions
#' @import SummarizedExperiment
rank_invariance_express <- function(sce, group_col = "cellType", assay = "logcounts") {
    stopifnot(group_col %in% colnames(colData(sce)))
    stopifnot(assay %in% assayNames(sce))

    ## Check for empty levels in grouping col
    if (is.factor(sce[[group_col]]) & any(table(sce[[group_col]]) == 0)) {
        warning("Dropping Empty Levels in group_col: ", group_col)
        sce[[group_col]] <- droplevels(sce[[group_col]])
    }

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
