class DemoSchedule < ApplicationRecord
    validates_presence_of :cooperative, :name, :contact_no, :demo_date, :time_slot
    def to_s
        cooperative
    end

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :check_schedule
    

    def check_schedule 
        @schedule = DemoSchedule.where(demo_date: demo_date, time_slot: time_slot)
        if @schedule.present?
            errors.add(:base,"Hey there, it seems like that particular time slot has already been booked. No worries though! Let's find another time that works just as well for you. Please select an alternative date or time from the available options, and we'll make sure to accommodate you as best as we can.")
        end
    end

    enum status: {
        pending: 0,
        meeting_set: 1,
        cancelled: 2,
        done: 3
    }

    enum time_slot: {
        morning_9_to_11_AM: 0,
        afternoon_2_to_4_PM: 1
    }

    enum method: {
        virtual_meeting_zoom: 0,
        face_to_face: 1
    }
    # Method = [ "Virtual Meeting (Zoom)", "Face to Face", "Others" ]
end
