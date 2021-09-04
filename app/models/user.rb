class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[line google_oauth2]
  has_many :shifts, dependent: :destroy
  has_many :administrators, dependent: :destroy
  # accepts_nested_attributes_for :administrators, allow_destroy: true

  # validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{8}\z/i }, on: :create
  # validates :password, on: :create
  # validates :password, format: { message: 'は半角英数混合で6文字です' }, allow_blank: true, on: :update
  

  # attr_accessor :remember_token
  # before_save { self.email = email.downcase }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :name,  presence: true, length: { maximum: 50 }
  # validates :email, presence: true, length: { maximum: 100 },
                    # format: { with: VALID_EMAIL_REGEX },
                    # uniqueness: true
  # validates :basic_time, presence: true
  
  # validates :employee_number, presence: true, uniqueness: true
  # validates :classification, uniqueness: true
  # has_secure_password
  # validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # def User.digest(string)
  #   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  #   BCrypt::Password.create(string, cost: cost)
  # end
  
  # def User.new_token
  #   SecureRandom.urlsafe_base64
  # end
  
  # def remember
  #   self.remember_token = User.new_token
  #   update_attribute(:remember_digest, User.digest(remember_token))
  # end
  
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end
  
  # def forget
  #   update_attribute(:remember_digest, nil)
  # end

  # 編集画面
  def update_without_current_password(params, *options)
    params.delete(:current_password)
 
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
 
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  # def update_without_current_password(params)
  #   if params[:password].blank? && params[:password_confirmation].blank?
  #     params.delete(:password)
  #     params.delete(:password_confirmation)
  #   end
  #   update(params)
  # end
  
  # google
  # omniauthのコールバック時に呼ばれるメソッド
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0,20]
    end
  end
  # googleログイン終わり

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]
    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
    # byebug
    # password = 
    # self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end  
  
  def self.search(search) #ここでのself.はUser.を意味する
    if search
      where(['name LIKE ?', "%#{search}%"]) #検索とnameの部分一致を表示。#User.は省略
    else
      all #全て表示。#User.は省略
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      user = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      user.attributes = row.to_hash.slice(*updatable_attributes)
      # 保存する
      user.save
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["name", "email", "employment_status", "employee_number", "password","basic_time", "basic_startwork_time","basic_finishwork_time" ]
  end

end
