#### rank_invariance Tests ####

group_rank_test <- rank_group(sce_zero_test, group_col = "group")
cell_rank_test <- rank_cells(sce_zero_test, group_col = "group")

cell_rank_test_cell <- rank_cells(sce_zero_test, group_col = "cellType")
cell_rank_test_dn <- cell_rank_test

names(cell_rank_test_dn) <- c("A1", "A2", "B1", "B2")

test_that("Bad Inputs Throw Error - RI", {
    ## Different group column used
    expect_error(rank_invariance(group_rank_test, cell_rank_test_cell))
    expect_error(rank_invariance(group_rank_test, data.frame()))

    ## differnt group names should throw warning
    expect_warning(rank_invariance(group_rank_test, cell_rank_test_dn))

    ## expect a value for each gene
    expect_equal(nrow(sce_zero_test), length(rank_invariance(group_rank_test, cell_rank_test)))
})
