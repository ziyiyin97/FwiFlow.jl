push!(LOAD_PATH, "@stdlib")
import Pkg; Pkg.add("Conda"); 
using Conda
using ADCME 

@info "Install Boost"
CONDA = get_conda()
run(`$CONDA install boost`)

@info "Install AMGCL"
UNZIP = joinpath(ADCME.BINDIR, "unzip")
if !isdir("$(@__DIR__)/amgcl")
    download("https://github.com/ddemidov/amgcl/archive/master.zip", "$(@__DIR__)/amgcl.zip")
    run(`$UNZIP -o $(@__DIR__)/amgcl.zip -d $(@__DIR__)`)
    mv("$(@__DIR__)/amgcl-master","$(@__DIR__)/amgcl", force=true)
    rm("$(@__DIR__)/amgcl.zip")
end

@info "Build Custom Operators"
change_directory("CustomOps/build")
require_file("build.ninja") do
    ADCME.cmake()
end
ADCME.make()


