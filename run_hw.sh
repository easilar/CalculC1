#Start readme in the mg5 directory
#if the process tth
#cp trilinear-RW/tth-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py
#if the process vbf, zh,wh, tHj
cp trilinear-RW/vvh-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py

./bin/mg5_aMC < proc_hw_mc

sed -i -e 's/10000 = nevents /1000 = nevents /' hw_MC/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' hw_MC/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' hw_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' hw_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' hw_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/108.0938   = muR_ref_fixed/' hw_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/108.0938   = muF_ref_fixed/' hw_MC/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' hw_MC/Cards/run_card.dat
#sed -i -e 's/10.0  = ptj/20.0 = ptj/' hw_MC/Cards/run_card.dat
#sed -i -e 's/-1.0  = etaj/5.0  = etaj/' hw_MC/Cards/run_card.dat

./gevirt.sh hw_MC/

echo import model hhh-model-new > proc_hw_me
cat proc_ml >> proc_hw_me
echo output hw_ME >> proc_hw_me
echo collier noinstall >> proc_hw_me
echo quit >> proc_hw_me


./bin/mg5_aMC < proc_hw_me

cd hw_ME/SubProcesses/
cp ../../trilinear-RW/makefile .
cp ../../trilinear-RW/check_OLP.f .
cp ../../check_olp.inc .
cp P0_udx_hwp/pmass.inc .
cp P0_udx_hwp/nsqso_born.inc .
cp P0_udx_hwp/nsquaredSO.inc .


cp ../../hw_MC/SubProcesses/c_weight.inc .
cp ../../hw_MC/SubProcesses/P0_udx_hwp/nexternal.inc .

#this part should be done once
#Add an if condition to check if the files in HHH-libs exist don't do it
cd ../../hw_MC/
echo order=LO > genEv_hw_mc
echo shower=OFF >> genEv_hw_mc
./bin/generate_events < genEv_hw_mc
cd ..
mkdir HHH-libs/
cp hw_MC/lib/libLHAPDF.a HHH-libs/
cp hw_MC/lib/libpdf.a HHH-libs/
cp -r hw_MC/lib/Pdfdata HHH-libs/
cp -r hw_MC/lib/PDFsets HHH-libs/
##### Upto here ###

cd hw_ME/lib/
cp ../../HHH-libs/libpdf.a .
cp -r ../../HHH-libs/Pdfdata .
cp ../../HHH-libs/libLHAPDF.a .
cp -r ../../HHH-libs/PDFsets .

cd ../SubProcesses/

make OLP_static
make check_OLP

cd ../../
cd hw_MC/

#If you don't have Events/run_01_LO directory generate events for hw_MC as well
echo order=LO > genEv_hw_mc
echo shower=OFF >> genEv_hw_mc
./bin/generate_events < genEv_hw_mc
###

gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../hw_ME/SubProcesses/

cd ../hw_ME/SubProcesses/
./check_OLP



