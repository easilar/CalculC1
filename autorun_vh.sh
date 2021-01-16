cp trilinear-RW/vvh-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py

rm -r vh_MC
rm -r vh_ME

./bin/mg5_aMC < proc_vh_mc

sed -i -e 's/10000 = nevents /500000 = nevents /' vh_MC/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' vh_MC/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' vh_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' vh_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' vh_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/108.0938   = muR_ref_fixed/' vh_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/108.0938   = muF_ref_fixed/' vh_MC/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' vh_MC/Cards/run_card.dat
#sed -i -e 's/10.0  = ptj/20.0 = ptj/' vh_MC/Cards/run_card.dat
#sed -i -e 's/-1.0  = etaj/5.0  = etaj/' vh_MC/Cards/run_card.dat

#Pt cut for with bins. Mind the bins!

# Mind the folder paths!

sed -i '77a\c Pt cut for H' vh_MC/SubProcesses/cuts.f
sed -i '78a\ ' vh_MC/SubProcesses/cuts.f
sed -i '79a\       do i=1,nexternal' vh_MC/SubProcesses/cuts.f
sed -i '80a\         if(istatus(i).eq.1 .and. ipdg(i).eq.25) then' vh_MC/SubProcesses/cuts.f
sed -i '81a\           if(pt_04(p(0,i)).gt.0 .and. pt_04(p(0,i)).lt.350) then' vh_MC/SubProcesses/cuts.f
sed -i '82a\             passcuts_user=.false.' vh_MC/SubProcesses/cuts.f
sed -i '83a\           endif' vh_MC/SubProcesses/cuts.f
sed -i '84a\         endif' vh_MC/SubProcesses/cuts.f
sed -i '85a\       enddo' vh_MC/SubProcesses/cuts.f
sed -i '86a\' vh_MC/SubProcesses/cuts.f

./gevirt.sh vh_MC/

echo import model hhh-model-new > proc_vh_me
cat proc_ml >> proc_vh_me
echo output vh_ME >> proc_vh_me
echo collier noinstall >> proc_vh_me
echo quit >> proc_vh_me


./bin/mg5_aMC < proc_vh_me

cd vh_ME/SubProcesses/
cp ../../trilinear-RW/makefile .
cp ../../trilinear-RW/check_OLP.f .
cp ../../check_olp.inc .
cp P0_udx_hwp/pmass.inc .
cp P0_udx_hwp/nsqso_born.inc .
cp P0_udx_hwp/nsquaredSO.inc .


cp ../../vh_MC/SubProcesses/c_weight.inc .
cp ../../vh_MC/SubProcesses/P0_udx_hwp/nexternal.inc .

cd ../lib/
cp ../../HHH-libs/libpdf.a .
cp -r ../../HHH-libs/Pdfdata .
cp ../../HHH-libs/libLHAPDF.a .
cp -r ../../HHH-libs/PDFsets .


cd ../SubProcesses/

make OLP_static
make check_OLP

cd ../../
cd vh_MC/

echo order=LO > genEv_vh_mc
echo shower=OFF >> genEv_vh_mc

./bin/generate_events < genEv_vh_mc


gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../vh_ME/SubProcesses/

cd ../vh_ME/SubProcesses/
./check_OLP



