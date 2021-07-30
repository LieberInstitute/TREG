
#' Get the Proption of Zero Counts for Each Gene in Each Group
#'
#' @param sce
#' @param group_col
#'
#' @return data.frame containing proption of zero counts, genes as rows, groups as columns
#' @export
#'
#' @examples
#' rowSums(assays(sce_zero_test)$counts)
#' get_prop_zero(sce_zero_test)
#' get_prop_zero(sce_zero_test, group_col = "group")
#' @importFrom rafalib splitit
#' @importFrom purrr map_dfc
get_prop_zero <- function(sce, group_col = "cellType"){

  gene_propZero <- purrr::map_dfc(rafalib::splitit(sce[[group_col]]), function(indx){
    sce_temp <- sce[,indx]
    # message(ncol(sce_temp))
    prop_zero <- rowSums(as.matrix(assays(sce_temp)$counts) == 0)/ncol(sce_temp)
    return(prop_zero)
  })
  gene_propZero <- as.data.frame(gene_propZero)
  rownames(gene_propZero) <- rownames(sce)
  return(gene_propZero)
}
