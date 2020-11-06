./bin/mg5_aMC < proc_tHj_mc

sed -i -e 's/10000 = nevents /800000 = nevents /' tHj_MC/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' tHj_MC/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' tHj_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' tHj_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' tHj_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/108.0938   = muR_ref_fixed/' tHj_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/108.0938   = muF_ref_fixed/' tHj_MC/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' tHj_MC/Cards/run_card.dat
sed -i -e 's/10.0  = ptj/20.0 = ptj/' tHj_MC/Cards/run_card.dat
sed -i -e 's/-1.0  = etaj/5.0  = etaj/' tHj_MC/Cards/run_card.dat

./gevirt.sh tHj_MC/

echo import model hhh-model-new > proc_tHj_me
cat proc_ml >> proc_tHj_me
echo output tHj_ME >> proc_tHj_me
echo collier noinstall >> proc_tHj_me
echo quit >> proc_tHj_me


./bin/mg5_aMC < proc_tHj_me

cd tHj_ME/SubProcesses/
cp ../../trilinear-RW/makefile .
cp ../../trilinear-RW/check_OLP.f .
cp ../../check_olp.inc .
cp P0_udx_htbx/pmass.inc .
cp P0_udx_htbx/nsqso_born.inc .
cp P0_udx_htbx/nsquaredSO.inc .


cp ../../tHj_MC/SubProcesses/c_weight.inc .
cp ../../tHj_MC/SubProcesses/P0_udx_htbx/nexternal.inc .

cd ../lib/
cp ../../HHH-libs/libpdf.a .
cp -r ../../HHH-libs/Pdfdata .
cp ../../HHH-libs/libLHAPDF.a .
cp -r ../../HHH-libs/PDFsets .


cd ../SubProcesses/

make OLP_static
make check_OLP

cd ../../
cd tHj_MC/

echo order=LO > genEv_tHj_mc
echo shower=OFF >> genEv_tHj_mc

./bin/generate_events < genEv_tHj_mc


gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../tHj_ME/SubProcesses/

cd ../tHj_ME/SubProcesses/
./check_OLP



