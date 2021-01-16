./bin/mg5_aMC < proc_vbf_mc

sed -i -e 's/10000 = nevents /10000 = nevents /' vbf_MC/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' vbf_MC/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' vbf_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' vbf_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' vbf_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/108.0938   = muR_ref_fixed/' vbf_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/108.0938   = muF_ref_fixed/' vbf_MC/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' vbf_MC/Cards/run_card.dat
sed -i -e 's/10.0  = ptj/20.0 = ptj/' vbf_MC/Cards/run_card.dat
sed -i -e 's/-1.0  = etaj/5.0  = etaj/' vbf_MC/Cards/run_card.dat

./gevirt.sh vbf_MC/

echo import model hhh-model-new > proc_vbf_me
cat proc_ml >> proc_vbf_me
echo output vbf_ME >> proc_vbf_me
echo collier noinstall >> proc_vbf_me
echo quit >> proc_vbf_me


./bin/mg5_aMC < proc_vbf_me

cd vbf_ME/SubProcesses/
cp ../../trilinear-RW/makefile .
cp ../../trilinear-RW/check_OLP.f .
cp ../../check_olp.inc .
cp P0_uu_huu/pmass.inc .
cp P0_uu_huu/nsqso_born.inc .
cp P0_uu_huu/nsquaredSO.inc .


cp ../../vbf_MC/SubProcesses/c_weight.inc .
cp ../../vbf_MC/SubProcesses/P0_uu_huu/nexternal.inc .

cd ../lib/
cp ../../HHH-libs/libpdf.a .
cp -r ../../HHH-libs/Pdfdata .
cp ../../HHH-libs/libLHAPDF.a .
cp -r ../../HHH-libs/PDFsets .


cd ../SubProcesses/

make OLP_static
make check_OLP

cd ../../
cd vbf_MC/

echo order=LO > genEv_vbf_mc
echo shower=OFF >> genEv_vbf_mc

./bin/generate_events < genEv_vbf_mc


gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../vbf_ME/SubProcesses/

cd ../vbf_ME/SubProcesses/
./check_OLP



