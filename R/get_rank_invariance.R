
#' Calculate the Rank Invariance of Each Gene from Cell and Group Ranks
#'
#' @param group_rank
#' @param cell_rank
#'
#' @return rank of invariance for each gene
#' @export
#'
#' @examples
#' group_rank_test <- get_group_gene_rank(sce_zero_test, group_col = "group")
#' cell_rank_test <- get_cell_gene_rank(sce_zero_test, group_col = "group")
#' rank_invar_test <- get_rank_invariance(group_rank_test, cell_rank_test)
#' @importFrom purrr map2 map_dfc
get_rank_invariance <- function(group_rank, cell_rank){

  # message(length(group_rank[[1]]) == nrow(cell_rank[[1]]))
  rank_diff <- purrr::map2(cell_rank, group_rank, ~sweep(.x, 1, STATS = .y, FUN = "-"))

  rank_diff_cell_type <- as.matrix(purrr::map_dfc(rank_diff, ~rank(rowSums(abs(.x)))))
  rownames(rank_diff_cell_type) <- rownames(rank_diff[[1]])

  gene_rank_invar <- rank(rowSums(rank_diff_cell_type))

  # Reverse rank so max(rank) is max invariance
  gene_rank_invar <- length(gene_rank_invar) + 1 - gene_rank_invar
  return(gene_rank_invar)
}

#' Calculate the Rank Invariance of Each Gene from SCE object w/ groups
#'
#' @param sce SingleCellExperiment Object with logcount assay
#' @param group_col name of the column in the colData of sce that defines the group of interest
#'
#' @return rank of invariance for each gene
#' @export
#'
#' @examples
#' get_rank_invariance_express(sce_zero_test, group_col = "group")
get_rank_invariance_express <- function(sce, group_col = "cellType"){

  rank_diff <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx){
    sce_group <- sce[,indx]
    group_ranks <- rank(rowMeans(SummarizedExperiment::assays(sce_group)$logcounts))
    cell_rank <- apply(SummarizedExperiment::assays(sce_group)$logcounts, 2, rank)
    rd <- sweep(cell_rank, 1, STATS = group_ranks, FUN = "-")
  })

  rank_diff_cell_type <- as.matrix(purrr::map_dfc(rank_diff, ~rank(rowSums(abs(.x)))))
  rownames(rank_diff_cell_type) <- rownames(rank_diff[[1]])

  gene_rank_invar <- rank(rowSums(rank_diff_cell_type))

  # Reverse rank so max(rank) is max invariance
  gene_rank_invar <- length(gene_rank_invar) + 1 - gene_rank_invar
  return(gene_rank_invar)
}

