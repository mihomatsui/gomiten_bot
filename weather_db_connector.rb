require 'active_record'
require 'dotenv/load'

class WeatherDbConnector
  # 環境変数を使って接続する
  ActiveRecord::Base.establish_connection(
    adapter: ENV['myadapter'],
    host:    "",
    username: ENV['myusername'],
    password: ENV['mypassword'],
    database: ENV['mydatabase']
  )

  # クラスを作成
  class Weather < ActiveRecord::Base
  end

  def set_location(user_id, latitude, longitude)
    p "set_location"

    # 緯度経度を計算して絶対値を取得する
    @weathers = Weather.all
    @weathers.each { |weather| weather.update(abs: 'abs(latitude - #{latitude}) + abs(longitude - #{longitude}')}
    result = @weathers.order(abs: :asc).first
    return result['pref'], result['area']

    # 絶対値格納用のカラムを削除
    # deletesql = 'ALTER TABLE weathers DROP COLUMN abs numeric;'
    # ActiveRecord::Base.connection.execute(deletesql)
  end
end