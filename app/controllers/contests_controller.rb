class ContestsController < ApplicationController
  before_action :set_contest, only: %i(show edit update destroy)
  before_action :admin_only, except: %i(index show)

  # GET /contests
  # GET /contests.json
  def index
    @contests = Contest.all
  end

  # GET /contests/1
  # GET /contests/1.json
  def show
    @tasks = @contest.tasks
  end

  # GET /contests/new
  def new
    @contest = Contest.new
    @tasks = Task.all.order id: :desc
    @connected_tasks = []
  end

  # GET /contests/1/edit
  def edit
    @tasks = Task.all.order id: :desc
    # OH MY FUCKING GOD THAT IS FUCKING AMAZIG
    @connected_tasks = @contest.task_ids
  end

  # POST /contests
  def create
    @contest = Contest.new(contest_params)
    position = if last = Contest.group(position: :desc).take
                 last.position ? last.position + 1 : 0
               else
                 0
               end
    @contest.position = position

    respond_to do |format|
      if @contest.save
        connect_tasks JSON.parse(params[:selected_tasks])
        format.html { redirect_to @contest, notice: 'Contest was created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /contests/1
  def update
    respond_to do |format|
      if @contest.update(contest_params)
        connect_tasks JSON.parse(params[:selected_tasks])
        format.html { redirect_to @contest, notice: 'Contest updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /contests/1
  # DELETE /contests/1.json
  def destroy
    @contest.destroy
    respond_to do |format|
      format.html { redirect_to contests_url, notice: 'Contest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contest
    @contest = Contest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contest_params
    params.require(:contest).permit(:name, :position, :active, :description)
  end

  def connect_tasks(tasks)
    Contest.transaction do
      @contest.tasks.delete_all
      tasks.each do |task_id|
        ContestTask.create task_id: task_id, contest: @contest
      end
    end
  end
end
