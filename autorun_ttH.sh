cp trilinear-RW/tth-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py

rm -r ttH_MC
rm -r ttH_ME

./bin/mg5_aMC < proc_ttH_mc

sed -i -e 's/10000 = nevents /500000 = nevents /' ttH_MC/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' ttH_MC/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' ttH_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' ttH_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' ttH_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/108.0938   = muR_ref_fixed/' ttH_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/108.0938   = muF_ref_fixed/' ttH_MC/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' ttH_MC/Cards/run_card.dat
#sed -i -e 's/10.0  = ptj/20.0 = ptj/' ttH_MC/Cards/run_card.dat
#sed -i -e 's/-1.0  = etaj/5.0  = etaj/' ttH_MC/Cards/run_card.dat

  
#Pt cut for H. Mind the bins!

#sed -i '77a\c Pt cut for H' ttH_MC/SubProcesses/cuts.f
#sed -i '78a\ ' ttH_MC/SubProcesses/cuts.f
#sed -i '79a\       do i=1,nexternal' ttH_MC/SubProcesses/cuts.f
#sed -i '80a\         if(istatus(i).eq.1 .and. ipdg(i).eq.25) then' ttH_MC/SubProcesses/cuts.f
#sed -i '81a\           if(pt_04(p(0,i)).gt.0 .and. pt_04(p(0,i)).lt.350) then' ttH_MC/SubProcesses/cuts.f
#sed -i '82a\             passcuts_user=.false.' ttH_MC/SubProcesses/cuts.f
#sed -i '83a\           endif' ttH_MC/SubProcesses/cuts.f
#sed -i '84a\         endif' ttH_MC/SubProcesses/cuts.f
#sed -i '85a\       enddo' ttH_MC/SubProcesses/cuts.f
#sed -i '86a\' ttH_MC/SubProcesses/cuts.f

./gevirt.sh ttH_MC/

echo import model hhh-model-new > proc_ttH_me
cat proc_ml >> proc_ttH_me
echo output ttH_ME >> proc_ttH_me
echo collier noinstall >> proc_ttH_me
echo quit >> proc_ttH_me


./bin/mg5_aMC < proc_ttH_me

cd ttH_ME/SubProcesses/
cp ../../trilinear-RW/makefile .
cp ../../trilinear-RW/check_OLP.f .
cp ../../check_olp.inc .
cp P0_gg_httx/pmass.inc .
cp P0_gg_httx/nsqso_born.inc .
cp P0_gg_httx/nsquaredSO.inc .


cp ../../ttH_MC/SubProcesses/c_weight.inc .
cp ../../ttH_MC/SubProcesses/P0_gg_httx/nexternal.inc .

cd ../lib/
cp ../../HHH-libs/libpdf.a .
cp -r ../../HHH-libs/Pdfdata .
cp ../../HHH-libs/libLHAPDF.a .
cp -r ../../HHH-libs/PDFsets .


cd ../SubProcesses/

make OLP_static
make check_OLP

cd ../../
cd ttH_MC/

echo order=LO > genEv_ttH_mc
echo shower=OFF >> genEv_ttH_mc

./bin/generate_events < genEv_ttH_mc


gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../ttH_ME/SubProcesses/

cd ../ttH_ME/SubProcesses/
./check_OLP


