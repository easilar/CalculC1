cp trilinear-RW/vvh-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py

rm -r hz_MC
rm -r hz_ME

./bin/mg5_aMC < proc_hz_mc


sed -i -e 's/10000 = nevents /500000 = nevents /' hz_MC/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' hz_MC/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' hz_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' hz_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' hz_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/108.0938   = muR_ref_fixed/' hz_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/108.0938   = muF_ref_fixed/' hz_MC/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' hz_MC/Cards/run_card.dat
#sed -i -e 's/10.0  = ptj/20.0 = ptj/' hz_MC/Cards/run_card.dat
#sed -i -e 's/-1.0  = etaj/5.0  = etaj/' hz_MC/Cards/run_card.dat

#Pt cut for with bins. Mind the bins!

# Mind the folder paths!

sed -i '77a\c Pt cut for H' hz_MC/SubProcesses/cuts.f
sed -i '78a\ ' hz_MC/SubProcesses/cuts.f
sed -i '79a\       do i=1,nexternal' hz_MC/SubProcesses/cuts.f
sed -i '80a\         if(istatus(i).eq.1 .and. ipdg(i).eq.25) then' hz_MC/SubProcesses/cuts.f
sed -i '81a\           if(pt_04(p(0,i)).lt.0 .or. pt_04(p(0,i)).gt.75) then' hz_MC/SubProcesses/cuts.f
sed -i '82a\             passcuts_user=.false.' hz_MC/SubProcesses/cuts.f
sed -i '83a\           endif' hz_MC/SubProcesses/cuts.f
sed -i '84a\         endif' hz_MC/SubProcesses/cuts.f
sed -i '85a\       enddo' hz_MC/SubProcesses/cuts.f
sed -i '86a\' hz_MC/SubProcesses/cuts.f


./gevirt.sh hz_MC/

echo import model hhh-model-new > proc_hz_me
cat proc_ml >> proc_hz_me
echo output hz_ME >> proc_hz_me
echo collier noinstall >> proc_hz_me
echo quit >> proc_hz_me


./bin/mg5_aMC < proc_hz_me

cd hz_ME/SubProcesses/
cp ../../trilinear-RW/makefile .
cp ../../trilinear-RW/check_OLP.f .
cp ../../check_olp.inc .
cp P0_uux_hz/pmass.inc .
cp P0_uux_hz/nsqso_born.inc .
cp P0_uux_hz/nsquaredSO.inc .


cp ../../hz_MC/SubProcesses/c_weight.inc .
cp ../../hz_MC/SubProcesses/P0_uux_hz/nexternal.inc .

cd ../lib/
cp ../../HHH-libs/libpdf.a .
cp -r ../../HHH-libs/Pdfdata .
cp ../../HHH-libs/libLHAPDF.a .
cp -r ../../HHH-libs/PDFsets .


cd ../SubProcesses/

make OLP_static
make check_OLP

cd ../../
cd hz_MC/

echo order=LO > genEv_hz_mc
echo shower=OFF >> genEv_hz_mc

./bin/generate_events < genEv_hz_mc


gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../hz_ME/SubProcesses/

cd ../hz_ME/SubProcesses/
./check_OLP



