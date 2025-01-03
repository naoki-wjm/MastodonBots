require 'securerandom' # カードの確率を決めるのに必要

class Sky
  SKYS = [
    { name: '星空', description: '自分を甘やかして、ゆっくり寝る時間です。' },
    { name: '月', description: '不神秘的なことに触れて癒されましょう。' },
    { name: '太陽', description: 'イケイケモードなお時間です。' },
    { name: '虹', description: '今までの頑張りが報われるでしょう。' },
    { name: '雪', description: '静かにゆったり過ごしましょう。' },
    { name: '小雨', description: '気持ちを整理すると良いでしょう。' },
    { name: '蒼天', description: '今、思ったことをやりましょう。' },
    { name: '曇天', description: 'やるべきことを見直せば発見があるかもしれません。' },
    { name: '雷', description: 'サプライズがあるかもしれません。' },
    { name: '風', description: '流れるままに流されましょう。' },
    { name: '薄明', description: '何かが始まる予感がします。' },
    { name: '茜空', description: '絆に救われるかもしれません。' },
    { name: '霧', description: '心の奥底の望みに耳を傾けましょう。' },
    { name: '天使の階段', description: '閃きや直感に従いましょう。' },
    { name: '大雨', description: '一旦、休憩する時間です。' },
    { name: '狐の嫁入り', description: '周りに面白いことがあるかもしれません。' }
  ]

  def oracle_sky
    if SecureRandom.random_number(100) < 1
      SKYS.sample(3) # 1%で3枚選択
    elsif SecureRandom.random_number(100) < 5
      SKYS.sample(2) # 5%で2枚選択
    else
      [SKYS.sample] # 1枚選択
    end
  end
end