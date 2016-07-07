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
        test_solution
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
      Thread.new do
        Test.where(task: submission.task).each do |test|
          test_solution_unit test, submission
        end
      end
    end

    def test_solution_unit(test, submission)
      t_sol = Thread.new do
        ans = `python3 -c "#{submission.solution.sub '"', '\"'}" <<< #{test.in}`
        if ans.split != test.out.split
          puts ans.split
          puts test.out.split
          submission.update status: 'WA'
        elsif submission.status == 'CH'
          submission.update status: 'OK'
        end
      end
      Thread.new do
        sleep 4
        if t_sol.alive?
          puts submission
          submission.update status: 'TL'
        end
      end
    end
end
