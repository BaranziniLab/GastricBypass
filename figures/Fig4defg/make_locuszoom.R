# LocusZoom plots for GLP1R region (chr6)
# 200 kb window centered on rs10305420 (GLP1R Ala316Thr, GRCh37)
# Metabolites: glucuronate, kynurenine, hippurate, C34:2 PC
#
# Genome build: GRCh37/hg19 (matches EnsDb.Hsapiens.v75)
#
# NOTE: rs10305420 (GRCh37 chr6:39,055,364) is absent from the FHS imputed
# dataset — the file has no SNP at that position (gap: 39055012 → 39055421).
# The index SNP therefore defaults to the minimum p-value SNP per metabolite.
#
# Requires:
#   install.packages("locuszoomr")
#   BiocManager::install("EnsDb.Hsapiens.v75")

library(locuszoomr)
library(EnsDb.Hsapiens.v75)
library(ggplot2)
library(data.table)
library(here)
setwd(here::here("figures/Fig4defg"))

# rs10305420 true GRCh37 position; variant absent from data — used only to
# center the 200 kb window
index_pos = 39055364L
flank     = 1e5        # 100 kb each side → 200 kb total

metabolites = list(
  list(
    file  = "data/FHS_EA_CENTRAL.glucuronate_merged.txt",
    title = "Glucuronate — GLP1R locus",
    out   = "locuszoom_glucuronate.png"
  ),
  list(
    file  = "data/FHS_EA_CENTRAL.kynurenine_merged.txt",
    title = "Kynurenine — GLP1R locus",
    out   = "locuszoom_kynurenine.png"
  ),
  list(
    file  = "data/FHS_EA_CENTRAL.hippurate_merged.txt",
    title = "Hippurate — GLP1R locus",
    out   = "locuszoom_hippurate.png"
  ),
  list(
    file  = "data/FHS_EA_LIPID.C34_2_PC_merged.txt",
    title = "C34:2 PC — GLP1R locus",
    out   = "locuszoom_c34_2pc.png"
  )
)

for (m in metabolites) {
  dt = fread(m$file, select = c("1KG_ID", "CHR", "POS", "BETA", "SE", "P_gc"))
  dt = dt[CHR == "6" & POS >= (index_pos - flank) & POS <= (index_pos + flank)]
  dt = dt[!is.na(P_gc) & P_gc > 0]

  setnames(dt, c("1KG_ID", "CHR", "POS", "P_gc"), c("rsid", "chrom", "pos", "p"))
  dt[, chrom := as.integer(chrom)]

  # rs10305420 is absent; index SNP defaults to lowest p-value in window
  loc = locus(
    data   = as.data.frame(dt),
    seqname = 6,
    xrange = c(index_pos - flank, index_pos + flank),
    chrom  = "chrom",
    pos    = "pos",
    labs   = "rsid",
    p      = "p",
    ens_db = "EnsDb.Hsapiens.v75"
  )

  p = locus_ggplot(loc, labels = "index") +
    labs(title = m$title)
  ggsave(m$out, p, width = 9, height = 6, dpi = 800, bg = "white")
  message("Saved: ", m$out)
}
