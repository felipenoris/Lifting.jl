
module Lifting

export lift#, unlift

@assert VERSION >= v"0.7.0" "Lifting.jl requires Julia v0.7.0 or newer."

#
# Internal Helper Methods
#

# T is a union with T.a Missing or Nothing.
function is_lhs_liftable_union(::Type{T}) where {T}
    T.a <: Union{Missing, Nothing}
end

function is_rhs_liftable_union(::Type{T}) where {T}
    T.b <: Union{Missing, Nothing}
end

function is_lhs_union(::Type{T}) where {T}
    isa(T.a, Union)
end

function is_rhs_union(::Type{T}) where {T}
    isa(T.b, Union)
end

# finds in a union tree if there is any type Missing or Nothing
function is_liftable_union(::Type{T}) where {T}
    if isa(T, Union)
        if is_lhs_liftable_union(T) || is_rhs_liftable_union(T)
            return true
        else
            if is_lhs_union(T) && is_rhs_union(T)
                return is_liftable_union(T.a) || is_liftable_union(T.b)
            elseif is_lhs_union(T)
                return is_liftable_union(T.a)
            elseif is_rhs_union(T)
                return is_liftable_union(T.b)
            else
                # both sides are not Union types
                return false
            end
        end

    else
        # not a union
        return false
    end
end

@generated function lift(::Type{T}) where {T}
    if is_liftable_union(T)
        if is_lhs_liftable_union(T)
            return lift(T.b)
        elseif is_rhs_liftable_union(T)
                return lift(T.a)
        else
            result = Union{lift(T.a), lift(T.b)}
            if is_liftable_union(result)
                return lift(result)
            else
                return result
            end
        end
    else
        @assert !(T <: Union{Missing, Nothing}) "Can't lift data type $T."
        return T
    end
end

# lift values
lift(x::Missing) = error("Cannot lift a value of type Missing.")
lift(x::Nothing) = error("Cannot lift a value of type Nothing.")
lift(x) = x

# lift vectors

#function lift(x::T) where {T<:Nullable}
#    @assert !isnull(x) "Cannot lift a null value."
#    return get(x)
#end

#lift(x) = x

# unlift types
#unlift(::Type{T}) where {T<:Nullable} = T
#unlift(::Type{T}) where {T} = Nullable{T}

# unlift values
#unlift(x::T) where {T<:Nullable} = x
#unlift(x::T) where {T} = Nullable{T}(x)

# NullableArrays

#using NullableArrays

#lift(::Type{NullableArray{P,Q}}) where {P,Q} = Array{P,Q}
#unlift(::Type{Array{P,Q}}) where {P,Q} = NullableArray{P,Q}

#function lift(x::NullableVector{T}) where {T}
#    LEN = length(x)
#    out = Vector{T}(LEN)
#    for i in 1:LEN
#        @assert !isnull(x[i]) "Cannot lift a null value."
#        out[i] = get(x[i])
#    end
#    return out
#end

#unlift(x::Vector{T}) where {T} = NullableArray(x)

end # module
