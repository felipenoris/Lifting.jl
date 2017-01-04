
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
