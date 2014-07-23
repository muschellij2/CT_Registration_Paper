CT_Pipeline_Template_rewrite.pdf: CT_Pipeline_Template_rewrite.Rnw reoriented_Binary_Sum_Image_histogram.pdf Figure4_Proportion.png Regression_Map_heatcol1_t1.png Regression_Map_heatcol2_t1.png Regression_Map_heatcol5_t1.png Regression_Map_heatcol6_t1.png Top_19047_pvalues.png GCS_Top_1000_pvalues.png Regress_ROI_NIHSS_Best_Model.png Regress_ROI_GCS_Best_Model.png native_100-362_20100126_1926_CT_2_CT_ROUTINE.png 100-362_20100126_1926_CT_2_CT_ROUTINE_SS_0.01.png raw_spm_100-362_20100126_1926_CT_2_CT_ROUTINE.png roi_spm_100-362_20100126_1926_CT_2_CT_ROUTINE.png GCS_Regression_Map_heatcol1_t1.png GCS_Regression_Map_heatcol2_t1.png GCS_Regression_Map_heatcol3_t1.png GCS_Regression_Map_heatcol4_t1.png GCS_Regression_Map_heatcol5_t1.png GCS_Regression_Map_heatcol6_t1.png Beta_Table.tex area_breakdown.tex demographics.tex all_measures.tex colbreakdown.tex
	if [ -e CT_Pipeline_Template_rewrite.aux ]; \
	then \
	rm CT_Pipeline_Template_rewrite.aux; \
	fi;
	Rscript -e "library(knitr); knit('CT_Pipeline_Template_rewrite.Rnw')"
	pdflatex CT_Pipeline_Template_rewrite
	bibtex CT_Pipeline_Template_rewrite
	pdflatex CT_Pipeline_Template_rewrite
	pdflatex CT_Pipeline_Template_rewrite
	open CT_Pipeline_Template_rewrite.pdf

# code.tex: bsc-code.tex
#	sed -e '/\(Schunk\|Sinput\)/d' \
#		-e 's/\\\(begin\|end\){Soutput}/~~~~/; s/^> /    /' \
#		 bsc-code.tex | pandoc -w context > code.tex
	
