module Api
  class TestRunsController < Api::BaseController
    before_action :set_resource, only: [:show, :update, :archive, :restore]
    include ParamTool

    api! 'List all test runs under project.'
    def index
      project = Project.find(params[:project_id])
      query = project.test_runs
        .where(query_params)
        .page(page_params[:page])
        .per(page_params[:page_size])
        .order_by(start: 'desc')
      @test_runs = query
    end

    api! 'Archive test run.'
    def archive
      @test_run.update_attributes(archived_at: Time.zone.now)
      @test_run.save!
    end

    api! 'Restore (unarchive) test run.'
    def restore
      @test_run.remove_attribute(:archived_at)
      @test_run.save!
    end

    api! 'Diff two test runs.'
    param :id1, String, desc: 'first test run id', required: true
    param :id2, String, desc: 'second test run id', required: true
    def diff
      tr1 = TestRun.find(params[:id1])
      tr2 = TestRun.find(params[:id2])
      @prev, @current = [tr1, tr2].sort_by(&:start).map(&:test_cases)
    end

    api! 'Create a new test run.'
    param :project_id, String, desc: 'project id', required: true
    param :name, String, desc: 'test run name', required: true
    param :status, ['running', 'done'], desc: 'test run current status', required: true
    description <<-EOS
Create a new test run.
    EOS
    def create
      begin
        validate_params([:project_id, :name, :status], params)
        project = Project.find(params[:project_id])
        @test_run = project.test_runs.build(name: params[:name], start: Time.now, status: params[:status])
        @test_run.save!
      rescue StandardError => error
        @error = error
      end
    end

    api!
    def update

    end

    def order_params
      { sn: 'desc' }
    end

    def query_params
      custom_params = params.permit(:project, :name, :archived)
      archived = custom_params.delete(:archived)
      custom_params[:archived_at.exists] = archived
      custom_params[:start.exists] = true
      custom_params
    end
  end
end
