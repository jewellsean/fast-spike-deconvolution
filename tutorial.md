---
title: "FastLZeroSpikeInference Tutorial"
author: "Sean Jewell"
date: '2018-12-07'
output: html_document
layout: default
---



R tutorial
----

In this tutorial, we demonstrate how the ```FastLZeroSpikeInference``` package can be used to deconvolve calcium imaging data from a single neuron. All demos require the ```FastLZeroSpikeInference``` package; installation instructions are provided [here](software.html). 

To illustrate the software, we generate a synthetic dataset according to 

$$
y_t = c_t + \epsilon_t, \\
c_t = \gamma c_{t-1} + z_t, \\
z_t \sim \mathrm{Pois}(\theta), \\
$$

where $\epsilon_t \sim \mathrm{N}(0, \sigma^2)$ and  $c_1 = 1$. The function ```simulate_ar1``` generates data from this model. 


{% highlight r %}
sim <- simulate_ar1(n = 10000, gam = 0.95, poisMean = 0.01, sd = 0.15, seed = 1)
plot(sim)
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/figure/source/tutorial/unnamed-chunk-1-1.png)


The ```estimate_spikes``` function estimates spikes based on the calcium trace, exponential decay parameter $\gamma$, and a tuning parameter $\lambda$. This function solves* 

$$
\underset{c_1,\ldots,c_T, z_2,\ldots,z_T}{\mathrm{minimize}}  
\frac{1}{2} \sum_{t=1}^T \left( y_t -  c_t \right)^2 + \lambda \sum_{t=2}^T 1_{\left( z_t \neq 0 \right) } 
$$

if the ```constraint``` parameter is set to false (default), and 

$$
\underset{c_1,\ldots,c_T, z_2,\ldots,z_T}{\mathrm{minimize}}  
\frac{1}{2} \sum_{t=1}^T \left( y_t -  c_t \right)^2 + \lambda \sum_{t=2}^T 1_{\left( z_t \neq 0 \right) }
\mbox{ subject to } z_t = c_t - \gamma c_{t-1} \geq 0,
$$

if the ```constraint``` parameter is set to true. Here's an example of the function applied to the previously generated data. 



{% highlight r %}
# AR(1) model
fit <- estimate_spikes(dat = sim$fl, gam = 0.95, lambda = 1)
print(fit)
{% endhighlight %}



{% highlight text %}
## 
##  Call: 
## estimate_spikes(dat = sim$fl, gam = 0.95, lambda = 1)
## 
##  Output: 
## Number of spikes 	 89 
## 
##  Settings: 
## Data length 		 10000 
## Model type 		 ar1 
## Gamma 			 0.95 
## Lambda 			 1
{% endhighlight %}

By default, and to save computation time, the calcium concentration is not automatically estimated. However, the ```estimate_calcium``` function can be used to estimate the calcium concentration based on a prior fit. 


{% highlight r %}
# compute fitted values from prev. fit
fit <- estimate_calcium(fit)
plot(fit)
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/figure/source/tutorial/unnamed-chunk-3-1.png)

Alternatively, both spikes and calcium concentrations can be computed with the ```estimate_spikes``` function with ```estimate_calcium``` parameter set to true. 


{% highlight r %}
fit <- estimate_spikes(dat = sim$fl, gam = 0.95, lambda = 1, estimate_calcium = T)
plot(fit)
{% endhighlight %}

![plot of chunk unnamed-chunk-4](/figure/source/tutorial/unnamed-chunk-4-1.png)

To solve the constrained problem 

$$
\underset{c_1,\ldots,c_T, z_2,\ldots,z_T}{\mathrm{minimize}}  
\frac{1}{2} \sum_{t=1}^T \left( y_t -  c_t \right)^2 + \lambda \sum_{t=2}^T 1_{\left( z_t \neq 0 \right) }
\mbox{ subject to } z_t = c_t - \gamma c_{t-1} \geq 0,
$$

we set the ```constraint``` parameter to true in the ```estimate_spikes``` function. Consider the following example.


{% highlight r %}
# Constrained AR(1) model
fit <- estimate_spikes(dat = sim$fl, gam = 0.95, lambda = 1, constraint = T, estimate_calcium = T)
print(fit)
{% endhighlight %}



{% highlight text %}
## 
##  Call: 
## estimate_spikes(dat = sim$fl, gam = 0.95, lambda = 1, constraint = T, 
##     estimate_calcium = T)
## 
##  Output: 
## Number of spikes 	 89 
## 
##  Settings: 
## Data length 		 10000 
## Model type 		 ar1-pos-constrained 
## Gamma 			 0.95 
## Lambda 			 1
{% endhighlight %}



{% highlight r %}
plot(fit)
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/figure/source/tutorial/unnamed-chunk-5-1.png)


* In practice, we solve a modification of our algorithm that removes potential numerical instabilities by imposing a minimum calcium concentration constraint. Namely, we require that the calcium concentration never decays below some small $\epsilon>0$, i.e. $c_{t} = \max(\gamma c_{t-1}, \epsilon) + z_{t}$. This results in slightly different optimization problems. For small $\epsilon$, the difference between the old and new formulation is negligible (the objective function differ only when, under the old formulation, $c_{t} < \epsilon$, and at such timesteps the difference is bounded by $2y_{t}\epsilon + \frac12 \epsilon^{2}$.) Details are in Appendix S3.1 of the Supplementary Materials of {% cite jewell2018fast %}. 


References 
----

{% bibliography --cited %}


