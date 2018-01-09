
__precompile__(true)
module Lifting

# lift types
lift(::Type{T}) where {T<:Nullable} = eltype(T)
lift(::Type{T}) where {T} = T

# lift values
function lift(x::T) where {T<:Nullable}
    @assert !isnull(x) "Cannot lift a null value."
    return get(x)
end

lift(x) = x

# unlift types
unlift(::Type{T}) where {T<:Nullable} = T
unlift(::Type{T}) where {T} = Nullable{T}

# unlift values
unlift(x::T) where {T<:Nullable} = x
unlift(x::T) where {T} = Nullable{T}(x)

# NullableArrays

using NullableArrays

lift(::Type{NullableArray{P,Q}}) where {P,Q} = Array{P,Q}
unlift(::Type{Array{P,Q}}) where {P,Q} = NullableArray{P,Q}

function lift(x::NullableVector{T}) where {T}
	const LEN = length(x)
	out = Vector{T}(LEN)
	for i in 1:LEN
		@assert !isnull(x[i]) "Cannot lift a null value."
		out[i] = get(x[i])
	end
	return out
end

unlift(x::Vector{T}) where {T} = NullableArray(x)

export lift, unlift

end # module
