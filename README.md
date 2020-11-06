# CalculC1
## Packages
* [MadGraph v2\_5\_5](https://launchpad.net/mg5amcnlo)
* [LoopTools v2\_13 ](http://www.feynarts.de/looptools/)
* [trilinear coupling package](https://cp3.irmp.ucl.ac.be/projects/madgraph/wiki/HiggsSelfCoupling#no1)
## ReferenceReference Papers
1. [paper](link)
2. [paper](link)
3. [paper](link)
## Preparation for runing
### Create working directory
```
mkdir produce\_c1
cd produce\_c1
```
### Download necessary packages
```
wget https://launchpad.net/mg5amcnlo/2.0/2.5.x/+download/MG5_aMC_v2.5.5.tar.gz
wget http://www.feynarts.de/looptools/LoopTools-2.13.tar.gz
wget https://cp3.irmp.ucl.ac.be/projects/madgraph/raw-attachment/wiki/HiggsSelfCoupling/trilinear-RW.tar.gz
```
### Setup packages
```
tar -xzf MG5_aMC_v2.5.5.tar.gz
cd MG5_aMC_v2_5_5/
```
Check madgraph installation
```
 ./bin/mg5\_aMC
MG5\_aMC> generate p p > t t~
MG5\_aMC> display processes
MG5\_aMC> display diagrams
MG5\_aMC> output testttbar
MG5\_aMC> launch
MG5\_aMC> quit
``` 
