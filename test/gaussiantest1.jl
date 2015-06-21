using GeneralizedMetropolisHastings
using Distributions

# Define settings for simulation
OutputID            = "TestOutputFile"
Sampler             = "MH"
NumOfProposals      = 1
NumOfIterations     = 1000
InitialStepSize     = 0.01
ProposalCovariance  = [1.0]
InitialiseFromPrior = false # Sample starting parameters from prior

############################
# Create a standard model #
############################

# Define the Model object
ModelName    = "Gaussian"
NumOfParas   = 1
ParaNames    = ["a"]
DefaultParas = [0.0]

Prior        = Array(Distribution, NumOfParas)
Prior[1]     = Uniform(0, 10)

# Specify LL function
function LL_Gaussian(x)
    Mean = [0.0]
    Cov  = eye(1)

    logpdf(MvNormal(Mean,Cov),x)
end

GaussModel = TargetOnlyModel( ModelName,
                              NumOfParas,
                              ParaNames,
                              DefaultParas,
                              Prior,
                              LL_Gaussian)

############################
# Create simulation object #
############################

MySimulation = MCMCSimulation( OutputID,
                               Sampler,
                               NumOfProposals,
                               NumOfIterations,
                               InitialStepSize,
                               ProposalCovariance,
                               InitialiseFromPrior,
                               GaussModel )

# Run the MCMC code, passing in the MCMCSimulation object
MCMCRun( MySimulation )
