require 'securerandom' # カードの確率を決めるのに必要

class Enigma
    ENIGMAS = [
        { name: 'サラマンダー', upright: '（正）勢いに乗っています', reversed: '（逆）熱くなりすぎていませんか' },
        { name: 'ノーム', upright: '（正）こつこつと積み立てましょう', reversed: '（逆）ハプニングの予感です' },
        { name: 'シルフ', upright: '（正）気分転換の時間です', reversed: '（逆）脱線してはいませんか' },
        { name: 'ウィンディーネ', upright: '（正）流れに身を任せましょう', reversed: '（逆）気持ちを整理しましょう' },
        { name: 'ドライアド', upright: '（正）神秘に触れて癒されましょう', reversed: '（逆）全てを忘れて眠りましょう' },
        { name: 'ドラゴン', upright: '（正）頑張りが報われるでしょう', reversed: '（逆）執着しすぎてはいませんか' },
        { name: 'ペガサス', upright: '（正）思うがままに進みましょう', reversed: '（逆）意固地にならず冷静に' },
        { name: 'ユニコーン', upright: '（正）自分の心に正直に', reversed: '（逆）周りを見る余裕を' },
        { name: 'マーメイド', upright: '（正）夢に手を伸ばしましょう', reversed: '（逆）発言の前にワンクッション' },
        { name: 'ケンタウロス', upright: '（正）何かを始める良きタイミング', reversed: '（逆）焦らず足場を固めましょう' },
        { name: 'フェニックス', upright: '（正）勝利への時は満ちました', reversed: '（逆）今は休憩する時間です' },
        { name: 'セイレーン', upright: '（正）今こそ自分を魅せるとき', reversed: '（逆）誘惑に注意' },
        { name: 'カーバンクル', upright: '（正）目指すチャンスはすぐそこに', reversed: '（逆）チャンスを逃がさないように' },
        { name: 'ユグドラシル', upright: '（正）どっしりと構えていましょう', reversed: '（逆）何か見落としはありませんか' },
        { name: 'フェアリー', upright: '（正）何か面白いことの起きる予感', reversed: '（逆）悪戯のつもりが裏目に出るかも' },
        { name: 'グリフォン', upright: '（正）新たな発見があるでしょう', reversed: '（逆）真実を見極めましょう' },
        { name: 'ペリュトン', upright: '（正）絆に救われるかもしれません', reversed: '（逆）過去の影よりも未来の光を' },
        { name: 'パーン', upright: '（正）無限の可能性が目の前に', reversed: '（逆）決めるのは後で良いでしょう' },
        { name: 'アルケニー', upright: '（正）手を動かすと良いでしょう', reversed: '（逆）天狗にはならないように' },
        { name: 'ウロボロス', upright: '（正）良き連鎖が得られるでしょう', reversed: '（逆）悪循環を断ちましょう' },
        { name: 'フェンリル', upright: '（正）切り替わりの時間です', reversed: '（逆）どんでん返しに注意' },
        { name: 'ホムンクルス', upright: '（正）知識は目の前に', reversed: '（逆）無理を通していませんか' },
        { name: 'ケット・シー', upright: '（正）芸は身を助けます', reversed: '（逆）よく考えて行動しましょう' },
        { name: 'ケサランパサラン', upright: '（正）思わぬ幸運に恵まれるかも', reversed: '（逆）風向きの変化を見逃さないで' },
        { name: 'グレムリン', upright: '（正）助言を得られるでしょう', reversed: '（逆）機械や道具のトラブルに注意' },
        { name: 'サンドマン', upright: '（正）穏やかに楽しく夢を見ましょう', reversed: '（逆）夢から目覚めましょう' },
        { name: '猫又', upright: '（正）気ままな行動が吉', reversed: '（逆）舞い上がってはいませんか' },
        { name: '八咫烏', upright: '（正）導きが得られるでしょう', reversed: '（逆）助言に耳を傾けましょう' },
        { name: 'バンシー', upright: '（正）涙で悲しみを流しましょう', reversed: '（逆）嬉し泣きの予感がします' },
        { name: 'ニンフ', upright: '（正）楽しくしゃべる時間です', reversed: '（逆）口は禍いの元' },
        { name: 'テュポーン', upright: '（正）大嵐の予感がします', reversed: '（逆）新しい道を切り拓きましょう' },
        { name: '北極星', upright: '（正）目指す道は明確です', reversed: '（逆）迷った時こそ立ち止まりましょう' }
    ]

    # デッキを占い用に準備する
    def prepare_enigma
        ENIGMAS.dup
    end

    # 占いの結果を取得する
    def draw_enigmas(enigmadeck, count)
        drawn_enigmas = [ ]

        # デッキをシャッフル
        shuffled_enigmadeck = enigmadeck.shuffle

        # 指定した枚数だけカードを引く
        count.times do
            enigma = shuffled_enigmadeck.pop # デッキからカードを取り除く
            orientation = [:upright, :reversed].sample # 正位置か逆位置かをランダムに設定
            drawn_enigmas << {
                name: enigma[:name],
                orientation: orientation,
                meaning: enigma[orientation]
            }
        end

        # 残りのデッキを更新して返す
        { drawn_enigmas: drawn_enigmas, remaining_enigmadeck: shuffled_enigmadeck }

    end

    def read_enigmas # 単体引き（飛び出し込み）
        # デッキを準備
        enigma_deck = prepare_enigma

        # 枚数を指定
        if SecureRandom.random_number(100) < 1
            number_of_enigmas = 3
        elsif SecureRandom.random_number(100) < 5
            number_of_enigmas = 2
        else number_of_enigmas = 1
        end

        # 結果を取得
        result = draw_enigmas(enigma_deck, number_of_enigmas)
        result[:drawn_enigmas]

    end

    def three_enigmas # 3枚引き
        # デッキを準備
        enigma_deck = prepare_enigma

        # 枚数を指定
        number_of_enigmas = 3

        # 結果を取得
        result = draw_enigmas(enigma_deck, number_of_enigmas)
        result[:drawn_enigmas]

    end
end
