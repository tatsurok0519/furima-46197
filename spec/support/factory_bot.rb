RSpec.configure do |config|
  # FactoryBotのメソッドを`FactoryBot.`を省略して呼び出せるようにする設定
  # 例: FactoryBot.build(:user) -> build(:user)
  config.include FactoryBot::Syntax::Methods
end