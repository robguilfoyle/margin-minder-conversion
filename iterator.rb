


def insert_line_additions(line)
	return line[0..13] + "0000" + line[14..line.length]
end

def reconstruct_data_file(data,filename,cube)
	header = <<-eos
[ACQUIRE_VERSION]
1.1.1

[DATASET]
rnyvpmmr101

[FILE_TYPE]
DATA

[DATA_CUBE]
eos

header = header + cube + "\n\n[START_BLOCK]\n"
	
	footer = '[END_BLOCK]'
	File.open('./altered-data/' + filename, 'w') do |f|
		f.write(header)
		data.each do |line|
			f.write(line)
		end
		f.write(footer)
	end
end


#loop through the data directory's files
Dir.glob('./data/*.txt') do |file|
	#create a line counter variable
	counter = 0
	#create short memory array for storage
	tmp = Array.new
	cube = ""
	
	#loop through each line in each file
	File.read(file).each_line do |line|	
		#increase line count by 1
		counter += 1
	
		#set cube name
		if counter == 11 then cube = line.chomp end
	
		#start after the files header information, and stop before the end block
		if counter > 13 and line.chomp != '[END_BLOCK]'
			#start line additions, add it to tmp storage Array
			tmp << insert_line_additions(line)
		end#if
	end#line read
	
	puts "Currently Reconstructing " + cube + " file: " + file.split('/').last.to_s
	reconstruct_data_file(tmp,file.split('/').last,cube)

end#file read