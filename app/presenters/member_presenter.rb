class MemberPresenter
  def initialize(member)
  @member = member
end

  def valid_dependents
    case @member.civil_status.downcase
    when "married"
      ['Spouse', 'Child']
    when "single"
      ['Parent', 'Sibling']
    else
      ['Parent', 'Child', 'Sibling']
    end
  end
end
