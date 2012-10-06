require 'mysql2'
require 'benchmark'

client = Mysql2::Client.new(
  :host     => "127.0.0.1",
  :username => "root",
  :database => 'performance_test')

Benchmark.bm do |x|
  x.report('m_pkey') do
    query = 'SELECT SQL_NO_CACHE count(*) FROM m_pkey_or_index__m_pkey WHERE brand_id = 6'
    client.query(query)
  end
  x.report('m_pkey') do
    query = 'SELECT SQL_NO_CACHE count(*) FROM m_pkey_or_index__m_pkey WHERE brand_id = 6 AND value1 > 4000'
    client.query(query)
  end
  x.report('m_pkey') do
    query = 'SELECT SQL_NO_CACHE count(*) FROM m_pkey_or_index__m_pkey WHERE brand_id = 6 AND value1 > 4000 AND value2 < 6000'
    client.query(query)
  end

  x.report('index') do
    query = 'SELECT SQL_NO_CACHE count(*) FROM m_pkey_or_index__index WHERE brand_id = 6'
    client.query(query)
  end
  x.report('index') do
    query = 'SELECT SQL_NO_CACHE count(*) FROM m_pkey_or_index__index WHERE brand_id = 6 AND value1 > 4000'
    client.query(query)
  end
  x.report('index') do
    query = 'SELECT SQL_NO_CACHE count(*) FROM m_pkey_or_index__index WHERE brand_id = 6 AND value1 > 4000 AND value2 < 6000'
    client.query(query)
  end
end

