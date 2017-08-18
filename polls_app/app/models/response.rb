# == Schema Information
#
# Table name: responses
#
#  id         :integer          not null, primary key
#  answer_id  :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Response < ApplicationRecord
  validates :answer_id, :user_id, presence: true
  validate :not_alreday_answered?
  belongs_to :answer,
             primary_key: :id,
             foreign_key: :answer_id,
             class_name: :AnswerChoice
  belongs_to :respondent,
            primary_key: :id,
            foreign_key: :user_id,
            class_name: :User

  has_one :question, through: :answer, source: :question

  def sibling_response
    question.responses.where.not(id: self.id)
  end

  def respondent_is_creator?
    question.poll.user_id == self.user_id
  end

  def not_alreday_answered?
    ! respondent_already_answered?
  end
  def respondent_already_answered?
    sibling_response.exists?(user_id: self.user_id)
  end


end
