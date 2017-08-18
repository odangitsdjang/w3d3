# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  poll_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ApplicationRecord
  validates :poll_id, :content, presence: true
  has_many :answers,
           primary_key: :id,
           foreign_key: :question_id,
           class_name: :AnswerChoice
  belongs_to :poll,
           primary_key: :id,
           foreign_key: :poll_id,
           class_name: :Poll

  has_many :responses, through: :answers, source: :responses

  def results

    counts_hash = Hash.new(0)
    answers.each do |answer|
      counts_hash[answer.content] = answer.responses.length
    end
    counts_hash
  end
end
