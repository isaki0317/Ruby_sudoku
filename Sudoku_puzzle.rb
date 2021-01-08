# 数独を解く役目を持つclass
class SudokuSolver
  FIELD_SIZE = 9
  GRID_SIZE = 3
  ALL_NUMBER = (1..9).to_a

  # 盤面を読み取って配列として保持する
  def initialize
    # DATAを読み取り、deleteで改行コードの削除、splitで一文字ごとに分割して配列にし、mapで全て数値に変換してインスタンス変数へ代入
    @field = DATA.read.delete("\n").split("").map(&:to_i)
  end

#  文字列を受け取って表示するだけ
  def display(str=@field.join)
    field = str.delete("\n").split("").map(&:to_i)
    p "-" * 30
    field.each_slice(FIELD_SIZE) do |ar|
      p ar.join
    end
  end

  # 81マスをスキャンして、候補が１つしかないセルを探して確定させる
  def scan_and_fix
    @field.size.times do |i|
      next if @field[i] != 0   #セルが0じゃなければ処理をスキップして次のiの判定を行う(ここでの0は未確定のセル)
      c = list_candidates(i)
      @field[i] = c[0] if c.size == 1     #cの配列のsizeが1なら、セルにはいる候補は決まっているので確定させる
    end
  end

  # 盤面が変化しなくなるまで、scan_and_fixを何度も実行する
  def basic_solve
    old_field = []
    until @field == old_field do    # == の条件を満たすまで、処理を繰り返す(盤面を更新できなくなるまで)
      old_field = @field
      scan_and_fix
    end
  end

  # 深さ優先探索の制御ロジック、スタック(dataを上に積み上げ、上から使う)を活用する  スタックとは別の構造をとる場合はキュー(先入先出)
  def deep_solve
    stack = []
    stack << @field.join

    field = loop do
      # スタックがなくなるか、壁面が完成したら終了
      break nil   if (field = stack.pop).nil?           #popで一番上の物を取り出す
      break field if (idx = field.index("0")).nil?       #0(未探索)がなくなったらその時点で終了
      #派生した盤面リストを取得する(fieldに格納)
      list = simulate(field)
      next if list.empty?                 #listが空の場合はスキップする
      stack << list
      stack.flatten!                 # flattenメソッドで多次元配列を1次元配列に変換して積んでいく
    end
    return field
  end

  # 盤面(文字列)を受け取り、特定の1セルの派生する可能性を網羅する、可能性の分だけ盤面を複製して一覧を返す
  def simulate(str)
    @field = str.delete("\n").split("").map(&:to_i)
    # 候補を洗い出す
    idx = @field.index(0)     #インデックスの値が0のセルだけ取得
    c = list_candidates(idx)  #定義済みのメソッドで候補の数字を洗い出す

    #候補の分だけ盤面を複製する
    list = []
    c.each do |v|
      @field[idx] = v
      list << @field.join.dup    #結果を文字列の分だけ複製して変数に格納(文字列のほうがメモリ容量等で利点がある)
    end
    return list
  end


  # 指定のインデックスが含まれる列・行・グリッドを精査して、数字の候補を一覧にして返す
  def list_candidates(idx)
    indexes = []
    indexes << row_indexes(idx)
    indexes << col_indexes(idx)
    indexes << grid_indexes(idx)
    indexes.flatten!.uniq!        # オブジェクト自体を1次元配列に変換し、重複した値を削除

    # インデックスの値を全て取得する
    values = @field.values_at(*indexes)
    values.select!{|v| v != 0}.uniq!      #値が0でないものだけ取得して、重複してる場合は削除する
    list = ALL_NUMBER - values            #配列から配列を引き算している?
    return list
  end

    # インデックス番号を受け取り、その行のインデックス番号を一覧で返す
  def row_indexes(idx)
    y = idx / FIELD_SIZE # 何行目に相当するか
    min = y * FIELD_SIZE
    max = min + (FIELD_SIZE-1)
    return (min..max).to_a
  end

  # インデックス番号を受け取り、その列のインデックス番号を一覧で返す
  def col_indexes(idx)
    # idxが3なら下記の計算は3が返る、もちろん10なら1
    x = idx % FIELD_SIZE  #何列目に相当するか
    list = []
    max = FIELD_SIZE * FIELD_SIZE - 1
    x.step(max, FIELD_SIZE) do |i|
      list << i
    end
    return list
  end

  # インデックス番号を受け取り、そのグリッドのインデックス番号を一覧で返す
  def grid_indexes(idx)
    x = idx % FIELD_SIZE # 何列目に相当するか
    y = idx / FIELD_SIZE # 何行目に相当するか

    # グリッドの最小値(スタート位置)を算出する
    grid_x = x / GRID_SIZE
    grid_y = y / GRID_SIZE
    start_idx = (grid_y * GRID_SIZE * FIELD_SIZE) + (grid_x * GRID_SIZE)

    #グリッドのインデックスを一覧にする
    list = []
    # stepでstart_idxに1を2回足す
    start_idx.step(start_idx + 2) do |n|
      # nがグリッドの１列目、n + FIELD_SIZEがグリッド2列目、残りが3列目
      list << [n, n + FIELD_SIZE, n + FIELD_SIZE * 2]
    end
    # flattenメソッドで多次元配列を1次元配列に変換し、sortで小さい順に並び替え
    return list.flatten.sort
  end


end


# 実行制御
if __FILE__ == $0 then
  masao = SudokuSolver.new
  masao.display

 # 単純な解法で解いてみる
  masao.basic_solve
  # 数字を仮置きして深さ優先探索
  field = masao.deep_solve
  # 正解を表示
  masao.display(field) if field
end

# DATE定数で読みだすことができる
__END__
100009004
800652070
000000600
760000000
090000050
010000026
004000700
050306000
300004001