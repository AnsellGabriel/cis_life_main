class MemberPresenter
  def initialize(member)
  @member = member
end

  def valid_dependents
    case @member.civil_status
    when "Married"
      ['Spouse', 'Child']
    when "Single"
      ['Parent', 'Sibling']
    else
      ['Parent', 'Child', 'Sibling']
    end
  end
end