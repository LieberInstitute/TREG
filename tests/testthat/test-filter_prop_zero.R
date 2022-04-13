test_prop_zero <- get_prop_zero(sce_zero_test, group_col = "group")

## Input checks
test_that("Bad Inputs Throw Error", {
    ## input sce not prop df
    expect_error(filter_prop_zero(prop_zero_df = sce_zero_test))

    ## type != double
    expect_error(filter_prop_zero(prop_zero_df = data.frame("c1" = letters)))

    ## cutoff is not numeric
    expect_error(filter_prop_zero(prop_zero_df = test_prop_zero, cutoff = "1.5"))
    expect_error(filter_prop_zero(prop_zero_df = test_prop_zero, cutoff = 1.5))
    expect_error(filter_prop_zero(prop_zero_df = test_prop_zero, cutoff = 1.5))

    ## empty df
    expect_error(filter_prop_zero(prop_zero_df = data.frame()))
})

test_that("Output Makes Sense", {
    # Warn if no genes pass filter
    expect_warning(filter_prop_zero(prop_zero_df = test_prop_zero, cutoff = 0))

    # Check output with test data
    expect_equal(filter_prop_zero(prop_zero_df = test_prop_zero, cutoff = 0.59), c("g50", "g0"))
})

test_that("NA handling works", {
    test_prop_zero[1, 1] <- NA
    expect_true(all(!is.na(filter_prop_zero(test_prop_zero, na.rm = TRUE))))
    expect_warning(na_filter <- filter_prop_zero(test_prop_zero, na.rm = FALSE))
    expect_equal(length(na_filter), sum(!apply(test_prop_zero, 1, anyNA)))
})
