
#' Calculate the Rank Invariance of Each Gene from Cell and Group Ranks
#'
#' @param group_rank data.frame from \link[TREG]{rank_group}
#' @param cell_rank data.frame from  \link[TREG]{rank_cells}
#'
#' @return rank of invariance for each gene
#' @export
#'
#' @examples
#' ## Get the rank of the gene in each group
#' group_rank_test <- rank_group(sce_zero_test, group_col = "group")
#'
#' ## Get the rank of the gene for each cell
#' cell_rank_test <- rank_cells(sce_zero_test, group_col = "group")
#'
#' ## Use both rankings to calculate rank_invariance
#' rank_invar_test <- rank_invariance(group_rank_test, cell_rank_test)
#' @family invariance functions
#' @importFrom purrr map2 map_dfc
rank_invariance <- function(group_rank, cell_rank) {
    ## check inputs
    stopifnot(is.list(group_rank))
    stopifnot(is.list(cell_rank))

    if (length(group_rank) != length(cell_rank)) stop("`group_rank` and `cell_rank` lengths don't match. Did you use the same groups to calculate these values?")

    ## Warn if group names don't match
    if (any(names(group_rank) != names(cell_rank))) warning("`group_rank` and `cell_rank` names don't match")

    rank_diff <- purrr::map2(cell_rank, group_rank, ~ sweep(.x, 1, STATS = .y, FUN = "-"))

    rank_diff_cell_type <- as.matrix(purrr::map_dfc(rank_diff, ~ rank(rowSums(abs(.x)))))
    rownames(rank_diff_cell_type) <- rownames(rank_diff[[1]])

    gene_rank_invar <- rank(rowSums(rank_diff_cell_type))

    # Reverse rank so max(rank) is max invariance
    gene_rank_invar <- length(gene_rank_invar) + 1 - gene_rank_invar
    return(gene_rank_invar)
}

#' Calculate the Rank Invariance of Each Gene from SCE object w/ groups
#'
#' @inheritParams rank_cells
#'
#' @return rank of invariance for each gene
#' @export
#'
#' @examples
#' ## Calulate RI for the sce object
#' rank_invariance_express(sce_zero_test, group_col = "group")
#' @family invariance functions
rank_invariance_express <- function(sce, group_col = "cellType", assay = "logcounts") {
    stopifnot(group_col %in% colnames(colData(sce)))
    stopifnot(assay %in% assayNames(sce))

    rank_diff <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx) {
        sce_group <- sce[, indx]
        group_ranks <- rank(rowMeans(SummarizedExperiment::assays(sce_group)$logcounts))
        cell_rank <- apply(SummarizedExperiment::assays(sce_group)$logcounts, 2, rank)
        rd <- sweep(cell_rank, 1, STATS = group_ranks, FUN = "-")
    })

    rank_diff_cell_type <- as.matrix(purrr::map_dfc(rank_diff, ~ rank(rowSums(abs(.x)))))
    rownames(rank_diff_cell_type) <- rownames(rank_diff[[1]])

    gene_rank_invar <- rank(rowSums(rank_diff_cell_type))

    # Reverse rank so max(rank) is max invariance
    gene_rank_invar <- length(gene_rank_invar) + 1 - gene_rank_invar
    return(gene_rank_invar)
}
