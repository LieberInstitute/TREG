## code to prepare `sce_zero_test` dataset goes here

library(SingleCellExperiment)

pd <- S4Vectors::DataFrame(
    donor = rep(c("D1", "D2"), each = 50),
    cellType = rep(rep(c("A", "B"), each = 25), 2),
    region = rep(rep(c("Front", "Back"), each = 10), 5)
)
rownames(pd) <- paste0("S", stringr::str_pad(1:nrow(pd), width = nchar(nrow(pd)), pad = "0"))

combo <- paste0(pd$cellType, "_", pd$region)
(tc <- table(combo))
# A_Back A_Front  B_Back B_Front
#     25      25      25      25


counts <- matrix(
    data = c(
        rep(0, 100),
        rep(c(1, 0), 50),
        sample(1:100, 100),
        c(rep(1, 50), rep(0, 50)),
        c(rbinom(25, 1, 0.2), rbinom(25, 1, 0.4), rbinom(25, 1, 0.6), rbinom(25, 1, 0.8))
    ),
    ncol = 100,
    dimnames = list(c("g100", "g50", "g0", "gOffOn", "gVar"), rownames(pd)),
    byrow = TRUE
)

sce_zero_test <- SingleCellExperiment(list(counts = counts),
    colData = pd
)

assays(sce_zero_test)$logcounts <- log(assays(sce_zero_test)$counts + 1)

sce_zero_test$group <- paste0(sce_zero_test$cellType, "_", sce_zero_test$region)

usethis::use_data(sce_zero_test, overwrite = TRUE)
