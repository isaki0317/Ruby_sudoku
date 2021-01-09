ar = %w"aaa bb cc dd"

# "aa"があれば削除する

ar.delete_if do |v|
  v == "aa"
end
p ar

#文字列の長さでsort、他の条件も可能

# ar.sort_by! do |v|
#   v.size
# end
# p ar


# 文字列の最初と最後を操作、元のオブジェクトも変更されるので注意
# pop = 最後尾取り出し、 push = 最後尾に追加
# unshiht = 先頭に追加、 shiht = 先頭から取り出す
# v = ar.pop

# p v + "を取り出した"
# p ar

#配列同士の連結
#配列同士の引き算は引かれる側がメインになる
#<< 配列の追加、配列の末尾に追加
# ar1 = %w"apple banana"
# ar2 = %w"cherry orange apple"

# p ar1 << "aaaaa"


# ハッシュのeach文、ハッシュは厳密には順番が保証されていない
# hs = {apple: 100,
#       bahaha: 220}

# hs.each do |k, v|
#   p k
#   p "==>" + v.to_s
# end

# 特定の条件を抽出(反対はreject!(除外)、削除はdelete(キーを指定)、delete_ifも使える)
# hs.select! do |k, v|
#   v < 200
# end
# p hs

# ハッシュに対する便利なメソッド
# has_key? キーの存在確認
# has_value? 値の存在確認
# keys キーだけを取り出した配列を返す
# values 値だけを取り出した配列を返す