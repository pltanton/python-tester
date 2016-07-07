require 'shellwords'

class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy]

  # GET /submissions
  # GET /submissions.json
  def index
    redirect_to '/login' unless current_user
    @submissions = Submission.all
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @submission = Submission.new
    solution = params[:solution].read
    @submission.solution = solution
    @submission.timestamp = Time.now
    @submission.user = current_user
    @submission.task_id = params[:task_id]

    respond_to do |format|
      if @submission.save
        t = test_solution
        format.html { redirect_to :back, notice: 'Submission was successfully created.' }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
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

  def test_solution
    submission = @submission
    Spawnling.new do
      ok = true
      Test.where(task: submission.task).each do |test|
        status, output = test_solution_unit test, submission
        case status
        when :TL
          submission.update status: 'TL'
          ok = false
          break
        when :WA
          submission.update status: "WA ##{test.id}"
          ok = false
          break
        end
      end
      submission.update status: 'OK' if ok
    end
  end

  def test_solution_unit(test, submission)
    begin
      stdout = ''
      status = open4.spawn(
        "python -c #{Shellwords.escape submission.solution}",
        timeout: 3,
        stdout: stdout,
        stdin: test.in
      )

      if status.exitstatus == 0 && stdout.squish == test.out.squish
        puts 'here'
        :OK
      else
        :WA
      end
    rescue Timeout::Error
      :TL
    end
  end
end
