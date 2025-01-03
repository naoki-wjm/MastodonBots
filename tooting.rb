require 'net/http'
require 'uri'
require 'json'



class Tooting
  def initialize(base_url, access_token) # 引数で環境変数を受け取る
    @base_url = base_url
    @access_token = access_token
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

        content = mention['status']['content'].gsub(/<\/?[^>]+>/, '') # タグ除去
        user = mention['account']['acct']

        puts "@#{user}: #{content}"
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


  def post_status(content, in_reply_to_id = nil)
    uri = URI.parse("#{@base_url}/api/v1/statuses")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@access_token}"
    request["Content-Type"] = "application/json"

    # 投稿内容をJSON形式で準備
    payload = { status: content }
    payload[:in_reply_to_id] = in_reply_to_id if in_reply_to_id # 返信先 ID を追加

    request.body = payload.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end