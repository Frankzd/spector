for blockdim in 1 2 4 8 16 32 64 128 256 512
do
	for comp_u in 1 2 3 4
	do
		for unroll_f in 1 2 4 8 16 32
		do
            		for vect_w in 1 2 4 8 16
			do
				design_name="spmv_b""$blockdim""_compu""$comp_u""_unrollf""$unroll_f""_vectw""$vect_w"

				aocx_file_name="$design_name"".aocx"

				export MYOPENCL_HOST_CODE_FILE_NAME=$design_name
				if [ -f ./$aocx_file_name ]
				then
					host_program_name=""
					host_program_name+=$design_name
					host_program_name+="_host"
					num_design=$(($num_design+1))
					echo "design number:" >> run_results.txt
					echo $num_design >> run_results.txt
					echo $host_program_name >> run_results.txt
					make
					#run host program



					aocl program acl0 $aocx_file_name

					./$host_program_name csrmatrix_R1_N512_D5000_S01 | grep 'Pass' &> /dev/null
					while [ $? -ne 0 ]
					do
						aocl program acl0 $aocx_file_name
						./$host_program_name csrmatrix_R1_N512_D5000_S01 | grep 'Pass' &> /dev/null
					done
					./$host_program_name csrmatrix_R1_N512_D5000_S01 >> run_results.txt
				fi

			done
		done
	done
done
                	