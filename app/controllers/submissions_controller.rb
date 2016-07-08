require 'shellwords'

class SubmissionsController < ApplicationController
  before_action :set_submission, only: %i(show edit update destroy)
  before_action :admin_only, except: %i(create index)

  # GET /submissions
  def index
    redirect_to '/login' unless current_user
    @submissions = Submission.all
  end

  # GET /tasks/1.json
  def show
    code = CodeRay.scan(@submission.solution, :python).div
    respond_to do |format|
      format.json do
        render json: { title: "Submission ##{@submission.id}",
                       body: code,
                       output: @submission.bad_out }
      end
    end
  end

  # POST /submissions.json
  def create
    @submission = Submission.new
    solution = params[:solution].read
    @submission.solution = solution
    @submission.timestamp = Time.now
    @submission.user = current_user
    @submission.task_id = params[:task_id]

    if @submission.save
      TestSubmissionJob.perform_later @submission
    else
      respond_to do |format|
        format.json do
          render json: { errors: @submission.errors },
                 status: :internal_server_error
        end
      end
    end
  end

  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_submission
    @submission = Submission.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def submission_params
    params.permit(:solution, :task_id, :authenticity_token)
  end
end
