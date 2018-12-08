---
layout: default
title: Software
---



The ```FastLZeroSpikeInference``` package is publicly available on Github. The C++ implementation of Algorithms 1 and 2 of 
{% cite jewell2018fast %} are accessible through R and python wrappers. These wrappers are available at 
[https://github.com/jewellsean/FastLZeroSpikeInference](https://github.com/jewellsean/FastLZeroSpikeInference/blob/master/README.md).

If you are using the Allen Institute for Brain Science (AIBS) Brain Observatory data, note that the AIBS recently released an update to their software development kit that provides 
users with the output from Algorithm 2 for close to 60,000 neurons during different experimental conditions. 
See [https://allensdk.readthedocs.io/en/latest/](https://allensdk.readthedocs.io/en/latest/) for additional information. 


Installation
----- 

#### R 

In R, make sure that the ```devtools``` package is installed (```install.packages("devtools")```) and then run 
```r
devtools::install_github("jewellsean/FastLZeroSpikeInference").
```
This command installs the latest version of the package from Github. *The package has been submitted to CRAN, though may not yet be available.* 


#### Python

In python, we recommend directly cloning the repository and building using the supplied ```make``` script. Run the following commands 

```bash
git clone "https://github.com/jewellsean/FastLZeroSpikeInference.git"
cd FastLZeroSpikeInference/python
./make.sh
```
to clone the repository, build the package, and install to your local python directory. 



References 
----

{% bibliography --cited %}