require 'bundler/setup'
Bundler.require
# 開発環境のみオートリロードをつける
require 'sinatra/reloader' if development?
require './weather_db_connector'
require './weather_info_connector'

$db = WeatherDbConnector.new

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read
  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end
  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      user_id = event['source']['userId']
      reply_text = "使い方:\n\n・位置情報を送信してください。\n(トークルーム下部の「+」をタップして、「位置情報」から送信できます。)\n\n"
      reply_text << "・「1」または「スタート」と入力すると、毎日朝7時に天気、\n"
      reply_text << "  夜の21時に翌日のゴミの収集日をお知らせします。\n\n"
      reply_text << "・「2」または「ストップ」と入力すると、停止します。\n\n"
      reply_text << "・「3」または「天気」と入力すると、現在設定されている地域の天気をお知らせします。\n"
      
      case event.type
      when Line::Bot::Event::MessageType::Text
        # 文字列が入力された場合
        case event.message['text']
        when /.*(1|１|スタート).*/
          p 'テスト1'
        when /.*(2|２|ストップ).*/
          p 'テスト2'
        end
      when Line::Bot::Event::MessageType::Location
        # 位置情報が入力された場合
        
        # 緯度と経度を取得
        latitude = event.message['latitude']
        longitude = event.message['longitude']
        puts "緯度と経度を取得しました！"
        pref, area = $db.set_location(user_id, latitude, longitude)
        reply_text = %{地域を#{pref} #{area}にセットしました！\n\n「3」または「天気」と入力すると、現在設定されている地域の天気をお知らせします。}
        
      end

    end
    message = {
          type: "text",
          text: reply_text
        }
    client.reply_message(event["replyToken"], message)
  end
  "OK"
end
get '/' do
  "Hello world!"
end