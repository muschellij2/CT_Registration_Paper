rm(list=ls())
library(ggplot2)
library(xtable)
library(gridExtra) 

check.na = function(x){
  stopifnot(all(!is.na(x))) 
}
imag = read.csv("Imaging_Information.csv")
imag$patientName = imag$id
imag$id = NULL
demog = read.csv("Demog_NIHSS_Mask.csv")
demog = merge(demog, imag, all=TRUE)
N = nrow(demog)
check.na(demog$Sex)
sum.fem = sum(demog$Sex == "Female")
pct.fem = round(mean(demog$Sex == "Female")*100, 1)
check.na(demog$Age)
r.age = range(demog$Age)

# hist(demog$Age, breaks=seq(30, 80, by=5))
##############################################
### get the N for the cetner and each trial
demog$study = c("MISTIE", "ICES")[(demog$patientName %% 1000 > 500)+1]
n.mistie = sum(demog$study == "MISTIE")
n.ices = sum(demog$study == "ICES")
demog$ctr = floor(demog$patientName/ 1000)
n.ctr = length(unique(demog$ctr))
##############################################

##############################################
### variable slice thickness and gantry tilt correction
check.na(demog$nslices)

n.var.slice = sum(demog$nslices > 1)
check.na(demog$tilt)
n.gant = sum(demog$tilt != 0)
##############################################

##############################################
# get range for NIHSS
no.nihss = sum(is.na(demog$Enrollment_NIHSS_Total))
r.nihss = range(demog$Enrollment_NIHSS_Total, na.rm=TRUE)
##############################################

##############################################
# get range for GCS
no.gcs = sum(is.na(demog$Enrollment_GCS_Add))
r.gcs = range(demog$Enrollment_GCS_Add, na.rm=TRUE)
##############################################

##############################################
### get the types of scanners
check.na(demog$man)
man.tab = sort(table(demog$man), decreasing=TRUE)
stopifnot(length(man.tab) == 4)
manu= names(man.tab)
manu[manu == 'TOSHIBA'] = "Toshiba"
manu[manu == 'SIEMENS'] = "Siemens"
##############################################

##############################################
# Functions for demographic table
##############################################
mean.sd = function(x, na.rm=FALSE, digits=1){
  mn = round(mean(x, na.rm=na.rm), digits)
  sd = round(sd(x, na.rm=na.rm), digits)
  fmt = paste0("%.", digits, "f")
  mn = sprintf(fmt, mn)
  sd = sprintf(fmt, sd)
  paste0(mn, " (", sd, ")")
}

n.pct = function(x, values=NULL, digits=1){
  check.na(x)
  tab = sort(table(x), decreasing=TRUE)
  ptab = round(prop.table(tab)*100, digits)
  tab = paste0(tab, " (", ptab, "%)")
  names(tab) = names(ptab)
  if (!is.null(values)) {
    tab = tab[values]
    names(tab) = NULL
  } else {
    names(tab) = paste("\\text{  }", names(tab))
    tab = c("", tab)
  }
  tab
}

sfunc <- function(x){
  x <- gsub("%", "\\%", x, fixed=TRUE)
  x <- gsub("ZZZ", "\\;\\;", x, fixed=TRUE)
  x <- gsub("<=", "$\\leq$", x, fixed=TRUE)
  x <- gsub(">=", "$\\geq$", x, fixed=TRUE)
  x <- gsub("<", "$<$", x, fixed=TRUE)
  x <- gsub(">", "$>$", x, fixed=TRUE)
}

##############################################
# Demographic Table
colname = "N (%) or Mean (SD)"
vec= c("Age in Years: Mean (SD)" = mean.sd(demog$Age),
       "Gender: Female" = n.pct(demog$Sex, "Female"),
       "NIHSS: Mean (SD)" = mean.sd(demog$Enrollment_NIHSS_Total, na.rm=TRUE), 
       "GCS: Mean (SD)" = mean.sd(demog$Enrollment_GCS_Add, na.rm=TRUE))
race = n.pct(demog$Ethnicity)
names(race)[1] = "Race"
vec = c(vec, race)

df = data.frame(vec, stringsAsFactors=FALSE)
colnames(df) = colname

xtab = xtable(df, 
              caption= paste0("Descriptive statistics of the demographic",
                              " information on the patients."), align=c("lc"),
              label="t:dem")
print.xtable(xtab, file="demographics.tex", sanitize.rownames.function=sfunc)
##############################################



##############################################
# plots of breakdowns of demographics
gsex = ggplot(demog, aes(Sex)) + geom_histogram() + ylab("Frequency") + 
  ggtitle("Distribution of Sex")
ggcs = ggplot(demog, aes(Enrollment_GCS_Add)) + geom_histogram() + ylab("Frequency") + xlab("GCS Score") +
  ggtitle("Distribution of GCS Score")
gage = ggplot(demog, aes(Age)) + geom_histogram() + ylab("Frequency") +
  ggtitle("Distribution of Age") + xlab("Age (Years)")
gich = ggplot(demog, aes(Diagnostic_ICH)) + geom_histogram() + 
  ylab("Frequency") +
  ggtitle("Distribution of ICH Volume") + 
  xlab("Baseline ICH Volume (cc)")
gnihss = ggplot(demog, aes(Enrollment_NIHSS_Total)) + geom_histogram() + 
  ylab("Frequency") +
  ggtitle("Distribution of NIHSS Score") + 
  xlab("NIHSS Score")
pdf("histdem.pdf", width=6, height=4.5)
grid.arrange(ggcs, gage, gich, gnihss, ncol=2)
dev.off()
##############################################


