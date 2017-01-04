
__precompile__(true)
module Lifting

# lift types
lift{T<:Nullable}(::Type{T}) = eltype(T)
lift{T}(::Type{T}) = T

# lift values
function lift{T<:Nullable}(x::T)
    @assert !isnull(x) "Cannot lift a null value."
    return get(x)
end

lift(x) = x

# unlift types
unlift{T<:Nullable}(::Type{T}) = T
unlift{T}(::Type{T}) = Nullable{T}

# unlift values
unlift{T<:Nullable}(x::T) = x
unlift{T}(x::T) = Nullable{T}(x)

# NullableArrays

using NullableArrays

lift{P,Q}(::Type{NullableArray{P,Q}}) = Array{P,Q}
unlift{P,Q}(::Type{Array{P,Q}}) = NullableArray{P,Q}

function lift{T}(x::NullableVector{T})
	const LEN = length(x)
	out = Vector{T}(LEN)
	for i in 1:LEN
		@assert !isnull(x[i]) "Cannot lift a null value."
		out[i] = get(x[i])
	end
	return out
end

unlift{T}(x::Vector{T}) = NullableArray(x)

export lift, unlift

end # module
