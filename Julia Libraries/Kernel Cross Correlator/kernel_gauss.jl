#=  kernel_gauss.jl
    This is the kernel that is used to develop the kxcorr for the chirp detection algorithm.

    Inputs:
        x::CuArray{Complex64}   --  Frequency domain matrix of the x values, can be both a vec
                                    or an array type.
        y::CuArray{Complex64}   --  Freqyency domain matrix of the y values, can be both a vec
                                    or an array type.
        sigma::Int              --  Static integer that is used in the gaussian kernel math.

    Outpus:
        kernel::CuArray{Complex64}  --  The kernel values of the dataset as a complex CUDA
                                        array in the frequency domain.

=#

# --Using statements   
using DSP
using StatsBase
using AbstractFFTs  

# --Function definition
function gauss_kernel(xf::Vector{ComplexF64}, yf::Vector{ComplexF64}, sigma)

	# --Setup parameters
		N = length(xf)

	# --Perform Auto and Cross correlations
		xx = abs.(xf' * xf ./ N);
		yy = abs.(yf' * yf ./ N);
		xy = ifft(xf .* conj.(yf));

	# --Compute Kernel Transformation
		kf = exp.(-1 ./ sigma^2 .* (xx + yy .- 2 .* xy) ./ N)
		output = abs.(kf);

	return output::Vector{Float64}
end