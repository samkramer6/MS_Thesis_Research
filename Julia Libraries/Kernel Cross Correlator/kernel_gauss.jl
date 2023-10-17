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

# --Function definition
    function kernel_gauss(f_x, f_y, sigma)

        # --Setup Parameters
            N = length(f_x);
            fft_kernel = CUDA.zeros(N,1);

        # --Kernel Work
            num_threads = CUDA.attribute(device(), CUDA.DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK);
            num_blocks = cld(N, num_threads); 
        
        # --Define Kernel
            @cuda(
                threads = num_threads, 
                blocks = num_blocks, 
                helper_func!(fft_kernel, f_x, f_y, sigma));

        return fft_kernel
    end

# --Helper Kernel Function
    function helper_func!(fft_kernel, x, y, sigma)

        # --Find calculation index
            i = (blockIdx().x - 1) * blockDim().x + threadIdx().x;

        # --Calculating kernel
            if i <= length(fft_kernel)
                @inbounds fft_kernel[i] = exp(-1/(x[i] + y[i] - sigma .* y[i]));  # Actual Kernel Definition
            end

        return nothing
    end

