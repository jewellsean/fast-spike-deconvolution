---
layout: default
title: Fast deconvolution of calcium imaging data via an L0 penalty
---

# Fast deconvolution of calcium imaging data via an $\ell_0$ penalty 



Overview
----

Recently, new technologies in neuroscience have made it possible to record large numbers of firing neurons simultaneously. 
For each neuron, a fluorescence trace is recorded, and on the basis of the trace, we wish to estimate the exact times 
that the neuron fired. This is a challenging deconvolution problem.   

We assume that the observed fluorescence trace $y_{t}$ is a noisy version of the unobserved calcium concentration $c_{t}$. 
Furthermore, we assume that the calcium concentration decays exponentially, unless there is a spike, in which case 
the calcium concentration increases instantaneously. More precisely,
 
$$
\begin{align*}
y_t &= c_t + \epsilon_t, \quad \epsilon_t \sim_\text{ind.} (0, \sigma^2),  \quad t = 1, \ldots, T; \nonumber\\
c_t &= \gamma c_{t-1} + z_t, \quad t = 2,\ldots, T,
\end{align*}
$$

where $z_t\geq 0$, and where $z_{t} >0$ indicates the presence of a spike at the $t$th timestep. 

Based on this generative model, {% cite jewell2018exact %} proposed solving the $\ell_0$ optimization problem 

$$
\underset{c_1,\ldots,c_T, z_2,\ldots,z_T}{\mathrm{minimize}}  
\frac{1}{2} \sum_{t=1}^T \left( y_t -  c_t \right)^2 + \lambda \sum_{t=2}^T 1_{\left( z_t \neq 0 \right) },
$$

where $\lambda>0$ is a tuning parameter that balances the tradeoff between the total number of spikes, $\sum_{t}z_t$, and 
the goodness-of-fit, $\frac{1}{2} \sum_{t=1}^T \left( y_t -  c_t \right)^2$.  

In {% cite jewell2018fast %}, we develop a **very efficient** algorithm for solving  

$$
\underset{c_1,\ldots,c_T, z_2,\ldots,z_T}{\mathrm{minimize}}  
\frac{1}{2} \sum_{t=1}^T \left( y_t -  c_t \right)^2 + \lambda \sum_{t=2}^T 1_{\left( z_t \neq 0 \right) },
$$

as well as the related problem  

$$
\underset{c_1,\ldots,c_T, z_2,\ldots,z_T}{\mathrm{minimize}}  
\frac{1}{2} \sum_{t=1}^T \left( y_t -  c_t \right)^2 + \lambda \sum_{t=2}^T 1_{\left( z_t \neq 0 \right) }
\mbox{ subject to } z_t = c_t - \gamma c_{t-1} \geq 0,
$$

that ensures a spike results in an increase in the calcium concentration. This website introduces the efficient algorithm 
of {% cite jewell2018fast %}. 

Allen Institute for Brain Science 
----

We also note that the recent paper {% cite deVries2018large %} decodes neural activity for different Allen Institute 
for Brain Science (AIBS) Brain Observatory experiments using 
Algorithm 2 of {% cite jewell2018fast %}; that is, the algorithm presented on this website. 

If you're working with the AIBS data, you may be interested to know that the AIBS also recently released an
update to their software development kit that provides users with the output from Algorithm 2 for close to 60,000 
neurons during different experimental conditions. See [https://allensdk.readthedocs.io/en/latest/](https://allensdk.readthedocs.io/en/latest/)
for additional information. 



References 
----

{% bibliography --cited %}
