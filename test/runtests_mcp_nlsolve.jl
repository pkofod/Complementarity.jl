using Complementarity
using Base.Test


info("-------[Testing Complementarity/NLsolve]------------------------------------------")


@testset "mcp test 1 with NLsolve" begin
    m = nothing
    m = MCPModel()

    M = [0  0 -1 -1 ;
         0  0  1 -2 ;
         1 -1  2 -2 ;
         1  2 -2  4 ]

    q = [2; 2; -2; -6]

    lb = zeros(4)
    ub = Inf*ones(4)

    items = 1:4

    # @variable(m, lb[i] <= x[i in items] <= ub[i])
    @variable(m, x[i in items] >= 0)
    @mapping(m, F[i in items], sum(M[i,j]*x[j] for j in items) + q[i])
    @complementarity(m, F, x)

    status = solveMCP(m, solver=:NLsolve)
    @show status

    z = getvalue(x)
    Fz = getvalue(F)

    @show z
    @show Fz

    @test isapprox(z[1], 2.8, atol=1e-4)
    @test isapprox(z[2], 0.0, atol=1e-4)
    @test isapprox(z[3], 0.8, atol=1e-4)
    @test isapprox(z[4], 1.2, atol=1e-4)
end

println("------------------------------------------------------------------")

@testset "mcp test 2 with NLsolve" begin

    m = nothing
    m = MCPModel()

    M = [0  0 -1 -1 ;
         0  0  1 -2 ;
         1 -1  2 -2 ;
         1  2 -2  4 ]

    q = [2; 2; -2; -6]

    lb = zeros(4)
    ub = Inf*ones(4)

    items = 1:4

    @variable(m, lb[i] <= x[i in items] <= ub[i])
    # @variable(m, x[i in items] >= 0)
    @mapping(m, F[i in items], sum(M[i,j]*x[j] for j in items) + q[i])
    @complementarity(m, F, x)

    status = solveMCP(m, solver=:NLsolve)
    @show status

    z = getvalue(x)
    # Fz = getvalue(F) # currently produces an error

    @show z
    # @show Fz

    @test isapprox(z[1], 2.8, atol=1e-4)
    @test isapprox(z[2], 0.0, atol=1e-4)
    @test isapprox(z[3], 0.8, atol=1e-4)
    @test isapprox(z[4], 1.2, atol=1e-4)
end

println("------------------------------------------------------------------")

@testset "mcp test 3 with NLsolve" begin

    m = nothing
    m = MCPModel()

    M = [0  0 -1 -1 ;
         0  0  1 -2 ;
         1 -1  2 -2 ;
         1  2 -2  4 ]

    q = [2; 2; -2; -6]

    lb = zeros(4)
    ub = Inf*ones(4)

    @variable(m, lb[i] <= myvariablename[i in 1:4] <= ub[i])
    @mapping(m, myconst[i=1:4], sum(M[i,j]*myvariablename[j] for j in 1:4) + q[i])
    @complementarity(m, myconst, myvariablename)

    status = solveMCP(m, solver=:NLsolve)
    @show status

    z = getvalue(myvariablename)
    Fz = getvalue(myconst)

    @show z
    @show Fz

    @test isapprox(z[1], 2.8, atol=1e-4)
    @test isapprox(z[2], 0.0, atol=1e-4)
    @test isapprox(z[3], 0.8, atol=1e-4)
    @test isapprox(z[4], 1.2, atol=1e-4)

end

println("------------------------------------------------------------------")

@testset "mcp test 4 with NLsolve" begin

    m = nothing
    m = MCPModel()

    lb = zeros(4)
    ub = Inf*ones(4)
    items = 1:4
    @variable(m, lb[i] <= x[i in items] <= ub[i])

    @mapping(m, F1, 3*x[1]^2 + 2*x[1]*x[2] + 2*x[2]^2 + x[3] + 3*x[4] -6)
    @mapping(m, F2, 2*x[1]^2 + x[1] + x[2]^2 + 3*x[3] + 2*x[4] -2)
    @mapping(m, F3, 3*x[1]^2 + x[1]*x[2] + 2*x[2]^2 + 2*x[3] + 3*x[4] -1)
    @mapping(m, F4, x[1]^2 + 3*x[2]^2 + 2*x[3] + 3*x[4] - 3)

    @complementarity(m, F1, x[1])
    @complementarity(m, F2, x[2])
    @complementarity(m, F3, x[3])
    @complementarity(m, F4, x[4])

    setvalue(x[1], 1.25)
    setvalue(x[2], 0.)
    setvalue(x[3], 0.)
    setvalue(x[4], 0.5)

    status = solveMCP(m, solver=:NLsolve)
    @show status

    z = getvalue(x)
    Fz = [getvalue(F1), getvalue(F2), getvalue(F3), getvalue(F4)]

    @show z
    @show Fz

    @test isapprox(z[1], 1.22474, atol=1e-4)
    @test isapprox(z[2], 0.0, atol=1e-4)
    @test isapprox(z[3], 0.0, atol=1e-4)
    @test isapprox(z[4], 0.5, atol=1e-4)
end
