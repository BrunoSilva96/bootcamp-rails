class SystemRequirement < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :operational_system, presence: true, uniqueness: { case_sensitive: false }
  validates :storage, presence: true, uniqueness: { case_sensitive: false }
  validates :processor, presence: true, uniqueness: { case_sensitive: false }
  validates :memory, presence: true, uniqueness: { case_sensitive: false }
  validates :video_board, presence: true, uniqueness: { case_sensitive: false }
end
