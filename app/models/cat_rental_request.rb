# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :datetime         not null
#  end_date   :datetime         not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: ['APPROVED', 'DENIED', 'PENDING'] }
  validate :no_overlapping_approved_requests

  belongs_to :cat

  def approved?
    status == 'APPROVED'
  end

  def pending?
    status == 'PENDING'
  end

  def approve!
    self.status = 'APPROVED'

    CatRentalRequest.transaction do
      save!
      overlapping_requests.each do |request|
        request.deny!
      end
    end
  end

  def deny!
    self.status = 'DENIED'
    save!
  end

  private

  def after_initialize
    status ||= 'PENDING'
  end

  def overlapping_requests
    return [] if start_date.nil? || end_date.nil?
    requests = cat.rental_requests
    overlaps = []
    requests.each do |request|
      next if request == self
      if (request.start_date - end_date) * (start_date - request.end_date) >= 0
        overlaps << request
      end
    end

    overlaps
  end

  def no_overlapping_approved_requests
    if approved? && overlapping_requests.any?(&:approved?)
      errors[:status] << "cannot be approved when another approved request overlaps time slots"
    end
  end

end
