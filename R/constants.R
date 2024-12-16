# Column names
GENE_NAME_COL <- "gene_name"

# Sample patterns
ORGANOID_PATTERN <- "organoid"
TESTIS_PATTERN <- "testis"

# File paths
TPM_FILE_PATH <- "data/tpm_df.tsv"

# Data processing constants
COLS_TO_REMOVE <- NULL

# Cell types
CELL_TYPE_TESTIS <- "Testis"
CELL_TYPE_ORGANOID <- "Organoid"

# P-value thresholds
ALPHA_LEVELS <- c(0.05, 0.01)

# Color scheme for groups
GROUP_COLORS <- list(
  'D7_organoid' = '#B8DEB8',
  'P28_testis' = '#5684E0',
  'P7_testis' = '#89ABE3',
  'D56_organoid' = '#004200',
  'D21_organoid' = '#78A878',
  'D42_organoid' = '#496F49',
  'P90_testis' = '#155B9B'
)

# Group order for sorting
GROUP_ORDER <- c(
  'D7_organoid',
  'D21_organoid',
  'D42_organoid',
  'D56_organoid',
  'P7_testis',
  'P28_testis',
  'P90_testis'
)