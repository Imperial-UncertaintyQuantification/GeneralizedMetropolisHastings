### Model to estimate distribution from
abstract MCModel

### Sampler types hold the components that fully specify a Monte Carlo sampler
abstract MCSampler

### Runner types indicate what type of simulation will be run (ex the Generalized MH way)
### Their fields fully specify the simulation details (ex total number or number of burn-in iterations)
abstract MCRunner

### Variable to hold the results of the simulation
abstract MCChain

### Tuner types
abstract MCTuner

### Types of the proposal distribution (e.g., Normal, Spline etc)
abstract ProposalDensity

###Derivative order of the sample
abstract DerivativeOrder
type NullOrder <: DerivativeOrder end
type FirstOrder <: DerivativeOrder end
type SecondOrder <: DerivativeOrder end

### Monte Carlo sample types hold a single Monte Carlo sample
### A typical Sample includes at least the vector of parameter values and the respective log-likelihood value
abstract MCSample{O<:DerivativeOrder}

### Heap types hold the temporary components used by a Monte Carlo sampler during its run
### This means that heap types represent the internal state ("local variables") of a Monte Carlo sampler
abstract MCHeap{S<:MCSample}

### Tune types hold the temporary output of the sampler that is used for tuning the sampler
abstract MCTune