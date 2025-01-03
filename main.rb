require_relative 'config'
require_relative 'tooting'
require_relative 'skyoracle'
require_relative 'tarot'
require 'json'

PROCESSED_FILE = 'processed_mentions.json'

# 処理済みIDのロード
def load_processed_ids
  return [] unless File.exist?(PROCESSED_FILE)
  JSON.parse(File.read(PROCESSED_FILE))
rescue JSON::ParserError => e
  puts "JSON解析エラー: #{e.message}"
  []
end

# 処理済みIDの保存
def save_processed_ids(ids)
  File.write(PROCESSED_FILE, ids.to_json)
rescue StandardError => e
  puts "ファイル書き込みエラー: #{e.message}"
end

# メンション処理
client = Tooting.new(BASE_URL, ACCESS_TOKEN)
processed_ids = load_processed_ids

client.check_mentions.each do |mention|
  begin
    next if processed_ids.include?(mention['id'].to_s)
    content = mention['status']['content'].gsub(/<\/?[^>]+>/, '') # タグ除去

    # キーワード応答
    response = []
    if content.match?(/空オラクル/)
      skys = Sky.new.oracle_sky
      result = skys.map { |sky| "【#{sky[:name]}】#{sky[:description]}" }.join("\n")
      response << "今日はこんな空模様です。\n\n#{result}\n\n良い一日をお過ごしください。"
    end

    if content.match?(/タロット.*3枚|3タロット|３タロット/)
      cards = Tarot.new.three_cards
      result = cards.map { |card| "【#{card[:name]}】#{card[:description]}" }.join("\n")
      response << "タロットを3枚引いた結果はこちらです。\n\n#{result}"

    elsif content.match?(/タロット/)
        cards = Tarot.new.read_cards
        result = cards.map { |card| "【#{card[:name]}】#{card[:description]}" }.join("\n")
        response << "タロット占いの結果はこちらです。\n\n#{result}"
    end

    # 応答の投稿
    unless response.empty?
      user = mention['account'] ? mention['account']['acct'] : '不明なユーザー'
      client.post_status("@#{user} \n#{response.join("\n")}", mention['status']['id']) # 修正された呼び出し
    end

    # 処理済みIDを記録
    processed_ids << mention['id'].to_s
    save_processed_ids(processed_ids) 

rescue StandardError => e
  puts "エラー発生: #{e.message}"
end
end