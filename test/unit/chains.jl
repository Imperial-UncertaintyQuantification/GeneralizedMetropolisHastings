c0 = chain(:standard,1,10,Float64,Float64)
c1 = chain(:standard,3,4,Int16,Float64)
c2 = chain(:gradient,2,3,Float32,Float32)
@test numparas(c0) == 1 && numsamples(c0) == 10
@test numparas(c1) == 3 && numsamples(c1) == 4
@test numparas(c2) == 2 && numsamples(c2) == 3

s0 = samples(:base,1,4,Float64,Float64)
s1 = samples(:base,3,2,Int16,Float64)
s2 = samples(:tensor,2,2,Float32,Float32)

#test that you can't add a base sample to a gradient chain
@test_throws MethodError store!(c2,s0,1)

#test that the number of parameters is the same for sample and chain
@test_throws AssertionError store!(c0,s1,1)
@test_throws AssertionError store!(c1,s0,1)

copy!(s0.values,1.0:4.0)
store!(c0,s0,4)
store!(c0,s0,3)
store!(c0,s0,2)
@test c0.values[:,1:3] == s0.values[:,4:-1:2]
@test isequal(c0.loglikelihood[1:3],s0.loglikelihood[4:-1:2])

copy!(s1.values,[1.0 4.0;2.0 5.0;3.0 6.0])
store!(c1,s1,2)
store!(c1,s1,1)
store!(c1,s1,2)
store!(c1,s1,2)
@test c1.values == [4.0 1.0 4.0 4.0;5.0 2.0 5.0 5.0;6.0 3.0 6.0 6.0]
@test isequal(c1.loglikelihood,s1.loglikelihood[[2,1,2,2]])

copy!(s2.values,[1.0 3.0;2.0 4.0])
store!(c2,s2,1)
store!(c2,s2,1)
store!(c2,s2,2)
@test c2.values == [1.0 1.0 3.0;2.0 2.0 4.0]
@test isequal(c2.loglikelihood,s2.loglikelihood[[1,1,2]])
@test isequal(c2.gradloglikelihood,s2.gradloglikelihood[:,[1,1,2]])

#these should give warnings that the chain is full
println("Two warnings should be printed below this line")
store!(c1,s1,1)
store!(c2,s2,1)

@test c0.proposed == 3 && accepted!(c0,IndicatorStationary{Float64}(zeros(3),[1,4,3,2])) == 3
@test c1.proposed == 4 && accepted!(c1,IndicatorStationary{Float32}(zeros(Float32,4),[1,2,1,2,2])) == 3
@test c2.proposed == 3 && accepted!(c2,IndicatorStationary{Float64}(zeros(3),[1,1,1,2])) == 1

immutable ChainTestModel <: AbstractModel
    parameters
end

p0 = parameters([0.0],[2.0])
p1 = parameters([0.0,1.0,2.0],[10.0,5.0,3.0])
p2 = parameters([2.0,2.0],[10.0,10.0])
m0 = ChainTestModel(p0)
m1 = ChainTestModel(p1)
m2 = ChainTestModel(p2)

@test_approx_eq logprior(c0,m0) logprior(p0,c0.values,Float64)
@test_approx_eq logprior(c1,m1) logprior(p1,c1.values,Float64)
@test_approx_eq logprior(c2,m2) logprior(p2,c2.values,Float64)

@test_approx_eq logposterior(c0,m0) loglikelihood(c0) + logprior(c0,m0)
@test_approx_eq logposterior(c1,m1) loglikelihood(c1) + logprior(c1,m1)
@test_approx_eq logposterior(c2,m2) loglikelihood(c2) + logprior(c2,m2)


###Test show()
println()
println("====================")
println("Test show() function")
show(c0)
show(c1)
show(c2)
println("End  show() function")
println("====================")
println()
nothing
