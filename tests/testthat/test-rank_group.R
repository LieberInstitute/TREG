## Input checks
test_that("Bad Inputs Throw Error", {
    bad_input <- data.frame(row.names = c("g1", "g2", "g3"), c1 = c(0, 1, 2))
    ## wrong input format
    expect_error(rank_group(sce = bad_input))

    ## bad column name
    expect_error(rank_group(sce = sce_zero_test, group_col = "NOT_THERE"))
})
