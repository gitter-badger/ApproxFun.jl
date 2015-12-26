export Disk,𝔻

# TT is Real or Complex
# T is (Real,Real) or Complex
immutable Disk{orientation,T,TT} <: BivariateDomain{T}
    center::TT
    radius::Float64
end

Base.convert{o}(::Type{Disk{o}},c::Complex,r)=Disk{o,typeof(c),typeof(c)}(c,r)
Base.convert{o,T<:Real}(::Type{Disk{o}},c::Tuple{T,T},r)=Disk{o,T,typeof(c)}(c,r)

Disk(c,r)=Disk{true}(c,r)
Disk()=Disk((0.,0.),1.)
Disk(::AnyDomain)=Disk(NaN,(NaN,NaN))

const 𝔻=Disk()

isambiguous(d::Disk)=isnan(d.radius) && all(isnan,d.center)
Base.convert(::Type{Disk},::AnyDomain)=Disk(AnyDomain())


#canonical is rectangle [r,0]x[-π,π]
# we assume radius and centre are zero for now
fromcanonical{T<:Real}(D::Disk{true,T},x,t)=D.radius*x*cos(t)+D.center[1],D.radius*x*sin(t)+D.center[2]
tocanonical{T<:Real}(D::Disk{true,T},x,y)=sqrt((x-D.center[1])^2+(y-D.center[2]^2))/D.radius,atan2(y-D.center[2],x-D.center[1])
checkpoints(d::Disk)=[fromcanonical(d,(.1,.2243));fromcanonical(d,(-.212423,-.3))]

# function points(d::Disk,n,m,k)
#     ptsx=0.5*(1-gaussjacobi(n,1.,0.)[1])
#     ptst=points(PeriodicInterval(),m)
#
#     Float64[fromcanonical(d,x,t)[k] for x in ptsx, t in ptst]
# end


∂(d::Disk)=Circle(Complex(d.center...),d.radius)


