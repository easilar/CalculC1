cp trilinear-RW/vvh-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py

rm -r hw_MC
rm -r hw_ME

./bin/mg5_aMC < proc_hw_mc

sed -i -e 's/10000 = nevents /500000 = nevents /' hw_MC/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' hw_MC/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' hw_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' hw_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' hw_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/102.693   = muR_ref_fixed/' hw_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/102.693   = muF_ref_fixed/' hw_MC/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' hw_MC/Cards/run_card.dat
#sed -i -e 's/10.0  = ptj/20.0 = ptj/' hw_MC/Cards/run_card.dat
#sed -i -e 's/-1.0  = etaj/5.0  = etaj/' hw_MC/Cards/run_card.dat

#Pt cut for with bins. Mind the bins!

# Mind the folder paths!

#sed -i '77a\c Pt cut for H' hw_MC/SubProcesses/cuts.f
#sed -i '78a\ ' hw_MC/SubProcesses/cuts.f
#sed -i '79a\       do i=1,nexternal' hw_MC/SubProcesses/cuts.f
#sed -i '80a\         if(istatus(i).eq.1 .and. ipdg(i).eq.25) then' hw_MC/SubProcesses/cuts.f
#sed -i '81a\           if(pt_04(p(0,i)).lt.0 .or. pt_04(p(0,i)).gt.75) then' hw_MC/SubProcesses/cuts.f
#sed -i '82a\             passcuts_user=.false.' hw_MC/SubProcesses/cuts.f
#sed -i '83a\           endif' hw_MC/SubProcesses/cuts.f
#sed -i '84a\         endif' hw_MC/SubProcesses/cuts.f
#sed -i '85a\       enddo' hw_MC/SubProcesses/cuts.f
#sed -i '86a\' hw_MC/SubProcesses/cuts.f

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

cd ../lib/
cp ../../HHH-libs/libpdf.a .
cp -r ../../HHH-libs/Pdfdata .
cp ../../HHH-libs/libLHAPDF.a .
cp -r ../../HHH-libs/PDFsets .


cd ../SubProcesses/

make OLP_static
make check_OLP

cd ../../
cd hw_MC/

echo order=LO > genEv_hw_mc
echo shower=OFF >> genEv_hw_mc

./bin/generate_events < genEv_hw_mc


gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../hw_ME/SubProcesses/

cd ../hw_ME/SubProcesses/
./check_OLP



