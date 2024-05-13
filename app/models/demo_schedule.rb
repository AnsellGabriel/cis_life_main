class DemoSchedule < ApplicationRecord
    validates_presence_of :cooperative, :name, :contact_no, :demo_date, :time_slot
    def to_s
        cooperative
    end

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

    enum status: {
        pending: 0,
        meeting_set: 1,
        cancelled: 2,
        done: 3
    }

    enum time_slot: {
        morning: 0,
        afternoon: 1
    }

    enum method: {
        virtual_meeting_zoom: 0,
        face_to_face: 1
    }
    # Method = [ "Virtual Meeting (Zoom)", "Face to Face", "Others" ]
end
