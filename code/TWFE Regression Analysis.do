log using "/Users/berkenarslan/Library/CloudStorage/OneDrive-Personal/MASTER/applied micro/Applied micro project/twfe_log.smcl", replace
use "/Users/berkenarslan/Downloads/cps_00001.dta"
**Data Cleaning
* 1. Sadece kadınları seç
keep if sex == 2

* 2. Annesi olanları filtrele (çocuğu olanlar)
gen mother = (nchild > 0)
keep if mother == 1

* 3. En küçük çocuğu 0 veya 1 yaşında olanlar → tedavi grubu için infant tanımı
gen infant = (yngch <= 1)

* 4. California dummy'si (FIPS kodu 6)
gen california = (statefip == 6)

* 5. 2004 sonrası dummy
gen post = (year >= 2004)

* 6. Tedavi değişkenleri
gen treat = (california == 1 & infant == 1)
gen treat_post = (treat == 1 & post == 1)

* 7. İstihdam dummy'si → önce decode, sonra karşılaştır
decode empstat, gen(empstat_str)
gen employed = (empstat_str == "at work")

tab treat_post
tab employed
tab employed if treat_post == 1

**TWFE Regression
**labforce == yes filtresiyle sadece işgücüne dahil olanları analiz et


**uhrsworkt > 0 gibi ekstra koşullar ekleyerek alternatif employed tanımı dene


**xtreg ile karşılaştır, fark var 

areg employed treat_post i.year, absorb(statefip) cluster(statefip)
* === Bittiğinde log dosyasını kapat ===
save "/Users/berkenarslan/Library/CloudStorage/OneDrive-Personal/MASTER/applied micro/Applied micro project/TWEF regression findings.dta", replace

log close

