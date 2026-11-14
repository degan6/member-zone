module NotificationPreferencesData
  private

  def load_notification_preferences(user)
    @subject_user = user
    @grouped_categories = NotificationCategory.grouped_for_member(@subject_user)
    @opt_out_lookup = NotificationOptOut.where(user: @subject_user).each_with_object({}) do |row, hash|
      hash[row.category] ||= {}
      hash[row.category][row.channel] = true
    end
    @highlight_category = params[:highlight].presence
    @highlight_entry = NotificationCategory.find(@highlight_category) if @highlight_category.present?
    @optional_opt_out_count = count_optional_opt_outs
  end

  def count_optional_opt_outs
    NotificationOptOut.where(user: @subject_user).count do |row|
      NotificationCategory.opt_out_allowed?(row.category)
    end
  end
end
