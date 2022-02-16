## Input checks
test_that("Bad Inputs Throw Error", {
    ## input sce not prop df
    expect_error(filter_prop_zero(prop_zero_df = sce_zero_test))

    ## type != double
    expect_error(filter_prop_zero(prop_zero_df = data.frame("c1" = letters)))

    ## empty df
    expect_error(filter_prop_zero(prop_zero_df = data.frame()))
})
