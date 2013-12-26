class User < ActiveRecord::Base
   validates :name,:presence => true ,:uniqueness => true
   has_secure_password
   #validates_presence_of :password
   validates_presence_of :password_question,:password_question_answer
   #attr_accessor :remember_me
end