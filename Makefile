all: move rmd2md

move:
		cp inst/vign/rdpla_vignette.md vignettes;\
		cp inst/vign/use_case_churches.md vignettes;\
		cp -r inst/vign/figure/ vignettes/figure/

rmd2md:
		cd vignettes;\
		mv rdpla_vignette.md rdpla_vignette.Rmd;\
		mv use_case_churches.md use_case_churches.Rmd
