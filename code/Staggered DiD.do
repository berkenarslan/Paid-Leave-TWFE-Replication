
*---------------------------------------*
* xthdidregress - staggered DiD do file *
*---------------------------------------*

clear all
set more off

* 1. Veriyi yükle
use "/Users/berkenarslan/Downloads/cps_00001.dta", clear

* 2. Sadece kadınlar
keep if sex == 2

* 3. Annesi olanlar
keep if nchild > 0

* 4. En küçük çocuk <= 1 olanlar
gen infant = (yngch <= 1)

* 5. California dummy
gen california = (statefip == 6)

* 6. Tedavi cohort'u: CA'de infant'ı olanlar
gen cohort = .
replace cohort = 2004 if california == 1 & infant == 1

* 7. Tedavi dummy'si (zamanla aktifleşen)
gen treated = (year >= cohort) & cohort < .

* 8. İstihdam: binary outcome
decode empstat, gen(empstat_str)
gen employed = (empstat_str == "at work")

* 9. ID yarat ve panel tanımla
gen id = _n
xtset id year

xthdidregress ra (employed) (treated), group(cohort) time(year)

* 11. Event study plot (grafik)
estat event, window(-5 5)
