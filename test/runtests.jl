
using Lifting, Test

@test_throws AssertionError lift(Nothing)
@test_throws AssertionError lift(Missing)
@test lift(Int64) == Int64
@test lift(AbstractString) == AbstractString
@test lift(Union{Missing, Int64}) == Int64
@test lift(Union{Int64, Missing}) == Int64
@test lift(Union{Nothing, Int64}) == Int64
@test lift(Union{Int64, Nothing}) == Int64
@test lift(Union{Float64, Int64}) == Union{Float64, Int64}
@test lift(Union{Int64, Float64, String}) == Union{Int64, Float64, String}
@test lift(Union{Int64, Float64, Missing, String}) == Union{Int64, Float64, String}
@test lift(Union{Nothing, Int64, Float64, String, Missing}) == Union{String, Int64, Float64}
@test lift(Union{Nothing, Int64, Float64, String, Missing, Nothing}) == Union{String, Int64, Float64}

#=
using Base.Test
using NullableArrays
using Lifting

_a_ = [Int, Nullable{Float64}]
@test lift.(_a_) == [ Int, Float64 ]
@test unlift.(_a_) == [ Nullable{Int}, Nullable{Float64} ]

@test lift(Nullable(1)) == 1
@test lift(Nullable("hello")) == "hello"

@test get(unlift(1) == Nullable(1))
@test get(unlift("hello") == Nullable("hello"))

@test lift(NullableVector{Int}) == Array{Int,1}
@test unlift(Vector{String}) == NullableArray{String, 1}

@test lift(NullableArray([1,2,3])) == [1, 2, 3]

a = unlift([1, 2, 3])
b = NullableArray([1,2,3])

for i in 1:3
	@test get(a[i] == b[i])
end
=#
