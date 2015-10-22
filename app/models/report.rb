class Report
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  embedded_in :test_run
  field :original_status, type: Hash
  field :processed_status, type: Hash
  field :todo, type: Integer

  def self.gen(test_run)
    ori = {}
    pro = {}
    todo = 0
    total = 0
    test_run.test_cases.each do |tc|
      ori[tc.status] ||= 0
      ori[tc.status] += 1
      ps = tc.processed_status
      pro[ps] ||= 0
      pro[ps] += 1
      todo += 1 if tc.status != 'passed' && !tc.has_comments?
      total += 1
    end
    Report.new(original_status: ori, processed_status: pro, todo: todo)
  end
end