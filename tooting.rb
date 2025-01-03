require 'net/http'
require 'uri'
require 'json'
require 'dotenv'

# .envファイルをロード
Dotenv.load

# Mastodon インスタンスのベースURLとアクセストークン
BASE_URL = ENV['MASTODON_BASE_URL']
ACCESS_TOKEN = ENV['MASTODON_ACCESS_TOKEN']

# 投稿を作成する関数
def post_status(content)
  uri = URI.parse("#{BASE_URL}/api/v1/statuses")
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = "Bearer #{ACCESS_TOKEN}"
  request["Content-Type"] = "application/json"

  # 投稿内容をJSON形式で準備
  request.body = {
    status: content
  }.to_json

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(request)
  end

  JSON.parse(response.body)
end

# メンションをチェックする関数
def check_mentions
    uri = URI.parse("#{BASE_URL}/api/v1/notifications")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{ACCESS_TOKEN}"
  
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  
    # HTTPレスポンスのステータスコード確認
    unless response.is_a?(Net::HTTPSuccess)
      puts "HTTPエラー: #{response.code} #{response.message}"
      return [] # エラー時は空配列を返す
    end
  
    # JSON解析とエラーハンドリング
    begin
      notifications = JSON.parse(response.body)
      mentions = notifications.select { |n| n.is_a?(Hash) && n['type'] == 'mention' }
  
      # メンションの中身検証
      mentions.each do |mention|
        next unless mention['status'] && mention['status']['content']
  
        puts "@#{mention['account']['acct']}: #{mention['status']['content']}"
      end
  
      mentions # メンションのリストを返す
    rescue JSON::ParserError => e
      puts "JSON解析エラー: #{e.message}"
      []
    rescue StandardError => e
      puts "予期せぬエラー: #{e.message}"
      []
    end
end