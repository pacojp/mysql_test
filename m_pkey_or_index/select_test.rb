require 'mysql2'
require 'benchmark'

client = Mysql2::Client.new(
  :host     => "127.0.0.1",
  :username => "root",
  :database => 'performance_test')

queries = [
  ['m_pkey', 'warmup', 'm_pkey_or_index__m_pkey', ''],
  ['m_pkey', 'warmup', 'm_pkey_or_index__m_pkey', ''],
  ['m_pkey', 'count',  'm_pkey_or_index__m_pkey', 'brand_id = 6'],
  ['m_pkey', 'count',  'm_pkey_or_index__m_pkey', 'brand_id = 6 AND value1 > 4000'],
  ['m_pkey', 'count',  'm_pkey_or_index__m_pkey', 'brand_id = 6 AND value1 > 4000 AND value2 < 6000'],
  ['m_pkey', 'fetch',  'm_pkey_or_index__m_pkey', 'brand_id = 6'],
  ['m_pkey', 'fetch',  'm_pkey_or_index__m_pkey', ''],
  ['index',  'warmup', 'm_pkey_or_index__index',  ''],
  ['index',  'warmup', 'm_pkey_or_index__index',  ''],
  ['index',  'count',  'm_pkey_or_index__index',  'brand_id = 6'],
  ['index',  'count',  'm_pkey_or_index__index',  'brand_id = 6 AND value1 > 4000'],
  ['index',  'count',  'm_pkey_or_index__index',  'brand_id = 6 AND value1 > 4000 AND value2 < 6000'],
  ['index',  'fetch',  'm_pkey_or_index__index',  'brand_id = 6'],
  ['index',  'fetch',  'm_pkey_or_index__index',  ''],
]

log = ""

Benchmark.bm(15) do |x|
  i = 0
  queries.each do |ar|
    ar[3] = " WHERE #{ar[3]}" if ar[3].size > 0
    query = "SELECT SQL_NO_CACHE "
    case ar[1]
    when 'count'
      query += "count(*) AS cnt FROM #{ar[2]}#{ar[3]}"
    when 'fetch','warmup'
      query += "* FROM #{ar[2]}#{ar[3]}"
    when 'warmup'
    else
      raise 'must not happen'
    end
    ar << query

    if ar[1] == 'warmup'
      client.query(query)
    else
      i += 1
      title = "#{i.to_s.rjust(2,'0')}:#{ar[0]}"
      report_title = "#{title} #{ar[1]}"
      x.report(report_title) do
        ret = client.query(query)
        case ar[1]
        when 'count'
          title += "(counted:#{ret.first['cnt']})"
        when 'fetch'
          title += "(fetched:#{ret.size})"
        end
        log += title.center(title.size+6,' ').center(60,'=') + "\n" + query + "\n"
      end
    end
  end
end
puts ''
puts log
