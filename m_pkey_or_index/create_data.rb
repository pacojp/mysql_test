# -*- coding: utf-8 -*-

require 'mysql2'
require '../lib/util'

setup_mysql_settings(:host => "127.0.0.1", :username => "root",:database=>'performance_test')
insert_per_rows = 1000

BRAND_COUNT     = 13
USER_PER_BRAND  = 300_0000
#user_per_brand = 30

# データの作成ロジック（ループ、列データ作成共に共通です）
loops = [
  [:brand_id,(1..BRAND_COUNT)],
  [:user_id, (1..USER_PER_BRAND)]
]

procs = {
  :brand_id   => Proc.new{|v|v[:brand_id]},
  :user_id    => Proc.new{|v|v[:user_id]},
  :name       => Proc.new{|v|"#{v[:brand_id]}_#{v[:user_id]}_name"},
  :value1     => Proc.new{rand(10000)},
  :created_at => Proc.new{'NOW()'},
}

# オートインクリ主キーなテーブル
query "DROP TABLE IF EXISTS m_pkey_or_index__index;"
query "
CREATE TABLE m_pkey_or_index__index (
  `id` int(11) NOT NULL auto_increment,
  `brand_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `value1` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `idx01` USING BTREE (`brand_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
"
create_rows(
  'm_pkey_or_index__index',
  loops,
  procs
)

# 複合主キーなテーブル
query "DROP TABLE IF EXISTS m_pkey_or_index__m_pkey;"
query "
CREATE TABLE m_pkey_or_index__m_pkey (
  `brand_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `value1` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY  (`brand_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
"
create_rows(
  'm_pkey_or_index__m_pkey',
  loops,
  procs
)
