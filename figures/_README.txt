# figures_crm_data/
# =============================================================================
# Data files required for Cell Reports Medicine figures
# =============================================================================
#
# INSTRUCTIONS:
# Place all files listed below into this folder.
# The figures_CRM_complete.R script reads from this folder.
# Set: data_dir <- "figures_crm_data"
#
# =============================================================================
# FILE MANIFEST
# =============================================================================
#
# CORE DATA (provided / uploaded):
# ├── labs_miss0_25_MiceImp_adjAgeSexRaceBMIsmoke_invNorm.csv  [541 metabolites + phenotype, n=160]
# ├── ebw_metab_cohort.csv                                     [EBW timepoints for metabolomics cohort]
# ├── ebwdata_long.csv                                         [Pre-saved long-format EBW trajectories]
# ├── cprobrygb_ebw4.csv                                       [EBW for full RYGB cohort, 3 classes]
# └── mrs_final.csv                                            [MetRS metabolite weights/estimates]
#
# MODEL / RESULTS FILES:
# ├── metrs_log_model.csv                                      [Odds ratios for forest plot - Fig 3d]
# ├── step_bs_pct48_step_results.csv                           [Stepwise regression results]
# ├── cohort_for_matching.csv                                  [Strata assignments for clogit]
# └── mrs_step_results.csv                                     [MetRS step results for validation]
#
# POST-RYGB REPLICATION COHORT (Fig 4a):
# ├── phenotype.csv                                            [Subject phenotype: swl/rgn/ctrl]
# ├── c8_log_int_min_impute.csv                                [C8 column metabolites]
# ├── hn_log_int_min_impute.csv                                [HILIC-neg metabolites]
# ├── hp_log_int_min_impute.csv                                [HILIC-pos metabolites]
# ├── c18_log_int_min_impute.csv                               [C18-neg metabolites]
# └── ns_mrs_step.csv                                          [MetRS weights for post-RYGB validation]
#
# ESTONIA COHORT (Fig 4b):
# ├── codes.txt                                                [Sample ID mapping]
# ├── E22_residBMI_full_pheno.txt                              [Phenotype: Lean/Obese]
# ├── Obesity_extremes_spQC_miss0.25_medianMiceImp_adjAgeGenderLastmeal_invNorm.txt
# │                                                            [Estonia metabolite data]
# └── oe_mrs_step.csv                                          [MetRS weights for Estonia]
#
# LABS PHENOTYPE (for clogit / ROC / forest plot):
# └── [labs phenotype file with BMI, AGE_S, SEX, EBW, COHORT_ID]
#
# NOT YET PROVIDED (needed for extended data):
# ├── GWAS results files                                       [Fig S8 - Manhattan plots]
# └── Metabolomics_LABScohort_01042018.csv                     [Table 1 demographics]
#

# =============================================================================
# COLOR REFERENCE (for Illustrator / graphical abstract)
# =============================================================================
# Blue (SWL / Class 1 / primary):   #0072B2
# Orange (RGN / Class 2):           #E69F00
# Muted pink (Class 3):             #CC79A7
# Light blue (secondary/MAE):       #56B4E9
# Vermillion (validation/PreSx):    #D55E00
# Teal-green (PostSx):              #009E73
# Forest plot point/line:            #0072B2
# Correlation diverging:             #0072B2 — white — #D55E00
# =============================================================================

