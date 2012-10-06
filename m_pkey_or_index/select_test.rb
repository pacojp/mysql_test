require 'mysql2'

client = Mysql2::Client.new(
  :host     => "127.0.0.1",
  :username => "root",
  :database => 'performance_test')

#
# 20.0 sec (with no caluculation)
# 20.5 sec (with 10 int comparison)

query = 'SELECT SQL_NO_CACHE * FROM tests where id > 9000000 AND id < 9100000'

start_at = Time.now

client.query(query).each do |row|
  #  p row
  #row['int1'] == 1
  #row['int2'] == 1
  #row['int3'] == 1
  #row['int4'] == 1
  #row['int5'] == 1
  #row['int6'] == 1
  #row['int7'] == 1
  #row['int8'] == 1
  #row['int9'] == 1
  #row['int10'] == 1
end

end_at = Time.now

puts "#{end_at - start_at}sec"

