# Imperial College branding for rendered course materials.
# Sourced from the setup chunk of each Rmd *only if this file exists*,
# so student copies of the Rmd files work without it (using ggplot2 defaults).

ic_pal <-c("#0000cd", "#161a1d",
           "#232333", "#000080","#8b4513", "#008080",
           "#c71585", "#4b0082", "#dc143c","#ff4500",
           "#006400", "#708090", "#0000cd","#ffff00",
           "#40e0d0", "#ee82ee", "#7b68ee", "#ff0000",
           "#ff8c00", "#00ff7f", "#f5f5f5", "#00bfff",
           "#f0e68c", "#afeeee", "#ffb6c1", "#e6e6fa",
           "#fa8072", "#ffa500", "#98fb98")
names(ic_pal) <- c("Imperial Blue", "Black",
                   "Dark","Navy Blue","Saddle Brown", "Teal",
                   "Medium Violet Red", "Indigo","Crimson","Orange Red",
                   "Dark Green","Slate Gray","Imperial Blue","Yellow",
                   "Turquoise","Violet","Medium Blue Slate", "Red",
                   "Dark Orange", "Spring Green", "White Smoke", "Deep Sky Blue",
                   "Khaki", "Pale Turquoise", "Light Pink", "Lavender",
                   "Salmon", "Orange", "Pale Green")
# Default discrete colours (same order as Parts 3 and 4)
ic_pal <- ic_pal[c("Imperial Blue", "Black", "Medium Violet Red",
                   "Indigo", "Crimson", "Orange Red")]

suppressPackageStartupMessages(library(showtext))
suppressPackageStartupMessages(library(ggplot2))

# 1. Register the Imperial Sans Font with R's graphic engine
# Points to the 'fonts' folder you created
font_add(
  family = "Imperial Sans",
  regular = "fonts/ImperialSansText-Regular.ttf",
  bold = "fonts/ImperialSansText-Bold.ttf"
)
showtext_auto() # Tells R to automatically use showtext for rendering text

# 2. Update the default ggplot2 theme globally to use your font
theme_set(
  theme_minimal(base_family = "Imperial Sans", base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", colour = "#003366", size = 14),
    plot.subtitle = element_text(colour = "#161a1d", size = 11),
    axis.title = element_text(face = "bold", colour = "#161a1d"),
    legend.title = element_text(face = "bold")
  )
)
# Set global options for ggplot2
options(
  ggplot2.discrete.fill = list(unname(ic_pal)),
  ggplot2.discrete.colour = list(unname(ic_pal))
)
