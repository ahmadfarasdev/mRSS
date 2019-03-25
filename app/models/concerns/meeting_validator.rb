class MeetingValidator < ActiveModel::Validator
  def validate(record)
    mds = record.meeting_dates.select { |md| !md.marked_for_destruction? }
    joined_meeting = Meeting.joins(:meeting_dates).
        where(room_id: record.room_id).
        where(meeting_dates: { date: mds.map(&:date) }).
        where.not(id: record.id).
        where('(time_start BETWEEN :date_start AND :date_end) or (time_end BETWEEN :date_start AND :date_end) or (time_start < :date_start AND time_end > :date_end)',
              :date_start=> record.time_start + 1.minute,
              :date_end=> record.time_end - 1.minute).select('meeting_dates.date AS date')
      if joined_meeting.present?
        record.errors[:base]<< "Time is not available for this room for these dates #{joined_meeting.map(&:date).map(&:to_date)}"
      end

      if record.new_record? and mds.any? { |md| md.date.to_date < Date.today.to_date }
        record.errors[:base]<< 'Cannot save meeting from the past'
      end

      if mds.blank?
        record.errors[:base]<< 'No dates selected'
      end

      if (d = mds.detect { |md| md.date.to_date == Date.today.to_date })
        time_start = record.time_start + (d.date.to_date - record.time_start.to_date).to_i.days
        if Time.parse(time_start.strftime("%H:%M"), d.date.to_time) < Time.now
          record.errors[:base]<< 'Cannot save meeting from the past'
        end
      end
      if record.time_end <= record.time_start
        record.errors[:time_start] <<  'should be before end time'
      end
  end
end
