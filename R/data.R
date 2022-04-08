#' Test SummarizedExperiment data
#'
#' A simulated [SummarizedExperiment-class][SummarizedExperiment::SummarizedExperiment-class]
#' object representing the expression of 100 cells across 5 genes.
#' This object is used as an example dataset throughout `TREG`.
#'
#' The `colData` of the object contains demo sample information about the cell,
#' that were designed to be used as `group_col`, (such as `cell_type`, `donor`, and  `region`).
#'
#' The expression of the 5 genes were designed to show a range of
#' Proportion Zeros across groups for different genes.
#' The overall `prop_zero` for these theoretical genes are:
#' * g100: `prop_zero = 1.00`
#' * g50: `prop_zero = 0.50`
#' * g0: `prop_zero = 0.00`
#' * gOffOn: `prop_zero = 0.50`
#' * gVar: `prop_zero = 0.54`
#'
#'
#' @format A [SummarizedExperiment-class][SummarizedExperiment::SummarizedExperiment-class]
#' object with 5 rows and 100 columns.
"sce_zero_test"
