using Test, DIMESampler, Distributions, Random, LinearAlgebra

Random.seed!(1)

# define distribution
m = 2
cov_scale = 0.05
weight = 0.33
ndim = 35

LogProb = CreateDIMETestFunc(ndim, weight, m, cov_scale)
LogProbParallel(x) = pmap(LogProb, eachslice(x, dims=2))

# for chain
niter = 2000
nchain = ndim*5

initmean = zeros(ndim)
initcov = I(ndim)*sqrt(2)
initchain = rand(MvNormal(initmean, initcov), nchain)

chain = RunDIME(LogProb, initchain, niter, progress=true)

sample = chain[1,:,end-Int(niter/4):end][:]

@test isapprox(median(sample), 0.8634433340817228)
