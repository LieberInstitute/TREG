#' Get the Mean logcount for each Gene in each Group
#'
#' @param sce SingleCellExperiment Object with logcount assay
#' @param group_col name of the column in the colData of sce that defines the group of interest
#'
#' @return
#' @export
#'
#' @examples
#'
#' get_group_gene_mean(sce_zero_test, group_col = "group")
#'
#' @importFrom purrr map
#' @importFrom rafalib splitit
#' @importFrom SummarizedExperiment assays
get_group_gene_mean <- function(sce, group_col = "cellType"){

  group_gene_mean <- purrr::map(rafalib::splitit(sce[[group_col]]), function(indx){
    sce_group <- sce[,indx]
    group_rm <- rowMeans(SummarizedExperiment::assays(sce_group)$logcounts)
    return(group_rm)
  })

  return(group_gene_mean)
}
