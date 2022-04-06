
## Input checks
test_that("Bad Inputs Throw Error", {
    bad_input <- data.frame(row.names = c("g1", "g2", "g3"), c1 = c(0, 1, 2))

    ## wrong input format
    expect_error(get_prop_zero(sce = bad_input))

    ## TODO Input w/o counts assay

    ## bad column name
    expect_error(get_prop_zero(sce = sce_zero_test, group_col = "NOT_THERE"))
})


## Test Expected Outputs
test_that("Output is good", {
    output <- get_prop_zero(sce = sce_zero_test)
    expect_s3_class(output, "data.frame")
    expect_true(all(output["g100", ] == 1))
    expect_true(all(output["g0", ] == 0))
})


test_that("Empty Levels Warn", {
    sce_zero_test$cellType <- factor(sce_zero_test$cellType, levels = c("A", "B", "C"))
    expect_warning(get_prop_zero(sce_zero_test))
})
