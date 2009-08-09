
$test_txt = File.join(ENV["HOME"],"github-contest-data/test.txt")

class Data
  DIR = File.join(ENV["HOME"],"github-contest-data")
  module Test
    def self.read
      File.read(File.join(DIR,"test.txt")).split("\n")
    end
  end
  module Data
    def self.read
      File.read(File.join(DIR,"data.txt")).split("\n").each do |line|
        uid, rid = line.split(":")
        User[uid] << rid if User.all.include?(uid)
      end
    end
  end
end

class User
  def self.init
    self.all
    Data::Data.read
  end

  def self.all
    if @users.nil?
      @users = Hash.new
      Data::Test.read.each{|uid| @users[uid] = self.new(uid)}
    end
    @users
  end

  def self.[](uid)
    @users[uid]
  end

  attr_reader :id

  def initialize(id)
    @id = id
    @reps = []
  end

  def <<(rid)
    @reps << rid
  end

  def <=>(a)
    @id.to_i <=> a.id.to_i
  end

  def to_s
    "#{@id}:#{@reps.join(",")}"
  end
end

User.init

User.all.values.sort.each{|user| puts user.to_s}
