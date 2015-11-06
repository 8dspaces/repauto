module Api
  class ProjectsController < Api::BaseController
    before_action :set_resource, only: [:show, :run_names, :trend, :summary]

    def run_names
      names = @project.test_runs.distinct(:name)
      # @types = TestRun.where(project_path: @project.path).distinct(:type)
      respond_with names
    end

    def trend
      query = @project
        .test_runs
        .active
        .where(:start.ne => nil)

      if params[:name]
        query = query.where(name: params[:name])
      end

      query = query.sort(start: -1).limit(30)
      @trend = query.map do |test_run|
        # data = test_run.counts.clone
        data = Report.of(test_run).original_status.clone
        data[:time] = test_run.start
        data
      end
      respond_with @trend
    end

    def summary
      query = @project
        .test_runs
        .active
        .where(:start.ne => nil)
        .sort(start: -1)
        .limit(30)

      stats = {ori: {}, proc: {}, total_runs: 0}
      stats = query.reduce(stats) do |memo, test_run|
        report = Report.of(test_run)
        memo[:ori].merge!(report.original_status){ |_k, a, b| a + b }
        memo[:proc].merge!(report.processed_status){ |_k, a, b| a + b }
        memo[:total_runs] += 1
        memo
      end
      respond_with stats
    end

    # def query_params
    #   params.permit(:path)
    # end
  end
end
