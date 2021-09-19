require 'charlock_holmes'
require 'csv'

#CSVファイルのパスを指定
path = 'path/to/x-ken-all.csv'

# ファイル読み込みとエンコードを推測
detection = CharlockHolmes::EncodingDetector.detect(File.read(path))
# CP932 を優先する
encoding = detection[:encoding] == 'Shift_JIS' ? 'CP932' : detection[:encoding]