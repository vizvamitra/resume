#!/usr/bin/env ruby

require 'rexml/document'
require 'csv'
include REXML

class String
  def colorize(code)
    "\x1B[#{code}m" + self + "\x1B[0m"
  end
  
  def red; colorize(31); end
  def green; colorize(32); end
  def blue; colorize(34); end
  
  def key?
    self[0]=='-'
  end
end

##################### GEN #####################

class KmlGen
  def initialize csv
    @csv = open_input_file(csv)
    @kml = make_kml
    save
  end

  def make_kml
    kml = blank_kml()
    coords_elem = kml.root.elements['Document/Placemark/LineString/coordinates']
    name_elem = kml.root.elements['Document/Placemark/name']
    
    # plasemark = kml.root.elements['Document/Placemark']
    # document_elem = kml.root.elements['Document']
    # document_elem.add_element(plasemark)
    # puts document_elem

    coords = get_coords

    name_elem.text = coords[0][:date].to_s + " - " + coords[-1][:date].to_s

    coords_string = coords.inject("") do |text, row|
      text += "\n" + ' '*8 + row[:longitude] + ',' + row[:latitude]
    end
    coords_string += "\n" + ' '*6
    coords_elem.text = coords_string

    kml
  end

private

  def open_input_file (csv)
    begin
      CSV.read(csv, 'r', {headers: true})
    rescue
      error("Can't open input file. Ensure that it is .csv")
    end
  end
  
  def blank_kml
    begin
      blank = File.open("blank.kml")
    rescue
      error("Can't open blank.kml file. Ensure that it exists in programm directory")
    end
    Document.new(blank)
  end
  
  def get_coords
    coords = []
    @csv.each do |row|
      coords << {date: row['date'], latitude: row['latitude'], longitude: row['longitude']} if row['provider'] == "GPS"
    end
    coords
  end

  def save
    begin
      output = File.new(Time.now.to_i.to_s + ".kml", "w")
      output.puts(@kml)
      output.close
      puts 'File "' + output.path + '" was successfuly created'
    rescue Exception => e
      error("Something went wrong while saving output file. Please, try again")
    end
  end
  
  def error(text)
    puts "ERROR".red + ": " + text
    exit
  end
end

##################### APP #####################

class App
  def initialize
    @log = inputCheck
    @gen = KmlGen.new(@log)
  end
  
  def inputCheck
    usage() if ARGV[0].nil?
    usage() unless File.exists?(ARGV[0])
    usage() if ARGV[0].split('.')[-1] != 'csv'
    ARGV[0]
  end
  
  def usage
    puts "USAGE".green + ": kmlgen.rb CSV_FILE_PATH"
    puts "\nMade for you by Vizvamitra (" + "vizvamitra@gmail.com".blue + ", Russia)"
    exit
  end
end

app = App.new()