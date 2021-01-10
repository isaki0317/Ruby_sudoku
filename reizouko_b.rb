require "./reizouko.rb"
class ReizoukoB < ReizoukoA
  # 冷やす機能：一回の実行で-1℃ 冷える
  def cool_down
    @temperature -= 3
    p "冷やす機能がパワーアップしました"
    p "内部を冷やして #{@temperature} になりました。"
  end
end

# 実行制御
if __FILE__ == $0 then
  modelA = ReizoukoA.new(15)
  modelA.cool_down
  modelA.put_in("apple")
  modelA.open_door
  modelA.power(:off)
end