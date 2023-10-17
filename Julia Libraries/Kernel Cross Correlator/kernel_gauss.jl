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
    using CUDA
    using CUDA.CUFFT

# --Function definition
    function kernel_gauss(f_x, f_y, sigma)

        # --Setup Parameters
            N = length(f_x);
            xx = (CuArray(f_x') * f_x) / N
            yy = (CuArray(f_y') * f_y) / N;  
            xy = ifft(f_x .* conj(f_y));
            fft_kernel = CUDA.zeros(N,1);

        # --Kernel setup
            num_threads = CUDA.attribute(device(), CUDA.DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK);
            num_blocks = cld(N, num_threads); 
        
        # --Define calculate GAUSSIAN KERNEL using broadcasting
            fft_kernel = exp.(-1 ./ (sigma^2 .*(xx + yy .- 2 .* xy) ./ length(xy)));
            
        # --Calls on CUDA Kernel Defined Below {DOESN'T WORK YET; Above code works well}
            # @cuda(
            #     threads = num_threads, 
            #     blocks = num_blocks, 
            #     helper_func!(fft_kernel, xx, yy, xy, sigma));

        return fft_kernel
    end

# --Helper Kernel Function [SID]
    function helper_func!(fft_kernel, xx, yy, xy, sigma)

        # --Find calculation index
            i = (blockIdx().x - 1) * blockDim().x + threadIdx().x;

        # --Calculating kernel
            if i <= length(xy)
                fft_kernel[i] = exp.(-1/(sigma[1]^2 * (xx[1] + yy[1] - 2 * xy[i])));  # Actual Kernel Definition
            end

        return nothing
    end
