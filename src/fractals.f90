module mandelbrot
    use iso_fortran_env, only : int32
    implicit none
    private

    integer, parameter, public :: default_range(4) = [-2, 1, 1, -1]  ! x0, y0, x1, y1
    integer, parameter, public :: max_iterations = 100
    real, parameter, public    :: threshold = 1000

    public :: render

contains

    subroutine render(bitmap)
        implicit none

        integer(int32), intent(inout) :: bitmap(:,:)
        integer                      :: width, height, row, col
        real                         :: range_width, range_height
        integer(int32)               :: colour
        complex                      :: z, c
        integer                      :: iteration

        height = size(bitmap, 1)
        width = size(bitmap, 2)
        range_width = default_range(3) - default_range(1)
        range_height = default_range(2) - default_range(4)
        bitmap = 1

        do row = 0, height-1
            do col = 0, width-1
                z = 0
                c = cmplx(default_range(1)+(col/real(width))*range_width, default_range(2)-(row/real(height))*range_height)
                ! print *, row, col, c
                do iteration = 1, max_iterations
                    z = (z * z) + c
                    if (abs(z) > threshold) exit
                end do
                colour = min(iteration, huge(colour))
                bitmap(row+1, col+1) = colour
            end do
        end do
    end subroutine

end module mandelbrot

module util
    use iso_fortran_env, only : int32
    implicit none
    private

    public :: print_bitmap

contains
    subroutine print_bitmap(bitmap)
        implicit none

        integer(int32), intent(in) :: bitmap(:,:)
        integer                   :: row

        do row = 1, size(bitmap, 1)
            print '(120Z1)', bitmap(row, :)
        end do
    end subroutine

end module util

program fractals
    use iso_fortran_env, only : int32
    use util, only : print_bitmap
    use mandelbrot, only : render
    implicit none

    integer, parameter :: width = 60 / 2 * 2  ! twice the width to compensate stretched ASCII output
    integer, parameter :: height = 40 / 2
    integer(int32), allocatable :: bitmap(:,:)

    allocate(bitmap(height, width))
    call render(bitmap)
    call print_bitmap(bitmap)
end program fractals
