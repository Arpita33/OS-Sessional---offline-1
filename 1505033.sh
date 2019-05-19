#/!bin/bash
mkdir fresh_dir
unzip SubmissionsAll.zip -d fresh_dir
cd fresh_dir
ls > list_all_files.txt
mv list_all_files.txt ../list_all_file.txt
pwd
cd ..
pwd
f="list_all_files.txt"
sed -i "/$f/d" list_all_file.txt

> ids_from_unzipped_folder.txt
cat list_all_file.txt| while read line
do
chrlen=${#line}
#printf $chrlen"\n"
const=11
start=`expr $chrlen - $const`
#printf $start"\n"
id=${line:$start:7}
printf "%s\n""$id" >> ids_from_unzipped_folder.txt
#grep -F 1 "$id" CSE_322.csv >> ids_from_unzipped_folder.txt
done
printf "\n" >> ids_from_unzipped_folder.txt



cut -d ',' -f 1 < CSE_322.csv > student_ids_from_roaster.txt #separating the id column from CSE_322.csv into a text file
#mv student_ids_from_roaster.txt absentee_list.txt #renaming the file containg absentee list
cut -d ',' -f 1 < CSE_322.csv > absentee_list.txt

cat ids_from_unzipped_folder.txt| while read str
do
printf "%s\n""$str"
sed -i "/$str/d" absentee_list.txt #if the id from naming of the zip file is found in the text file, it is removed, leaving us with the absentee list
done

mkdir Output
cd Output
mkdir Extra
:'
> temp.txt
while read -r filename
do
strlen=${#filename}
num=4
pos=`expr $strlen - $num`
extension=${filename:$pos:4}
required=".zip"
if [ "$extension" = "$required" ]; then
#printf "%s\n""$extension" >> temp.txt


fi
done < list_all_file.txt
'
cd ..
pwd
#filename="Aaiyeesha Mostak_2998885_assignsubmission_file_1405.zip"
while read -r filename
do
mkdir temporaryFolder
unzip fresh_dir/"$filename" -d temporaryFolder
#unzip "$filename" -d temporaryFolder
pwd
cd temporaryFolder
num=`ls -A | wc -l`
if [ "$num" = 1 ]
then
 roll_num=$( echo "$filename" | cut -d "_" -f 5 | cut -d "." -f 1)
 sub_dir_name=`ls -A`
 echo "testing" 
 echo $sub_dir_name
 cd ..
  if echo $roll_num | grep -q [0-9][0-9][0-9][0-9][0-9][0-9][0-9]; then #checking for 7-digit id
   if  grep -q "$roll_num" CSE_322.csv ; then #checking for valid 7-digit id
	echo $roll_num	 
	if [ "$sub_dir_name" = "$roll_num" ]; then #subdirectory te shudhu roll
 		echo "$roll_num 10" >> Marks.txt
 		mv temporaryFolder/"$roll_num" Output/"$roll_num"
 		rm -r temporaryFolder
	elif echo "$sub_dir_name" | grep -q "$roll_num"; then #subdirectory CONTAINS roll
		cd temporaryFolder
  		mv "$sub_dir_name" "$roll_num"
  		echo "not supposed to be here!!!"
  		echo "$roll_num 5" >> ../Marks.txt 
		cd ..
 		mv temporaryFolder/"$roll_num" Output/"$roll_num"
 		rm -r temporaryFolder
	 else
		echo "$roll_num 0" >> Marks.txt #incorrect naming of folder before zipping, subdirectory te roll nai
 		mv temporaryFolder/"$roll_num" Output/"$roll_num"
 		rm -r temporaryFolder
	 fi
 	pwd

    
    else #invalid id
	name=$( echo "$filename" | cut -d "_" -f 1 )
	pwd
	number_of_matches=` grep -i "$name" CSE_322.csv | wc -l` #makes search case insensitive!
	echo "$number_of_matches"
	if [ $number_of_matches = 1 ]; then #single instance of name
		roll_from_name=`grep -F "$name" CSE_322.csv | cut -d "	" -f 2 | cut -d "\"" -f 1 `
		echo "$roll_from_name 0" >> Marks.txt
		cd temporaryFolder
		mv "$sub_dir_name" "$roll_from_name" #rename the directory with student id
		cd ..
		mv temporaryFolder/"$roll_from_name" Output/"$roll_from_name" #move it to output folder
		sed -i "/$roll_from_name/d" absentee_list.txt #delete student id from absentee list ->check kora baki!!
		rm -r temporaryFolder
	#else #onek gula eki namer manush
	else
		cd temporaryFolder
		mv "$sub_dir_name" "$name"
		cd ..
		mv temporaryFolder/"$name" Output/Extra/"$name"	
		rm -r temporaryFolder
	fi
	
     fi
  else
	echo "printing from here"
	name=$( echo "$filename" | cut -d "_" -f 1 )
	pwd
	number_of_matches=` grep -i "$name" CSE_322.csv | wc -l` #makes search case insensitive!
	echo "$number_of_matches"
	if [ $number_of_matches = 1 ]; then #single instance of name
		roll_from_name=`grep -F "$name" CSE_322.csv | cut -d "	" -f 2 | cut -d "\"" -f 1 `
		echo "$roll_from_name 0" >> Marks.txt
		cd temporaryFolder
		mv "$sub_dir_name" "$roll_from_name" #rename the directory with student id
		cd ..
		pwd
		mv temporaryFolder/"$roll_from_name" Output/"$roll_from_name" #move it to output folder
		sed -i "/$roll_from_name/d" absentee_list.txt #delete student id from absentee list ->check kora baki!!
		rm -r temporaryFolder
	#else #onek gula eki namer manush
	else
		cd temporaryFolder
		mv "$sub_dir_name" "$name"
		cd ..
		mv temporaryFolder/"$name" Output/Extra/"$name"	
		rm -r temporaryFolder
	fi
     
  fi
else #multiple subdirectories pawa gese
	echo "multiple subdirectories"
	roll_num=$( echo "$filename" | cut -d "_" -f 5 | cut -d "." -f 1)
	cd ..
	if grep -q "$roll_num" CSE_322.csv; then #roll pawa gese
		echo "$roll_num 0" >> Marks.txt
		mv temporaryFolder "$roll_num"
		mv "$roll_num" Output/"$roll_num"
	else
		echo "by name"
		name=$( echo "$filename" | cut -d "_" -f 1 )
		pwd
		number_of_matches=` grep -i "$name" CSE_322.csv | wc -l` #makes search case insensitive!
		echo "$number_of_matches"
		if [ $number_of_matches = 1 ]; then #single instance of name
			roll_from_name=`grep -F "$name" CSE_322.csv | cut -d "	" -f 2 | cut -d "\"" -f 1 `
			echo "$roll_from_name 0" >> Marks.txt
			mv temporaryFolder "$roll_from_name" #rename the directory with student id
			mv "$roll_from_name" Output/"$roll_from_name" #move it to output folder
			sed -i "/$roll_from_name/d" absentee_list.txt #delete student id from absentee list ->check kora baki!!
		#else #onek gula eki namer manush
		else 
			mv temporaryFolder "$name"
			mv "$name" Output/Extra/"$name"	
		fi
	
	fi

fi
done < list_all_file.txt

pwd

mv absentee_list.txt Output/absentee_list.txt
mv Marks.txt Output/Marks.txt
rm -r fresh_dir


























