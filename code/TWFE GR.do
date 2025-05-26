* Grafik için veriyi ayrı koru
preserve
use "/Users/berkenarslan/Library/CloudStorage/OneDrive-Personal/MASTER/applied micro/Applied micro project/TWEF regression findings.dta", clear
collapse (mean) employed, by(year treat)

twoway ///
    (line employed year if treat==1, lcolor(red) lpattern(solid)) ///
    (line employed year if treat==0, lcolor(blue) lpattern(dash)), ///
    legend(label(1 "Treated group (CA)") label(2 "Control group")) ///
    title("Employment Rate Over Time") ///
    ytitle("Employment Rate") xtitle("Year")

graph export "twfe_employment_trends.png", width(1000) replace
restore
* Return to original data to get treat_post
use "/Users/berkenarslan/Downloads/cps_00001.dta", clear

* Re-generate needed variables
keep if sex == 2
gen mother = (nchild > 0)
keep if mother == 1
gen infant = (yngch <= 1)
gen california = (statefip == 6)
gen post = (year >= 2004)
gen treat = (california == 1 & infant == 1)
gen treat_post = (treat == 1 & post == 1)
decode empstat, gen(empstat_str)
gen employed = (empstat_str == "at work")

* Histogram for employment status in treated group post-2004
histogram employed if treat_post == 1, discrete ///
    barwidth(0.5) ///
    xlabel(0 "Unemployed" 1 "Employed") ///
    title("Employment Status: Treated Group (Post-2004)") ///
    ytitle("Number of Observations")

* Export histogram
graph export "hist_employed_treated.png", width(1000) replace
