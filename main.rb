require_relative 'tooting'
require_relative 'skyoracle'
require_relative 'tarot'

# クライアントの作成
client = Tooting.new(base_url, access_token)

# メンションの処理
client.fetch_mentions.each do |mention|
  content = mention.status.content.gsub(/<[^>]*>/, '') # HTMLタグの除去
  words = content.split

  # キーワード検出と応答作成
  response = words.map do |word|
    case word
    when '空オラクル'
        # skyoracle.rb処理呼び出し
        skys = Skyoracle.new.oracle_sky
        result = skys.map { |sky| "【#{sky[:name]}】#{sky[:description]}" }.join("\n")
        "今日はこんな空模様です。\n\n#{result}\n\n良い一日をお過ごしください。"
    when 'タロット'
        # tarot.rbの処理呼び出し
        cards = Tarot.new.read_cards
        result = cards.map { |card| "【#{card[:name]}】#{card[:description]}" }.join("\n")
        "タロット占いの結果はこちらです。\n\n#{result}"
    when '3タロット'||'３タロット'||'タロット3枚'||'タロット３枚'
        # tarot.rbの処理呼び出し
        cards = Tarot.new.three_cards
        result = cards.map { |card| "【#{card[:name]}】#{card[:description]}" }.join("\n")
        "タロットを3枚引いた結果はこちらです。\n\n#{result}"
    end
  end.join("\n")

  # 応答を投稿
  client.post_status("@#{mention.account.acct} \n#{response}")
end