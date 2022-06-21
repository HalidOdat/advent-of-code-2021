integer function part_one(n, array)
  implicit none

  integer,       intent(in) :: n
  character*256, intent(in) :: array(n)

  integer :: bits(len_trim(array(1)))
  integer :: gamma, epsilon, i, j

  bits    = 0
  do i = 1, n
    do j = 1, size(bits)
      if (array(i)(j:j) == '1') then
        bits(j) = bits(j) + 1
      endif
    enddo
  enddo

  gamma   = 0
  epsilon = 0
  do i = 1, size(bits)
    gamma   = gamma   * 2
    epsilon = epsilon * 2
    if (bits(i) >= n / 2) then
      gamma = gamma + 1
    else
      epsilon = epsilon + 1
    endif
  enddo

  part_one = gamma * epsilon
end function part_one

integer function part_two(n, input)
  implicit none

  integer,       intent(in) :: n
  character*256, intent(in) :: input(n)

  character*256 :: array(n)
  integer :: bits(len_trim(input(1)))
  integer :: oxygen, co2, i, j, current_size, temp_size, part, result

  do part = 0, 1
    bits         = 0
    array        = input
    current_size = n

    do i = 1, size(bits)
      do j = 1, n
        if (len_trim(array(j)) /= 0 .and. array(j)(i:i) == '1') then
          bits(i) = bits(i) + 1
        endif
      enddo

      temp_size = current_size
      do j = 1, n
        if (len_trim(array(j)) == 0) then
          cycle
        endif

        if (current_size == 1) then
          exit
        endif

        if (part == 0) then ! for Oxygen calculation
          if (array(j)(i:i) == '1') then
            if (bits(i)*2 < current_size) then
              array(j) = ""
              temp_size = temp_size - 1
            endif
          else
            if (bits(i)*2 >= current_size) then
              array(j) = ""
              temp_size = temp_size - 1
            endif
          endif
        else ! for CO2 calculation
          if (array(j)(i:i) == '1') then
            if (bits(i)*2 >= current_size) then
              array(j) = ""
              temp_size = temp_size - 1
            endif
          else
            if (bits(i)*2 < current_size) then
              array(j) = ""
              temp_size = temp_size - 1
            endif
          endif
        endif
      enddo
      current_size = temp_size
    enddo

    result = 0
    do i = 1, n
      if (len_trim(array(i)) == 0) then
        cycle
      endif

      do j = 1, size(bits)
        result = result * 2
        if (array(i)(j:j) == '1') then
          result = result + 1
        endif
      enddo
    enddo

    if (part == 0) then
      oxygen = result
    else
      co2    = result
    endif
  enddo

  part_two = oxygen * co2
end function part_two

program Main
  implicit none

  integer :: part_one
  integer :: part_two

  character(100) :: filepath
  integer :: fd, ierr, lines_count, i, j

  character*256 :: ctmp
  character*256, allocatable :: array(:)

  do i = 1, command_argument_count()
    call get_command_argument(number=i, value=filepath)
    
    fd          = 1
    ierr        = 0
    lines_count = 0

    open(unit=fd, file=filepath)

    ! 2. Get number of lines
    do while (ierr == 0)
      lines_count = lines_count + 1
      read(fd, *, iostat=ierr) ctmp
    end do
    lines_count = lines_count - 1

    ! 3. Allocate array of strings
    allocate(array(lines_count))

    ! 4. Read the file content
    rewind(fd)
    do j = 1, lines_count
      read(fd,'(A)') array(j)
    enddo

    print '(A,A,I0)', trim(filepath), ": Part one: ", part_one(lines_count, array)
    print '(A,A,I0)', trim(filepath), ": Part two: ", part_two(lines_count, array)

    deallocate(array)
    close(fd)
  enddo

end program Main