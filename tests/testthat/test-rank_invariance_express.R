## Input checks

test_that("Bad Inputs Throw Error - RI Express", {
    ## bad column name
    expect_error(rank_invariance_express(sce = sce_zero_test, group_col = "NOT_THERE"))
    ## TODO Input w/o counts assay
})
