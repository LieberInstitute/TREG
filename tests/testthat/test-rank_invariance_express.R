## Input checks

# run full RI test
group_rank_test <- rank_group(sce_zero_test, group_col = "group")
cell_rank_test <- rank_cells(sce_zero_test, group_col = "group")
rank_invar_test <- rank_invariance(group_rank_test, cell_rank_test)

test_that("Bad Inputs Throw Error - RI Express", {
    ## bad column name
    expect_error(rank_invariance_express(sce = sce_zero_test, group_col = "NOT_THERE"))
    ## bad assay name
    expect_error(rank_invariance_express(sce = sce_zero_test, assay = "NOT_THERE", group_col = "group"))

    ## expect a value for each gene
    expect_equal(nrow(sce_zero_test), length(rank_invariance_express(sce = sce_zero_test, group_col = "group")))
    ## stepwise and express process should have the same output
    expect_equal(rank_invar_test, rank_invariance_express(sce = sce_zero_test, group_col = "group"))
})
