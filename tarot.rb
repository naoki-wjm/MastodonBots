require 'securerandom' # カードの確率を決めるのに必要

class Tarot
  CARDS = [
    { name: '愚者', description: '無邪気に冒険に出る様は、新たな風を呼ぶのか、ただの無計画なのか。' },
    { name: '魔術師', description: '自分の能力で頑張りたいようだが、果たして自信のほどは。' },
    { name: '女教皇', description: '神秘と知性がもたらすのは、冷静な英断か、冷徹な批判か。' },
    { name: '女帝', description: '心身ともに満たされたとき、満足できるか、欲が増すか。' },
    { name: '皇帝', description: 'その地位に上り詰めたことは、成功の表れか、ただの孤立か。' },
    { name: '教皇', description: '慈悲や優しさを象徴していれば良い、頑固な見栄っ張りに御用心。' },
    { name: '恋人', description: '心浮かれるそのひとときに、溺れすぎることなかれ。' },
    { name: '戦車', description: '己の意志を強く持ち、自ら疾く動けば勝機あり。' },
    { name: '力', description: '不屈の精神力でやり遂げるのか、力及ばず嘆くのか。' },
    { name: '隠者', description: '静かに見極めている、だが考えすぎて動けねばその意味たるや。' },
    { name: '運命の輪', description: '状況は回転し続け、直ぐに移り変わるもの。変化に注意あれ。' },
    { name: '正義', description: '公平であるならば、恐れることはない。不正に裁きあれ。' },
    { name: '吊るされた男', description: '試練を受けるその先で、報われるのか、徒労に終わるのか。' },
    { name: '死神', description: '終わりはやってくるだろう、新たな始まりのために。' },
    { name: '節制', description: '流れる水のように清らかであれ、澱んではいるまいか。' },
    { name: '悪魔', description: '甘き誘惑に心堕つことあれど、解放されるなれば改善の見込み。' },
    { name: '塔', description: '警戒せよ、その足場は崩れるかも知れぬと。' },
    { name: '星', description: '煌めき、閃き、果たしてそれは手に届くのか。' },
    { name: '月', description: '移ろいゆく面影は、幾ら苦くとも、ただの幻。' },
    { name: '太陽', description: '明暗は分かたれた。そこにあるのはYESかNOだけ。' },
    { name: '審判', description: 'かつての行いが明るみに晒される。善きことか悪しきことかは、貴方が知っている。' },
    { name: '世界', description: '理想を手に入れられればこの上ない幸せ、故に逃せば失意に見舞われよう。' }
  ]

  def read_cards
    if SecureRandom.random_number(100) < 1
      CARDS.sample(3) # 1%で3枚選択
    elsif SecureRandom.random_number(100) < 5
      CARDS.sample(2) # 5%で2枚選択
    else
      [CARDS.sample] # 1枚選択
    end
  end

  def three_cards
    CARDS.sample(3)
  end
  
end