class ReizoukoA
  # 設定温度を受け取ってインスタンス変数に保持する(インスタンスの中でのみ有効、オブジェクトが消滅するまで保持)
  # 無条件に実行、初期処理
  def initialize(num)
    @set_temperature = num.to_i      #目標の設定温度
    @temperature = 25
    @foodstuff = []
    power(:on)
    p "設定温度を #{@set_temperature} 設定しました。"
    p "現在の温度は #{@temperature} です。"
    p "#{@foodstuff.size} 個の食材があります。"
  end

  # 冷やす機能：一回の実行で-1℃ 冷える
  def cool_down
    @temperature -= 1 if @set_temperature < @temperature
    p "内部を冷やして #{@temperature} になりました。"
  end

  # ドアが開く機能
  # 内部温度が上昇する、食材を一覧表示する
  def open_door
    @temperature += 3
    p "内部温度が上昇して #{@temperature} になりました。"
    p "#{@foodstuff.size} この食材があります。"
    @foodstuff.each do |v|
      p v
    end
  end

  # 冷蔵庫に食材を入れる
  def put_in(str)
    @foodstuff << str
  end

  # 電源ON
  def power(onoff)
    p "電源が入りました" if onoff.to_sym == :on
    p "電源を切りました" if onoff.to_sym == :off
  end

  # 実行制御
  if __FILE__ == $0 then
    modelA = ReizoukoA.new(15)
    modelA.cool_down
    modelA.put_in("apple")
    modelA.open_door
    modelA.power(:off)
  end
end