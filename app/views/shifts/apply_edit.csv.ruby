require 'csv'

CSV.generate do |csv|
  csv_column_names = %w('日付' '名前' '開始' '終了')
  csv << csv_column_names
  @groups.each do |id, users|
    users.each do |user|
    # byebug
      user.shifts.each do |shift|

        #   @attendances.each do |day|
        # if day.edit_superior.present? && (day.instructor == nil || day.instructor == "なし" || day.instructor == "申請中")
        #  csv_column_values = [ 
          # day.worked_on
        # ]
        # else
        csv_column_values = [ 
          shift.worked_on&.strftime("%-m/%-d"),
          user.name,
          shift.determined_arrival_time&.strftime("%H:%M"), 
          shift.decided_leaving_time&.strftime("%H:%M"),
          # day.started_at,
          # day.finished_at,
        ]
        # end
        csv << csv_column_values
      end
    end
  end
end
