## Input checks
test_that("Bad Inputs Throw Error", {
    bad_input <- data.frame(row.names = c("g1", "g2", "g3"), c1 = c(0, 1, 2))
    ## wrong input format
    expect_error(rank_cell(sce = bad_input))

    ## bad column name
    expect_error(rank_cells(sce = sce_zero_test, group_col = "NOT_THERE"))
})

test_that("Empty Levels are Dropped", {
    sce_zero_test$cellType <- factor(sce_zero_test$cellType, levels = c("A", "B", "C"))
    expect_warning(rank_cells(sce_zero_test))
})
