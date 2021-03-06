

export Curve

"""
`Curve` Represents a domain defined by the image of a Fun
"""


immutable IntervalCurve{S<:Space,T} <: IntervalDomain{T}
    curve::Fun{S,T}
end

immutable PeriodicCurve{S<:Space,T} <: PeriodicDomain{T}
    curve::Fun{S,T}
end

typealias Curve{S,T} Union{IntervalCurve{S,T},PeriodicCurve{S,T}}


==(a::Curve,b::Curve)=a.curve==b.curve

for TYP in (:IntervalCurve,:PeriodicCurve)
    @eval points(c::$TYP,n::Integer)=c.curve(points(domain(c.curve),n))
end

checkpoints(d::Curve)=fromcanonical(d,checkpoints(domain(d.curve)))

for op in (:(Base.first),:(Base.last),:(Base.rand))
    @eval $op(c::Curve)=c.curve($op(domain(c.curve)))
end


canonicaldomain(c::Curve)=domain(c.curve)


fromcanonical(c::Curve,x)=c.curve(x)
function tocanonical(c::Curve,x)
    rts=roots(c.curve-x)
    @assert length(rts)==1
    first(rts)
end


fromcanonicalD(c::Curve,x)=differentiate(c.curve)(x)


Base.in(x,d::Curve)=in(tocanonical(d,x),canonicaldomain(d))
