#output function execution time
# usage:
#     1) break funcname; // bp1
#	  2) break return address of funcname; //bp2, disassemble, address before ret
#	  3) command 1
#		  tic
#		  continue
#		  end
#	  4) command 2
#		  toc
#		  continue
#		  end
# Note: tic must execute before toc

define tic
set $tstart = (struct timespec*)malloc(sizeof(struct timespec))
call (void)clock_gettime(0, $tstart)
end

define toc
set $tend = (struct timespec*)malloc(sizeof(struct timespec))
call (void)clock_gettime(0, $tend)
set $elapsed = ($tend->tv_sec - $tstart->tv_sec) * 1000000000LL + ($tend->tv_nsec - $tstart->tv_nsec)
printf "Function elapsed: %lld ns (%.3f ms)\n", $elapsed, $elapsed/1.0e6
call (void)free($tend)
call (void)free($tstart)
end
