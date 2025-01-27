# Column names
GENE_NAME_COL <- "gene_name"

# Sample patterns
ORGANOID_PATTERN <- "D"
TESTIS_PATTERN <- "P"

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
  'D7' = '#B8DEB8',
  'P28' = '#5684E0',
  'P7' = '#89ABE3',
  'D56' = '#004200',
  'D21' = '#78A878',
  'D42' = '#496F49',
  'P90' = '#155B9B'
)

# Group order for sorting
GROUP_ORDER <- c(
  'D7',
  'D21',
  'D42',
  'D56',
  'P7',
  'P28',
  'P90'
)