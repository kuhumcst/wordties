# encoding: UTF-8
require 'action_view/helpers/number_helper'
module PWN
  class Intersection
    include ActionView::Helpers::NumberHelper
    
    # Directories and Output
    DATA_DIR    = "#{Rails.root}/lib/import/pwn_data/common_data"
    OUTPUT_FILE = "corepwn_intersect_freq_output.all.tsv"
    
    # Data files: pwn_swe.tsv corewn-fiwn-sensekeymap-sortfreq.tsv eq_core.tsv core_est.tsv
    FILES = %w{pwn_swe.tsv corewn-fiwn-sensekeymap-sortfreqsum.uniq.tsv eq_core.tsv core_est.tsv} 
    
    # Fields
    # Comment Format
    FORMAT = %w{pwd_id key_id name score freq}
    # Optional flexibility for handling different fields from input sources
    #DAN_NET_FORMAT = %w{pwd_id synset_key_id name score freq}
    #SWE_NET_FORMAT = %w{pwd_id sense_id name score freq}
    #FIN_NET_FORMAT = %w{pwd_id synset_key_id name score freq}
    #TEK_NET_FORMAT = %w{pwd_id sense_id name score freq}
    
    # Delimeters used (CSV, TSV)
    DEL = "\t"
    # Optional flexibility for handling different delimiters in input sources
    #DAN_NET_DEL = "\t"
    #SWE_NET_DEL = "\t"
    #FIN_NET_DEL = "\t"
    #TEK_NET_DEL = "\t"
    
    def initialize
    end
    
    # Run the script
    def run
      @pwn_list = Hash.new
      import_files
      
      begin
        # Build the sorted list based on Core PWN intersection and frequency data provided
        f = File.new("#{DATA_DIR}/#{OUTPUT_FILE}", "w")
        sort_by_freq.each { |elem|
          f << "#{elem[0]}\t#{number_with_precision(elem[1], :separator => '.', :precision => 18, :strip_insignificant_zeros => true)}\n"
        }
      ensure
        f.close
      end

      @pwn_list.length
    end

    def sort_by_freq
      @pwn_list.sort{|b,a| a[1] <=> b[1] }
    end
    
    def import_files
      FILES.each do |file|
        @relations = file
        puts "\timport_'#{file}' ... "
        send("import_relations")
      end
    end 
    
    def current_format
      return FORMAT, DEL  # Using common standard format
      # Optional case handling for input sources with different formats
      #return case @relations.to_s
        #when /eq_+(.*)/
        #  f, l = DAN_NET_FORMAT, DAN_NET_DEL
        #when /pwn+(.*)/
        #  l = SWE_NET_FORMAT, SWE_NET_DEL
        #when /corewn-fiwn+(.*)/
        #  f, l = FIN_NET_FORMAT, FIN_NET_DEL
        #when /et+(.*)/
        #  f, l = TEK_NET_FORMAT, TEK_NET_DEL
        #else nil
      #end
    end
    
    def import_relations
      # new list
      pwn_target_rel = Array.new
      format, del = current_format
      current_target = nil
      count = 0
      
      # get pwn-linked array
      rows(format, del) do |row|
          current_target = row['pwd_id']
          freq = row['freq'].to_f
          if current_target.scan("%").length > 0 
            pwn_target_rel << [current_target, freq]
          end
          count += 1
      end
            
      # generate new Hash and populate with values from file
      pwn_h, pwn_n = Hash.new, Array.new
      pwn_target_rel.each {|t| 
        pwn_h[t[0]] = t[1]
        
        # Uncomment if input data of freq values are for individual senses and need to summed here
        #if pwn_h.has_key?(t[0])
        #  puts "Found duplicate PWN sense link with frequency values (#{t}): #{pwn_h[t[0]]} and value(2): #{t[1]}"
        #  puts "Overide with new value for same PWN sense-key taking this as total (sum) value of frequency over all senses: #{t[1]}"
        #  v = pwn_h[t[0]]
        #  if v >= 0.0 || t[1] >= 0.0
        #    pwn_h[t[0]] = v + t[1]
        #  else
        #    pwn_h[t[0]] = t[1]
        #  end
        #else
        #  pwn_h[t[0]] = t[1]
        #end
        
      }    

       # find intersecting keys
      if @pwn_list.length > 0
          pwn_n = @pwn_list.select { |k,v| pwn_h.key?(k) }.keys
      end
        
      # merge data and calc combined freqs
      @pwn_list.merge!(pwn_h) { |key,v1,v2|
    	  puts "Merging values: #{v1} and value(2): #{v2}"
    	  if v2 > 0.0
    	    v1*v2
    	  else
  	     v1
        end
      }
      
      # Generate intersection
      if pwn_n.length > 0
        new_pwn_list = Hash.new
        pwn_n.each { |k|
          new_pwn_list[k] = @pwn_list[k]
        }
        
        @pwn_list = new_pwn_list
      end
      
      # output file count
      puts "total file count: #{count}"
      puts "intersect array size: #{pwn_n.length}"
    end
    
    # parse the data
    def rows(header, delimeter)
      file_content.each_line do |line|
        h={}
        header.zip(line.split(delimeter)).each {|k,v|
          h[k] = v
        }
        begin
          yield h
        rescue Exception => e
          puts "Processing:"
          puts "\t#{h.inspect}"
          puts "\t#{line}"
          raise e
        end
      end
    end
    
    # read the data
    def file_content
      begin
        file = File.open("#{DATA_DIR}/#{@relations}", "r")
        file.read
      ensure
        file.close
      end
    end
    
    # (IRB console) 
    # >> load "#{Rails.root}/lib/pwn_intersection.rb"
    # >> PWN::Intersection.instance.run
    @@instance = Intersection.new
    def self.instance
      return @@instance
    end
    
    private_class_method :new
        
  end
end
