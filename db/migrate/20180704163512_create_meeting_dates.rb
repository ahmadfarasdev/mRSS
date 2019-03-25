class CreateMeetingDates < ActiveRecord::Migration[5.0]
  def change
    create_table :meeting_dates do |t|
      t.integer :meeting_id
      t.date :date
      t.timestamps
    end
    Meeting.all.each do |meeting|
      md =   meeting.meeting_dates.new(date: meeting.date)
      md.save(validate: false)
    end
  end
end
