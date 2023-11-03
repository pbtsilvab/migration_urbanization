********************************************************************************
***Do file paper venezuelan migration and urban expansion in Colombia**********
*******************************************************************************


cd "D:\Disco C\Documentos\Pablo Silva\Varios Pablo\Varios 2023\Paper migración\Correcciones-reenvío"

import excel "D:\Disco C\Documentos\Pablo Silva\Varios Pablo\Varios 2023\Paper migración\estadísticas\base_migracion.xlsx", sheet("datos_poblacionales") firstrow

rename (UEF_2019 UEF_2020 UEF_2021 UEF_2018_2021)  (AFEI_2018_2019 AFEI_2019_2020 AFEI_2020_2021 AFEI_2018_2021)
rename (VMF_2019 VMF_2020 VMF_2021 VMF_2018_2021) (VMF_2018_2019 VMF_2019_2020 VMF_2020_2021 VMF_2018_2021)
rename (migrantes_2018 migrantes_2019 migrantes_2020 migrantes_2021) (EnVM_2018 EnVM_2019 EnVM_2020 EnVM_2021)
rename (ln_migrantes_2018 ln_migrantes_2019 ln_migrantes_2020 ln_migrantes_2021) (ln_EnVM_2018 ln_EnVM_2019 ln_EnVM_2020 ln_EnVM_2021)
rename (ipm indice_envejecimiento) (imp mai)

gen city=1 if Categoríaruralidad2023=="Ciudades y aglomeraciones"
replace city=0 if city==.
gen city_agglomeration=1 if (Categoríaruralidad2023=="Ciudades y aglomeraciones" | Categoríaruralidad2023=="Intermedio")
replace city_agglomeration=0 if city_agglomeration==.
destring depto, force replace

****Department dummy
levelsof depto, local(levels) 
foreach l of local levels {
gen Depto_`l'=1 if depto == `l'

replace Depto_`l'=0 if Depto_`l'==.

}
gen mundep= Departamento+"-"+Municipio

**OLS
*2018-2019
reg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 iica_2018 imp mai city indice_cobertura_internet i.depto, r
vif
estat ic
outreg2 using ols.doc, replace  ctitle(AFEI_2018_2019) dec(3) pdec(3)
*2019-2020
reg AFEI_2019_2020 ln_EnVM_2019 VMF_2019_2020 prop_urb_2019 iica_2019 imp mai city indice_cobertura_internet i.depto, r
vif
estat ic
outreg2 using ols.doc, append ctitle(AFEI_2019_2020) dec(3) pdec(3)
*2020-2021
reg AFEI_2020_2021 ln_EnVM_2020 VMF_2020_2021 prop_urb_2020 iica_2020 imp mai city indice_cobertura_internet i.depto, r
vif
estat ic
outreg2 using ols.doc, append ctitle(AFEI_2020_2021) dec(3) pdec(3)
*2018-2021
reg AFEI_2018_2021 ln_EnVM_2018 VMF_2018_2021 prop_urb_2018 iica_2018 imp mai city indice_cobertura_internet i.depto, r
vif
estat ic
outreg2 using ols.doc, append ctitle(AFEI_2018_2021) dec(3) pdec(3)

*SEM
*2018-2019
preserve
drop if ln_EnVM_2018==.
drop if depto==.
spatwmat, name (W) xcoord(x) ycoord (y) band(0 10) standardize eigenval(E)

reg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_97 Depto_99 , r

reg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_94 Depto_95 Depto_99, r

spatdiag, weights(W)

spatreg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_94 Depto_95 Depto_99, weights(W) eigenval(E) model(error)
estat ic
outreg2 using sem_18_19.doc, replace  ctitle(AFEI_2018_2019) dec(3) pdec(3)

*SLM
*2018-2019
spatreg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_94 Depto_95 Depto_99, weights(W) eigenval(E) model(lag)
estat ic
outreg2 using slm_18_19.doc, replace  ctitle(AFEI_2018_2019) dec(3) pdec(3)
*Global Moran
spatgsa AFEI_2018_2019, w(W) moran
*Local moran
spatlsa AFEI_2018_2019, w(W) moran id( mundep ) sort

restore

*SEM
*2019-2020
preserve
drop if ln_EnVM_2019==.
drop if depto==.
spatwmat, name (W) xcoord(x) ycoord (y) band(0 10) standardize eigenval(E)

reg AFEI_2019_2020 ln_EnVM_2019 VMF_2019_2020 prop_urb_2019 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_97 Depto_99, r

reg AFEI_2019_2020 ln_EnVM_2019 VMF_2019_2020 prop_urb_2019 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_99, r

spatdiag, weights(W)

spatreg AFEI_2019_2020 ln_EnVM_2019 VMF_2019_2020 prop_urb_2019 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_99, weights(W) eigenval(E) model(error)
estat ic
outreg2 using sem_19_20.doc, replace  ctitle(AFEI_2019_2020) dec(3) pdec(3)

*SLM
*2019-2020
spatreg AFEI_2019_2020 ln_EnVM_2019 VMF_2019_2020 prop_urb_2019 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_99, weights(W) eigenval(E) model(lag)
estat ic
outreg2 using slm_19_20.doc, replace  ctitle(AFEI_2019_2020) dec(3) pdec(3)
* Global Moran
spatgsa AFEI_2019_2020, w(W) moran
* Local Moran
spatlsa AFEI_2019_2020, w(W) moran id( mundep ) sort

restore

*SEM
*2020-2021
preserve
drop if ln_EnVM_2020==.
drop if depto==.
spatwmat, name (W) xcoord(x) ycoord (y) band(0 10) standardize eigenval(E)

reg AFEI_2020_2021 ln_EnVM_2020 VMF_2020_2021 prop_urb_2020 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_97 Depto_99, r

reg AFEI_2020_2021 ln_EnVM_2020 VMF_2020_2021 prop_urb_2020 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_99, r

spatdiag, weights(W)

spatreg AFEI_2020_2021 ln_EnVM_2020 VMF_2020_2021 prop_urb_2020 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_99, weights(W) eigenval(E) model(error)
estat ic
outreg2 using sem_20_21.doc, replace  ctitle(AFEI_2020_2021) dec(3) pdec(3)

*SLM
*2020-2021
spatreg AFEI_2020_2021 ln_EnVM_2020 VMF_2020_2021 prop_urb_2020 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_99, weights(W) eigenval(E) model(lag)
estat ic
outreg2 using slm_20_21.doc, replace  ctitle(AFEI_2020_2021) dec(3) pdec(3)

* Global Moran
spatgsa AFEI_2020_2021, w(W) moran
*Local Moran
spatlsa AFEI_2020_2021, w(W) moran id( mundep ) sort

restore

*SEM
*2018-2021
preserve
drop if ln_EnVM_2018==.
drop if depto==.
spatwmat, name (W) xcoord(x) ycoord (y) band(0 10) standardize eigenval(E)

reg AFEI_2018_2021 ln_EnVM_2018 VMF_2018_2021 prop_urb_2018 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_88 Depto_91 Depto_94 Depto_95 Depto_97 Depto_99, r

reg AFEI_2018_2021 ln_EnVM_2018 VMF_2018_2021 prop_urb_2018 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_94 Depto_95 Depto_99, r

spatdiag, weights(W)

spatreg AFEI_2018_2021 ln_EnVM_2018 VMF_2018_2021 prop_urb_2018 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_94 Depto_95 Depto_99, weights(W) eigenval(E) model(error)
estat ic
outreg2 using sem_18_21.doc, replace  ctitle(AFEI_2018_2021) dec(3) pdec(3)
 
*SLM
*2018-2021
spatreg AFEI_2018_2021 ln_EnVM_2018 VMF_2018_2021 prop_urb_2018 imp mai city indice_cobertura_internet Depto_5 Depto_8 Depto_11 Depto_13 Depto_15 Depto_17 Depto_18 Depto_19 Depto_20 Depto_23 Depto_25 Depto_27 Depto_41 Depto_44 Depto_47 Depto_50 Depto_52 Depto_54 Depto_63 Depto_66 Depto_68 Depto_70 Depto_73 Depto_76 Depto_81 Depto_85 Depto_86 Depto_94 Depto_95 Depto_99, weights(W) eigenval(E) model(lag)
estat ic
outreg2 using slm_18_21.doc, replace  ctitle(AFEI_2018_2021) dec(3) pdec(3)
* Global Moran
spatgsa AFEI_2018_2021, w(W) moran
* Local Moran
spatlsa AFEI_2018_2021, w(W) moran id( mundep ) sort

restore


**Additional statistical tests

* Frontier points: Maicao, Cúcuta, Villa del Rosario, Puerto Santander, Puerto Inírida, Arauca, Puerto Carreño
generate latitud_maicao=11.3815778353
generate longitud_maicao=-72.2950087352
generate latitud_cucuta=8.11196699155
generate longitud_cucuta=-72.4886399332
generate latitud_villa_del_rosario=7.75718476829
generate longitud_villa_del_rosario=-72.4820279355
generate latitud_puerto_santander=8.32913864226
generate longitud_puerto_santander=-72.4111906552
generate latitud_puerto_inirida=3.31940498489
generate longitud_puerto_inirida=-68.4572365918
generate latitud_arauca=6.79628090567
generate longitud_arauca=-70.509201991
generate latitud_puerto_carreno=5.83653119443
generate longitud_puerto_carreno=-68.1412233283

geodist latitud_maicao longitud_maicao y x, generate(dist_maicao)
geodist latitud_cucuta longitud_cucuta y x, generate(dist_cucuta)
geodist latitud_villa_del_rosario longitud_villa_del_rosario y x, generate(dist_villa_del_rosario)
geodist latitud_puerto_santander longitud_puerto_santander y x, generate(dist_puerto_santander)
geodist latitud_puerto_inirida longitud_puerto_inirida y x, generate(dist_puerto_inirida)
geodist latitud_arauca longitud_arauca y x, generate(dist_arauca)
geodist latitud_puerto_carreno longitud_puerto_carreno y x, generate(dist_puerto_carreno)

egen min_dist = rowmin(dist_maicao dist_cucuta dist_villa_del_rosario dist_puerto_santander dist_puerto_inirida dist_arauca dist_puerto_carreno)

cluster kmeans min_dist, k(3) measure(L2) start(krandom)

* 2018-2019
bys _clus_1: reg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet, r
bys _clus_1: reg AFEI_2019_2020 ln_EnVM_2019 VMF_2019_2020 prop_urb_2019 imp mai city indice_cobertura_internet, r
bys _clus_1: reg AFEI_2020_2021 ln_EnVM_2020 VMF_2020_2021 prop_urb_2020 imp mai city indice_cobertura_internet, r
bys _clus_1: reg AFEI_2018_2021 ln_EnVM_2018 VMF_2018_2021 prop_urb_2018 imp mai city indice_cobertura_internet, r
* Reg by added value
xtile quart = va2018 , nq(4)
bys quart: reg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet, r
bys quart: reg AFEI_2019_2020 ln_EnVM_2019 VMF_2019_2020 prop_urb_2019 imp mai city indice_cobertura_internet, r
bys quart: reg AFEI_2020_2021 ln_EnVM_2020 VMF_2020_2021 prop_urb_2020 imp mai city indice_cobertura_internet, r
bys quart: reg AFEI_2018_2021 ln_EnVM_2018 VMF_2018_2021 prop_urb_2018 imp mai city indice_cobertura_internet, r

*SLM: 2018-2019
preserve
* C1
keep if _clus_1==1
drop if ln_EnVM_2018==.
drop if depto==.
spatwmat, name (W) xcoord(x) ycoord (y) band(0 10) standardize eigenval(E)
reg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet, r
spatdiag, weights(W)
spatreg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet, weights(W) eigenval(E) model(lag)
restore

preserve

* C2
keep if _clus_1==2
drop if ln_EnVM_2018==.
drop if depto==.
spatwmat, name (W) xcoord(x) ycoord (y) band(0 10) standardize eigenval(E)
reg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet, r
spatdiag, weights(W)
spatreg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet, weights(W) eigenval(E) model(lag)

* C3
keep if _clus_1==3
drop if ln_EnVM_2018==.
drop if depto==.
spatwmat, name (W) xcoord(x) ycoord (y) band(0 30) standardize eigenval(E)
reg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet, r
spatdiag, weights(W)
spatreg AFEI_2018_2019 ln_EnVM_2018 VMF_2018_2019 prop_urb_2018 imp mai city indice_cobertura_internet, weights(W) eigenval(E) model(lag)



*************** Correlation at department level with official registers

import excel "D:\Disco C\Documentos\Pablo Silva\Varios Pablo\Varios 2023\Paper migración\Correcciones-reenvío\migration_database.xlsx", sheet("Hoja3") firstrow, clear
pwcorr Migrantes2021 Datosoficiales , sig star(.01)

