module GroupRemitHelper
  def is_mis_user_and_entry?(group_remit)
    (current_user.is_mis? and group_remit.mis_entry?)
  end

  def is_coop_user_and_entry?(group_remit)
    (current_user.is_coop_user? and !group_remit.mis_entry?)
  end
end
