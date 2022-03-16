#' Calculate the Rank Invariance of Each Gene from Cell and Group Ranks
#'
#' This function computes the Rank Invariance value for each gene, from the cell
#' and group ranks  computed by `rank_cells` and `rank_group` respectively. 
#' Genes with high RI values are considered good candidate TREGs.
#'
#' @param group_rank A `data.frame()` created with `rank_group()`.
#' @param cell_rank A `data.frame()` created with `rank_cells()`.
#'
#' @return A `numeric()` with the rank of invariance for each gene. High values
#' represent low Rank Invariance, these genes are considered good candidate TREGs.
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
#' @importFrom Matrix rowMeans
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
